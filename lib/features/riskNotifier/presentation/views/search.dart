import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arama Ekranı"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Burada çıkış yapılacak işlemleri gerçekleştirin
            // Örneğin, kullanıcı oturumunu kapatma ve yerel verileri temizleme
            Navigator.pushReplacementNamed(context, '/sign_in');
          },
          child: const Text('Çıkış Yap'),
        ),
      ),
    );
  }
}
