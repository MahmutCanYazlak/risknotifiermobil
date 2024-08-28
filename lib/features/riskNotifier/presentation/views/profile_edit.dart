import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  XFile? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  void _saveProfile() {
    // Burada profil bilgilerini kaydetmek için gerekli işlemleri yapabilirsiniz
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil bilgileri güncellendi!')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color.fromARGB(255, 28, 51, 69),
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage as dynamic)
                    : null,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt,
                        size: 40, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Ad',
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
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Soyad',
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
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Telefon Numarası',
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
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 28, 51, 69),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Profili Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
