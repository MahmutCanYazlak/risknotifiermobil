import 'dart:developer';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  cursorColor:
                      const Color.fromARGB(255, 28, 51, 69), // İmleç rengi
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
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
