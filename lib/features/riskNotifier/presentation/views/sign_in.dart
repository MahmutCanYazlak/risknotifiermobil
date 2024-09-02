import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:risknotifier/config/extensions/context_extension.dart';
import 'package:risknotifier/features/riskNotifier/presentation/views/home.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  )..repeat();

  bool _isObscure = true; // Şifreyi gizlemek/göstermek için kullanılan değişken
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Flutter Secure Storage instance
  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(httpClient);

    try {
      var response = await ioClient.post(
        Uri.parse('https://risknotifier.com/api/login'),
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var token = responseData['token']; // Token'ı response'dan al

        // Token'ı Flutter Secure Storage ile sakla
        await storage.write(key: 'auth_token', value: token);

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        var responseData = json.decode(response.body);
        var errorMessage = responseData['message'] ??
            'Giriş başarısız, bilgilerinizi kontrol edin.';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bir hata oluştu, lütfen tekrar deneyiniz.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      httpClient.close();
      ioClient.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log(size.toString());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.height * 0.4,
                  child: Center(
                    child: Image.asset("assets/images/sign_in.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Mobil Risk Bildirici! 👋",
                      style: context.textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(255, 28, 51, 69),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: Text(
                    "Lütfen size tanımlanan email ve şifre ile giriş yapınız.",
                    style: TextStyle(
                      fontSize: size.height * 0.020,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                TextField(
                  controller: _emailController,
                  cursorColor: const Color.fromARGB(255, 28, 51, 69),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 28, 51, 69),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(221, 57, 13, 1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(221, 57, 13, 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    cursorColor: const Color.fromARGB(255, 28, 51, 69),
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 28, 51, 69),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(221, 57, 13, 1),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(221, 57, 13, 1),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(255, 28, 51, 69),
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: _login,
                  color: const Color.fromRGBO(221, 57, 13, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: Colors.white,
                  minWidth: double.infinity,
                  child: Text(
                    'Giriş Yap',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
