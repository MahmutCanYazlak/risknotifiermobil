import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _counter = 3;
  String _statusMessage = "Acil Durum";
  String _currentAddress = "Adres belirleniyor...";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Timer'ı temizleyin
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      // Check for location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert the position into a readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          _currentAddress =
              "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}";
        });
      } else {
        setState(() {
          _currentAddress = "Adres bulunamadı.";
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Adres bulunamadı: $e";
      });
    }
  }

  void _startCountdown() {
    setState(() {
      _counter = 3;
      _statusMessage = "Geri Sayım Başladı";
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              _timer =
                  Timer.periodic(const Duration(seconds: 1), (Timer timer) {
                if (_counter > 0) {
                  setState(() {
                    _counter--;
                  });
                } else {
                  setState(() {
                    _statusMessage = "Bitti";
                  });
                  timer.cancel();
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop(); // Modal pencereyi kapat
                  }
                }
              });

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Geri Sayım: $_counter',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_counter == 0)
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log(size.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anasayfa"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusMessage,
              style: TextStyle(
                fontSize: size.height * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: _startCountdown,
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              textColor: Colors.white,
              minWidth: double.infinity,
              child: Text(
                'Acil Durum Butonu',
                style: TextStyle(fontSize: size.height * 0.03),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Adresiniz:',
              style: TextStyle(
                fontSize: size.height * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _currentAddress,
              style: TextStyle(
                fontSize: size.height * 0.025,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
