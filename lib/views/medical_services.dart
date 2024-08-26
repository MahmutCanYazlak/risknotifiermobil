import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

class MedicalServicesPage extends StatefulWidget {
  const MedicalServicesPage({super.key});

  @override
  _MedicalServicesPageState createState() => _MedicalServicesPageState();
}

class _MedicalServicesPageState extends State<MedicalServicesPage> {
  final _diseaseController = TextEditingController();
  final _medicineNameController = TextEditingController();
  final _dosageController = TextEditingController();
  bool _isDiseaseAdded = false;
  String? _addedDisease;

  int _currentIndex = 0;

  void _addDisease() {
    setState(() {
      _addedDisease = _diseaseController.text;
      _isDiseaseAdded = true;
    });
  }

  void _addMedicine() {
    final String medicineName = _medicineNameController.text;
    final String dosage = _dosageController.text;

    // İlaç ekleme işlemleri burada yapılabilir
    print('Hastalık: $_addedDisease, İlaç: $medicineName, Dozaj: $dosage');

    // Formu sıfırlama
    _medicineNameController.clear();
    _dosageController.clear();
  }

  @override
  void dispose() {
    _diseaseController.dispose();
    _medicineNameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  Widget CircleNavbar() {
    return CircleNavBar(
      activeIndex: _currentIndex,
      activeIcons: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.search, color: Colors.white),
        Icon(Icons.person, color: Colors.white),
        Icon(Icons.medical_services, color: Colors.white), // Hastalık Ekle Icon
        Icon(Icons.directions_car, color: Colors.white), // Araç Ekle Icon
      ],
      inactiveIcons: const [
        DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Text("Ana Sayfa"),
        ),
        DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Text("Arama"),
        ),
        DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Text("Profil"),
        ),
        DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Text("Hastalık Ekle"),
        ),
        DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Text("Araç Ekle"),
        ),
      ],
      color: const Color.fromRGBO(221, 57, 13, 1),
      height: 60,
      circleWidth: 60,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          // Handle navigation logic based on the index if needed
        });
      },
      circleShadowColor: const Color.fromRGBO(221, 57, 13, 1),
      circleColor: const Color.fromRGBO(221, 57, 13, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hastalık ve İlaç Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isDiseaseAdded) ...[
              TextField(
                controller: _diseaseController,
                decoration: const InputDecoration(
                  labelText: 'Hastalık Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addDisease,
                child: const Text('Hastalık Ekle'),
              ),
            ] else ...[
              Text(
                'Eklenen Hastalık: $_addedDisease',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _medicineNameController,
                decoration: const InputDecoration(
                  labelText: 'İlaç Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dozaj',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addMedicine,
                child: const Text('İlaç Ekle'),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CircleNavbar(),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MedicalServicesPage(),
  ));
}
