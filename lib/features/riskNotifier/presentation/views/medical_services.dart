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
  String? _selectedRiskStatus = 'Yüksek'; // Varsayılan risk durumu
  String? _selectedDiseaseId; // Seçilen hastalık ID'si
  final List<Map<String, dynamic>> _diseases =
      []; // Eklenen hastalıkların listesi
  final List<Map<String, String>> _addedMedicines = [];
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
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

            for (var guest in data) {
              if (guest['health'] != null) {
                for (var health in guest['health']) {
                  _diseases.add(health);
                }
              }
            }
          });
        }
      } else {
        _showErrorSnackBar('Veriler yüklenirken bir hata oluştu.');
      }
    } catch (e) {
      _showErrorSnackBar('Bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  Future<void> _addOrUpdateDisease() async {
    final token = await _storage.read(key: 'auth_token');
    final diseaseName = _diseaseController.text;

    if (diseaseName.isEmpty) return;

    try {
      final client = await _getHttpClient();
      final Uri url = Uri.parse(_selectedDiseaseId == null
          ? 'https://risknotifier.com/api/mobil/health'
          : 'https://risknotifier.com/api/mobil/health/$_selectedDiseaseId');

      var request = http.MultipartRequest(
        _selectedDiseaseId == null ? 'POST' : 'PUT',
        url,
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['risk_status'] = _selectedRiskStatus!;
      request.fields['name'] = diseaseName;

      final response = await client.send(request);

      response.stream.transform(utf8.decoder).listen((value) {
        final jsonResponse = jsonDecode(value);
        setState(() {
          if (_selectedDiseaseId != null) {
            final index =
                _diseases.indexWhere((d) => d['id'] == _selectedDiseaseId);
            if (index != -1) {
              _diseases[index]['name'] = diseaseName;
              _diseases[index]['risk_status'] = _selectedRiskStatus;
            }
          } else {
            _selectedDiseaseId = jsonResponse['id'].toString();
            _diseases.add({
              'id': _selectedDiseaseId,
              'name': diseaseName,
              'risk_status': _selectedRiskStatus,
            });
          }
          _clearForm();
        });
      });

      if (response.statusCode == 200) {
        _showSuccessSnackBar(_selectedDiseaseId == null
            ? 'Hastalık başarıyla eklendi!'
            : 'Hastalık başarıyla güncellendi!');
      } else {
        _showErrorSnackBar('Hastalık kaydedilirken bir hata oluştu.');
      }
    } catch (e) {
      _showErrorSnackBar('Bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  Future<void> _addMedicine() async {
    final token = await _storage.read(key: 'auth_token');
    final String medicineName = _medicineNameController.text;

    if (medicineName.isEmpty || _selectedDiseaseId == null) return;

    try {
      final client = await _getHttpClient();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://risknotifier.com/api/mobil/medical'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['health_info_id'] = _selectedDiseaseId!;
      request.fields['name'] = medicineName;

      final response = await client.send(request);

      response.stream.transform(utf8.decoder).listen((value) {
        // Response işlemleri
      });

      if (response.statusCode == 200) {
        setState(() {
          _addedMedicines.add({'name': medicineName});
          _medicineNameController.clear();
        });
        _showSuccessSnackBar('İlaç başarıyla eklendi!');
      } else {
        _showErrorSnackBar('İlaç eklenirken bir hata oluştu.');
      }
    } catch (e) {
      _showErrorSnackBar('Bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  Future<void> _deleteDisease(String diseaseId) async {
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
        });
        _showSuccessSnackBar('Hastalık başarıyla silindi!');
      } else {
        _showErrorSnackBar('Hastalık silinirken bir hata oluştu.');
      }
    } catch (e) {
      _showErrorSnackBar('Bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  void _editDisease(Map<String, dynamic> disease) {
    setState(() {
      _selectedDiseaseId = disease['id'].toString();
      _diseaseController.text = disease['name'];
      _selectedRiskStatus = disease['risk_status'];
    });
  }

  void _clearForm() {
    _diseaseController.clear();
    _selectedDiseaseId = null;
    _selectedRiskStatus = 'Yüksek';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
              decoration: const InputDecoration(
                labelText: 'Hastalık Adı',
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
              onPressed: _addOrUpdateDisease,
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
              child: Text(_selectedDiseaseId == null
                  ? 'Hastalık Ekle'
                  : 'Hastalık Güncelle'),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedDiseaseId,
              decoration: const InputDecoration(
                labelText: 'Hastalık Seçin',
                border: OutlineInputBorder(),
              ),
              items: _diseases.map((disease) {
                return DropdownMenuItem<String>(
                  value: disease['id'].toString(),
                  child: Text(disease['name']),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDiseaseId = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
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
            ElevatedButton(
              onPressed: _selectedDiseaseId != null ? _addMedicine : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedDiseaseId != null
                    ? const Color.fromARGB(255, 28, 51, 69)
                    : const Color.fromRGBO(221, 57, 13, 0.5),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                disabledBackgroundColor: const Color.fromRGBO(221, 57, 13, 0.5),
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
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      child: ListTile(
                        title: Text('İlaç: ${medicine['name']}'),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Tüm Hastalıklar:',
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
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    child: ListTile(
                      title: Text('Hastalık: ${disease['name']}'),
                      subtitle: Text('Risk Durumu: ${disease['risk_status']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteDisease(disease['id'].toString()),
                      ),
                      onTap: () => _editDisease(disease),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
