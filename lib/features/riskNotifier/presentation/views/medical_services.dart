import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class MedicalServices extends StatefulWidget {
  const MedicalServices({super.key});

  @override
  _MedicalServicesState createState() => _MedicalServicesState();
}

class _MedicalServicesState extends State<MedicalServices> {
  final _diseaseController = TextEditingController();
  final _medicineNameController = TextEditingController();
  String? _selectedMealTime;
  String? _selectedFrequency;
  String? _selectedRiskStatus = 'Yüksek'; // Varsayılan risk durumu
  bool _isDiseaseNameEmpty = true;
  String? _addedDisease;
  int? _selectedDiseaseId; // Seçilen hastalık ID'si
  final List<Map<String, String>> _addedMedicines = [];
  final List<Map<String, dynamic>> _diseases =
      []; // Eklenen hastalıkların listesi
  final List<Map<String, dynamic>> _medicines = []; // Eklenen ilaçların listesi
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _diseaseController.addListener(() {
      setState(() {
        _isDiseaseNameEmpty = _diseaseController.text.isEmpty;
      });
    });

    // Hastalıkları ve ilaçları yükle
    _fetchHealthAndMedicData();
  }

  Future<http.Client> _getHttpClient() async {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  Future<void> _fetchHealthAndMedicData() async {
    final token = await _storage.read(key: 'auth_token');

    try {
      final client = await _getHttpClient();
      final response = await client.get(
        Uri.parse('https://risknotifier.com/api/mobil'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        if (data != null && data.isNotEmpty) {
          setState(() {
            _diseases.clear();
            _medicines.clear();

            for (var guest in data) {
              // Health verilerini al
              if (guest['health'] != null) {
                for (var health in guest['health']) {
                  _diseases.add(health);
                }
              }

              // Medic verilerini al
              if (guest['medic'] != null) {
                for (var medic in guest['medic']) {
                  _medicines.add(medic);
                }
              }
            }
          });
        }
      } else {
        print('Hata: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veriler yüklenirken bir hata oluştu.')),
        );
      }
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bir hata oluştu. Lütfen tekrar deneyin.')),
      );
    }
  }

  Future<void> _addDisease() async {
    final token = await _storage.read(key: 'auth_token');
    final diseaseName = _diseaseController.text;

    try {
      final client = await _getHttpClient();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://risknotifier.com/api/mobil/health'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['risk_status'] = _selectedRiskStatus!;
      request.fields['name'] = diseaseName;

      final response = await client.send(request);

      response.stream.transform(utf8.decoder).listen((value) {
        print('Response body: $value');
        final jsonResponse = jsonDecode(value);
        setState(() {
          _selectedDiseaseId = jsonResponse['id'];
          _addedDisease = diseaseName;
          _diseases.add({
            'id': _selectedDiseaseId,
            'name': _addedDisease,
            'risk_status': _selectedRiskStatus,
          });
        });
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hastalık başarıyla eklendi!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hastalık eklenirken bir hata oluştu.')),
        );
      }
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bir hata oluştu. Lütfen tekrar deneyin.')),
      );
    }
  }

  Future<void> _addMedicine() async {
    final token = await _storage.read(key: 'auth_token');
    final String medicineName = _medicineNameController.text;

    if (medicineName.isNotEmpty &&
        _selectedMealTime != null &&
        _selectedFrequency != null &&
        _selectedDiseaseId != null) {
      try {
        final client = await _getHttpClient();

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://risknotifier.com/api/mobil/medical'),
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Content-Type'] = 'multipart/form-data';

        request.fields['health_info_id'] = _selectedDiseaseId.toString();
        request.fields['name'] = medicineName;

        final response = await client.send(request);

        response.stream.transform(utf8.decoder).listen((value) {
          print('Response body: $value');
        });

        if (response.statusCode == 200) {
          setState(() {
            _addedMedicines.add({
              'name': medicineName,
              'mealTime': _selectedMealTime!,
              'frequency': _selectedFrequency!,
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('İlaç başarıyla eklendi!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('İlaç eklenirken bir hata oluştu.')),
          );
        }
      } catch (e) {
        print('Hata: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Bir hata oluştu. Lütfen tekrar deneyin.')),
        );
      }
    }
  }

  Future<void> _updateDisease(int diseaseId) async {
    final token = await _storage.read(key: 'auth_token');
    final diseaseName = _diseaseController.text;

    try {
      final client = await _getHttpClient();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://risknotifier.com/api/mobil/health/$diseaseId'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['risk_status'] = _selectedRiskStatus!;
      request.fields['name'] = diseaseName;

      final response = await client.send(request);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hastalık başarıyla güncellendi!')),
        );
        _fetchHealthAndMedicData(); // Güncellemeden sonra verileri yenile
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Hastalık güncellenirken bir hata oluştu.')),
        );
      }
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bir hata oluştu. Lütfen tekrar deneyin.')),
      );
    }
  }

  Future<void> _deleteDisease(int diseaseId) async {
    final token = await _storage.read(key: 'auth_token');

    try {
      final client = await _getHttpClient();

      final response = await client.delete(
        Uri.parse('https://risknotifier.com/api/mobil/health/$diseaseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _diseases.removeWhere((disease) => disease['id'] == diseaseId);
          _selectedDiseaseId = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hastalık başarıyla silindi!')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hastalık silinirken bir hata oluştu.')),
        );
      }
    } catch (e) {
      print('Hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bir hata oluştu. Lütfen tekrar deneyin.')),
      );
    }
  }

  void _editDisease(Map<String, dynamic> disease) {
    setState(() {
      _selectedDiseaseId = disease['id'];
      _diseaseController.text = disease['name'];
      _selectedRiskStatus = disease['risk_status'];
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hastalık Güncelle veya Sil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _diseaseController,
                decoration: InputDecoration(
                  labelText: 'Hastalık Adı',
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRiskStatus,
                decoration: const InputDecoration(
                  labelText: 'Risk Durumu',
                  border: OutlineInputBorder(),
                ),
                items: ['Yüksek', 'Orta', 'Düşük'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRiskStatus = newValue;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateDisease(_selectedDiseaseId!);
              },
              child: const Text('Güncelle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteDisease(_selectedDiseaseId!);
              },
              child: const Text('Sil'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _diseaseController.dispose();
    _medicineNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _diseaseController,
              decoration: InputDecoration(
                labelText: 'Hastalık Adı',
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
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRiskStatus,
              decoration: const InputDecoration(
                labelText: 'Risk Durumu',
                border: OutlineInputBorder(),
              ),
              items: ['Yüksek', 'Orta', 'Düşük'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRiskStatus = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isDiseaseNameEmpty ? null : _addDisease,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 28, 51, 69),
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                side: const BorderSide(
                  color: Color.fromARGB(255, 28, 51, 69),
                ),
              ),
              child: const Text('Hastalık Ekle'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Eklenen Hastalıklar:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _diseases.length,
                itemBuilder: (context, index) {
                  final disease = _diseases[index];
                  return GestureDetector(
                    onTap: () => _editDisease(disease),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      child: ListTile(
                        title: Text('Hastalık: ${disease['name']}'),
                        subtitle:
                            Text('Risk Durumu: ${disease['risk_status']}'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedDiseaseId != null) ...[
              TextField(
                controller: _medicineNameController,
                decoration: const InputDecoration(
                  labelText: 'İlaç Adı',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 28, 51, 69),
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(221, 57, 13, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(221, 57, 13, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Aç mı Tok mu?',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 28, 51, 69),
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(221, 57, 13, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(221, 57, 13, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                value: _selectedMealTime,
                items: ['Aç', 'Tok'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMealTime = newValue;
                    _selectedFrequency = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_selectedMealTime != null) ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Günde Kaç Kere?',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 28, 51, 69),
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(221, 57, 13, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(221, 57, 13, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  value: _selectedFrequency,
                  items: ['1', '2', '3', '4'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedFrequency = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed:
                    _selectedMealTime != null && _selectedFrequency != null
                        ? _addMedicine
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedMealTime != null && _selectedFrequency != null
                          ? const Color.fromARGB(255, 28, 51, 69)
                          : const Color.fromRGBO(221, 57, 13, 0.5),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  disabledBackgroundColor:
                      const Color.fromRGBO(221, 57, 13, 0.5),
                  disabledForegroundColor: Colors.white70,
                ),
                child: const Text('İlaç Ekle'),
              ),
              const SizedBox(height: 24),
              if (_addedMedicines.isNotEmpty) ...[
                const Text(
                  'Eklenen İlaçlar:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _addedMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = _addedMedicines[index];
                      return GestureDetector(
                        onTap: () => _updateDisease(index),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ListTile(
                            title: Text('İlaç: ${medicine['name']}'),
                            subtitle: Text(
                                'Zamanı: ${medicine['mealTime']} - Günde ${medicine['frequency']} kere'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
