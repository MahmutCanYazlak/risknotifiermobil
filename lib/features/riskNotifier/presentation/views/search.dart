import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _currentPage = 0; // Mevcut sayfa numarası
  final int _itemsPerPage = 3; // Her sayfada gösterilecek öğe sayısı

  final List<Map<String, dynamic>> _earthquakeInfo = [
    {
      'title': 'Deprem Öncesi Hazırlık',
      'details': [
        'Acil durum çantası hazırlayın.',
        'Güvenli alanları belirleyin.',
        'Aile ile iletişim planı yapın.'
      ]
    },
    {
      'title': 'Deprem Anında',
      'details': [
        'Sakin olun ve güvenli bir yere geçin.',
        'Cam ve pencerelerden uzak durun.',
        'Merdivenleri kullanmayın.'
      ]
    },
    {
      'title': 'Deprem Sonrası',
      'details': [
        'Acil durum çantanızı kullanın.',
        'Artçı sarsıntılara karşı dikkatli olun.',
        'Yaralılara yardım edin, ancak eğitiminiz yoksa profesyonel yardımı bekleyin.'
      ]
    },
    {
      'title': 'Acil Durum İletişim',
      'details': [
        '112 Acil Servis\'i arayın.',
        'Güvenli bir yerde olduğunuzdan emin olun.',
        'Durumunuzu sosyal medyada paylaşarak yakınlarınızı bilgilendirin.'
      ]
    },
  ];

  void _nextPage() {
    setState(() {
      if ((_currentPage + 1) * _itemsPerPage < _earthquakeInfo.length) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (_currentPage + 1) * _itemsPerPage > _earthquakeInfo.length
        ? _earthquakeInfo.length
        : (_currentPage + 1) * _itemsPerPage;
    final currentItems = _earthquakeInfo.sublist(startIndex, endIndex);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Depremle İlgili Bilgiler:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: currentItems.length,
                itemBuilder: (context, index) {
                  final item = currentItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...List<Widget>.from(
                            (item['details'] as List<String>).map(
                              (detail) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  detail,
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
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _previousPage,
                  child: const Text('Önceki Sayfa'),
                ),
                Text(
                  'Sayfa ${_currentPage + 1} / ${(_earthquakeInfo.length / _itemsPerPage).ceil()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _nextPage,
                  child: const Text('Sonraki Sayfa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
