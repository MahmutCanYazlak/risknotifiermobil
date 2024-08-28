import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:risknotifier/features/riskNotifier/presentation/views/directions_car.dart';
import 'package:risknotifier/features/riskNotifier/presentation/views/emergency_kit_modal.dart';
import 'package:risknotifier/features/riskNotifier/presentation/views/post_earthquake_help_modal.dart';
import 'package:risknotifier/features/riskNotifier/presentation/views/profile_edit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart'; // Cupertino widgets için eklendi
import '../widgets/circle_navbar.dart';
import 'medical_services.dart';
import 'search.dart'; // SearchPage'in import edilmesi

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 3;
  String _statusMessage = "Geri Sayım Başladı";
  Timer? _timer;
  int _currentIndex = 2; // Başlangıçta Ana Sayfa olarak ayarladım.
  int _switchValue = 0; // Switch'in varsayılan değeri ortada (belirsiz).

  final List<String> titles = [
    'Arama',
    'Profil',
    'Ana Sayfa',
    'İlaç Ekle',
    'Araç Ekle',
  ];

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
      _counter = 5;
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

                  // Eğer switch değeri belirsizde kalırsa, "Yardıma İhtiyacım Var" olarak ayarla
                  if (_switchValue == 0) {
                    _switchValue = 2;
                  }

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
                  CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: Colors.grey.shade300,
                    thumbColor: _switchValue == 1
                        ? Colors.green
                        : _switchValue == 2
                            ? Colors.red
                            : Colors.grey.shade400,
                    groupValue: _switchValue,
                    children: const <int, Widget>{
                      1: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Güvendeyim',
                            style: TextStyle(color: Colors.green)),
                      ),
                      0: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Belirsiz',
                            style: TextStyle(color: Colors.black)),
                      ),
                      2: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Yardıma İhtiyacım Var',
                            style: TextStyle(color: Colors.red)),
                      ),
                    },
                    onValueChanged: (int? value) {
                      setState(() {
                        _switchValue = value!;

                        // Eğer "Güvendeyim" seçilirse, ekranı kapat ve anasayfada kal
                        if (_switchValue == 1) {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        }
                      });
                    },
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Widget> bodyItems = [
      SearchScreen(), // Arama sayfası buraya eklendi
      const ProfileEditPage(), // Boş ekran yerine ProfileEditPage eklendi
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                  style: TextStyle(fontSize: size.height * 0.02),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return const PostEarthquakeHelpModal();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 28, 51, 69),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Deprem Sonrası Bilgilendirme'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return const EmergencyKitModal();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 28, 51, 69),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Afet Çantasında Olması Gerekenler'),
              ),
              const SizedBox(height: 20),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  height: 350,
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
      const MedicalServices(),
      const Vehicle(), // DirectionsCar sayfasını buraya ekleyin
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          titles[_currentIndex], // Her sayfa değişiminde başlığı güncelle
          style: const TextStyle(
            color: Color.fromARGB(255, 28, 51, 69),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: bodyItems[_currentIndex],
      bottomNavigationBar: CircleNavbar(
        _currentIndex,
        (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
