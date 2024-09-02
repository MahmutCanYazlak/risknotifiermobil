import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure Storage'ı import edin

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _tcNumberController = TextEditingController();
  final _birthDateController = TextEditingController();

  final _storage = const FlutterSecureStorage(); // Secure Storage instance'ı

  String? _selectedBloodType; // Seçilen kan grubu için değişken

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token'); // Token'ı storage'dan oku
  }

  Future<void> _fetchUserProfile() async {
    var dio = Dio();
    // ignore: deprecated_member_use
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    try {
      var token = await _getToken(); // Token'ı al

      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      var response = await dio.get(
        'https://risknotifier.com/api/mobil',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType
              .plain, // Yanıtın plain text olup olmadığını kontrol edin
        ),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.data); // JSON formatında ise işleme
        var userData = data['data'][0]; // Giriş yapan kullanıcının bilgileri

        _nameController.text = userData['name'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _genderController.text = userData['gender'] ?? '';
        _tcNumberController.text = userData['tc_number'] ?? '';
        _selectedBloodType = userData['blood_type'] ?? '';
        _birthDateController.text = userData['birth_date'] ?? '';

        setState(() {}); // Seçilen kan grubunu güncellemek için
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil bilgileri yüklenemedi: $e')),
      );
    }
  }

  Future<void> _updateUserProfile() async {
    var dio = Dio();
    // ignore: deprecated_member_use
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    try {
      var token = await _getToken(); // Token'ı al

      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      var response = await dio.post(
        'https://risknotifier.com/api/mobil/guest',
        data: FormData.fromMap({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'gender': _genderController.text,
          'tc_number': _tcNumberController.text,
          'blood_type': _selectedBloodType,
          'birth_date': _birthDateController.text,
        }),
        options: Options(headers: {
          'Authorization': 'Bearer $token'
        }), // Token burada kullanılıyor
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil güncellendi!')),
        );
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil güncellenemedi: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _tcNumberController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: 120, // Resim genişliği
                height: 120, // Resim yüksekliği
                fit: BoxFit.cover, // Resmin tamamını kapsayacak şekilde ayarla
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Ad',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 28, 51, 69)),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Telefon Numarası',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 28, 51, 69)),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(
                labelText: 'Cinsiyet',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 28, 51, 69)),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tcNumberController,
              decoration: InputDecoration(
                labelText: 'TC Kimlik Numarası',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 28, 51, 69)),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedBloodType,
              onChanged: (newValue) {
                setState(() {
                  _selectedBloodType = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Kan Grubu',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 28, 51, 69)),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                ),
              ),
              items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', '0+', '0-']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Doğum Tarihi',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 28, 51, 69)),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(221, 57, 13, 1)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateUserProfile,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 28, 51, 69),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Profili Güncelle'),
            ),
          ],
        ),
      ),
    );
  }
}
