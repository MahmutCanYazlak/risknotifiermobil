import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';

import 'circle_navbar.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _counter = 3;
  String _statusMessage = "Geri Sayım Başladı";
  Timer? _timer;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      log("Error getting location: $e");
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
                    Navigator.of(context).pop();
                  }
                }
              });

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Geri Sayım: $_counter',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (_counter == 0)
                    Text(
                      _statusMessage,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _launchURL() async {
    const url = 'https://earthquake.usgs.gov/earthquakes/map/';
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anasayfa"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MaterialButton(
                onPressed: _startCountdown,
                color: const Color.fromRGBO(221, 57, 13, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                textColor: Colors.white,
                minWidth: double.infinity,
                child: Text(
                  'Acil Durum Butonu',
                  style: TextStyle(fontSize: size.height * 0.02),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _launchURL,
                child: const Text('Güvenli Yerler ve Deprem Bilgisi'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Bilgilendirme ve eğitim içerikleri için navigasyon işlemi
                },
                child: const Text('Deprem Eğitim ve Bilgilendirme'),
              ),
              const SizedBox(height: 15),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  height: 305, // Yüksekliği biraz artırdık
                ),
                items: [
                  {
                    'title': 'Depremden Önce Yapılması Gerekenler',
                    'items': [
                      '1. Acil çıkış planlarınızı gözden geçirin.',
                      '2. Acil çanta hazırlayın.',
                      '3. Ailenizle iletişim planı yapın.',
                      '4. Güvenli alanları belirleyin.',
                      '5. Eğitim ve tatbikatları tamamlayın.'
                    ]
                  },
                  {
                    'title': 'Deprem Anında Yapılması Gerekenler',
                    'items': [
                      '1. Sığınacak yerlere gidin.',
                      '2. Sert bir masa altına girin.',
                      '3. Kapı çerçevelerinden uzak durun.',
                      '4. Pencerelerden ve dış duvarlardan uzak durun.',
                      '5. Sabitlenmemiş mobilyalardan uzak durun.'
                    ]
                  },
                  {
                    'title': 'Depremden Sonra Yapılması Gerekenler',
                    'items': [
                      '1. Acil durum kitinizi kontrol edin.',
                      '2. Hasarları kontrol edin.',
                      '3. Aile iletişim planınızı uygulayın.',
                      '4. Yanan gaz veya elektrik kaynaklarını kontrol edin.',
                      '5. İkinci bir deprem için hazırlıklı olun.'
                    ]
                  },
                ].map((slide) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slide['title'] as String,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...List<Widget>.from(
                                (slide['items'] as List<String>).map(
                                  (item) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CircleNavbar(_currentIndex, (index) {
        setState(() {
          _currentIndex = index;
        });
      }),
    );
  }
}
