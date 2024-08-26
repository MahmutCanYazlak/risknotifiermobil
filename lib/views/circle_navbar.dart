import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBarExample extends StatefulWidget {
  const BottomNavBarExample({super.key});

  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  int _selectedIndex = 2; // Default olarak Ana Sayfa seçili

  static const List<Widget> _pages = <Widget>[
    Center(
        child: Text('Arama Sayfası Henüz Yapılmadı',
            style: TextStyle(fontSize: 24))),
    Center(
        child: Text('Profil Sayfası Henüz Yapılmadı',
            style: TextStyle(fontSize: 24))),
    IndexPage(), // Ana Sayfa
    MedicalServicesPage(), // İlaç Ekleme Sayfası
    Center(
        child: Text('Araç Ekleme Sayfası Henüz Yapılmadı',
            style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      // İlaç Ekleme sayfasına git
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MedicalServicesPage()),
      );
    } else if (index == 2) {
      // Ana Sayfa'ya git
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IndexPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CircleNavbar(_selectedIndex, _onItemTapped),
    );
  }
}
  int _selectedIndex = 2; // Default olarak Ana Sayfa seçili
  static const List<Widget> _pages = <Widget>[
    Center(
        child: Text('Arama Sayfası Henüz Yapılmadı',
            style: TextStyle(fontSize: 24))),
    Center(
        child: Text('Profil Sayfası Henüz Yapılmadı',
            style: TextStyle(fontSize: 24))),
    IndexPage(), // Ana Sayfa
    MedicalServicesPage(), // İlaç Ekleme Sayfası
    Center(
        child: Text('Araç Ekleme Sayfası Henüz Yapılmadı',
            style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      // İlaç Ekleme sayfasına git
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MedicalServicesPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CircleNavbar(_selectedIndex, _onItemTapped),
    );
  }
}

Widget CircleNavbar(int currentIndex, Function(int) onTap) {
  return CircleNavBar(
    activeIndex: currentIndex,
    activeIcons: const [
      Icon(Icons.search, color: Colors.white),
      Icon(Icons.person, color: Colors.white),
      Icon(Icons.home, color: Colors.white),
      Icon(Icons.medical_services, color: Colors.white),
      Icon(Icons.directions_car, color: Colors.white),
    ],
    inactiveIcons: const [
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
        child: Text("Ana Sayfa"),
      ),
      DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Text("İlaç Ekle"),
      ),
      DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Text("Araç Ekle"),
      ),
    ],
    color: const Color.fromRGBO(221, 57, 13, 1),
    height: 60,
    circleWidth: 60,
    onTap: onTap,
    circleShadowColor: const Color.fromRGBO(221, 57, 13, 1),
    circleColor: const Color.fromRGBO(221, 57, 13, 1),
  );
}

void main() {
  runApp(const MaterialApp(
    home: BottomNavBarExample(),
  ));
}

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
      ),
      body: const Center(
        child: Text('Bu Ana Sayfa', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class MedicalServicesPage extends StatelessWidget {
  const MedicalServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hastalık ve İlaç Ekle"),
      ),
      body: const Center(
        child: Text('Hastalık ve İlaç Ekleme Sayfası',
            style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
