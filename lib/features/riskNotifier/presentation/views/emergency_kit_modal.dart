import 'package:flutter/material.dart';

class EmergencyKitModal extends StatelessWidget {
  const EmergencyKitModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Afet Çantasında Olması Gerekenler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '- Su (kişi başı en az 3 gün yetecek kadar)\n'
            '- Dayanıklı yiyecekler (konserve, kuru meyve, vb.)\n'
            '- İlkyardım malzemeleri\n'
            '- Fener ve yedek piller\n'
            '- Battaniye veya uyku tulumu\n'
            '- Kişisel hijyen malzemeleri\n'
            '- Nakit para ve önemli belgeler\n'
            '- Yedek kıyafetler ve ayakkabılar\n'
            '- Cep telefonu ve yedek batarya/şarj cihazı\n'
            '- Düdük (yardım çağırmak için)',
            style: TextStyle(fontSize: 16),
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
