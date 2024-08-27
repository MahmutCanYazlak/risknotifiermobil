import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget CircleNavbar(int currentIndex, Function(int) onTap) {
  return CircleNavBar(
    activeIndex: currentIndex,
    activeIcons: const [
      Icon(Icons.search, color: Colors.white),
      Icon(Icons.person, color: Colors.white),
      Icon(Icons.home, color: Colors.white),
      Icon(Icons.medical_services, color: Colors.white), // İlaç Ekle Icon
      Icon(Icons.directions_car, color: Colors.white), // Araç Ekle Icon
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
