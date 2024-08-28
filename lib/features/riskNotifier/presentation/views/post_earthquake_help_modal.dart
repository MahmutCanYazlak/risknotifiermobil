import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PostEarthquakeHelpModal extends StatefulWidget {
  const PostEarthquakeHelpModal({super.key});

  @override
  _PostEarthquakeHelpModalState createState() =>
      _PostEarthquakeHelpModalState();
}

class _PostEarthquakeHelpModalState extends State<PostEarthquakeHelpModal> {
  final PageController _pageController = PageController();
  final List<String> _helpGuidePages = [
    '- Yaralıları kontrol edin ve ilk yardım uygulayın.\n'
        '- Tehlikeli yerlerden uzak durun.\n'
        '- Yardım ekiplerine ulaşın ve çevrenizdeki insanları bilgilendirin.',
    '- Acil durum numaralarını arayarak durumu bildirin.\n'
        '- Güvenli bir yere geçin ve artçı sarsıntılara karşı hazırlıklı olun.\n'
        '- Gaz, su ve elektrik hatlarını kontrol edin, tehlike varsa kapatın.',
    '- Radyodan veya mobil cihazlardan resmi uyarıları takip edin.\n'
        '- Yetkililerin yönlendirmelerini izleyin ve panik yapmayın.\n'
        '- Gerektiğinde yardım ekiplerine katılın ve destek olun.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deprem Sonrası Yardım Rehberi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _helpGuidePages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _helpGuidePages[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _helpGuidePages.length,
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Color.fromARGB(255, 28, 51, 69),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 28, 51, 69),
                foregroundColor: Colors.white,
              ),
              child: const Text('Kapat'),
            ),
          ),
        ],
      ),
    );
  }
}
