import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart'; // Bu satırı ekleyin
import 'dart:convert';

class Vehicle extends StatefulWidget {
  const Vehicle({super.key});

  @override
  _VehicleState createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
  final _plateNumberController = TextEditingController();
  String? _selectedType;
  final List<String> _vehicleTypes = [
    'Otomobil',
    'Motosiklet',
    'Kamyon',
    'Otobüs'
  ];
  final _storage = FlutterSecureStorage();

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  String _formatPlateNumber(String plateNumber) {
    final plateRegex = RegExp(r'^(\d{2})([A-Z]+)(\d+)$');
    final match = plateRegex.firstMatch(plateNumber.replaceAll(' ', ''));
    if (match != null) {
      return '${match.group(1)} ${match.group(2)} ${match.group(3)}';
    }
    return plateNumber;
  }

  Future<void> _addVehicle() async {
    String plateNumber = _plateNumberController.text;
    plateNumber = _formatPlateNumber(plateNumber);

    if (plateNumber.isNotEmpty && _selectedType != null) {
      try {
        String? authToken = await _storage.read(key: 'auth_token');

        HttpClient client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

        IOClient ioClient = IOClient(client);

        final response = await ioClient.post(
          Uri.parse('https://risknotifier.com/api/mobil/vehicle'),
          headers: {
            'Authorization': 'Bearer $authToken',
          },
          body: {
            'plate': plateNumber,
            'type': _selectedType!,
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Araç başarıyla eklendi!')),
          );
          setState(() {}); // Listi güncelle
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Araç eklenemedi: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }

      _plateNumberController.clear();
      setState(() {
        _selectedType = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
    }
  }

  Future<void> _updateVehicle(int id) async {
    String plateNumber = _plateNumberController.text;
    plateNumber = _formatPlateNumber(plateNumber);

    if (plateNumber.isNotEmpty && _selectedType != null) {
      try {
        String? authToken = await _storage.read(key: 'auth_token');

        HttpClient client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

        IOClient ioClient = IOClient(client);

        final response = await ioClient.post(
          Uri.parse('https://risknotifier.com/api/mobil/vehicle/$id'),
          headers: {
            'Authorization': 'Bearer $authToken',
          },
          body: {
            'plate': plateNumber,
            'type': _selectedType!,
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Araç başarıyla güncellendi!')),
          );
          setState(() {}); // Listi güncelle
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Araç güncellenemedi: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
    }
  }

  Future<void> _deleteVehicle(int id) async {
    try {
      String? authToken = await _storage.read(key: 'auth_token');

      HttpClient client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      IOClient ioClient = IOClient(client);

      final response = await ioClient.delete(
        Uri.parse('https://risknotifier.com/api/mobil/vehicle/$id'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Araç başarıyla silindi!')),
        );
        setState(() {}); // Listi güncelle
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Araç silinemedi: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _fetchVehicles() async {
    try {
      String? authToken = await _storage.read(key: 'auth_token');

      HttpClient client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      IOClient ioClient = IOClient(client);

      final response = await ioClient.get(
        Uri.parse('https://risknotifier.com/api/mobil'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final vehicles = data['data'][0]['vehicle'] as List<dynamic>;
        return vehicles.map((vehicle) {
          return {
            'id': vehicle['id'] as int,
            'plate': vehicle['plate'] as String,
            'type': vehicle['type'] as String,
          };
        }).toList();
      } else {
        throw Exception('Araçlar getirilemedi: ${response.body}');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }

  void _showUpdateDialog(Map<String, dynamic> vehicle) {
    _plateNumberController.text = vehicle['plate'];
    _selectedType = vehicle['type'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aracı Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _plateNumberController,
                decoration: const InputDecoration(
                  labelText: 'Plaka',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Türü',
                ),
                value: _selectedType,
                items: _vehicleTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateVehicle(vehicle['id']);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromRGBO(221, 57, 13, 1),
              ),
              child: const Text('Güncelle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 28, 51, 69),
              ),
              child: const Text('İptal'),
            ),
          ],
        );
      },
    );
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
              controller: _plateNumberController,
              cursorColor: const Color.fromARGB(255, 28, 51, 69),
              decoration: InputDecoration(
                labelText: 'Plaka',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 28, 51, 69),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color.fromRGBO(221, 57, 13, 1),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Color.fromRGBO(221, 57, 13, 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Türü',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 28, 51, 69),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(221, 57, 13, 1),
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(221, 57, 13, 1),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(221, 57, 13, 1),
                    width: 1.0,
                  ),
                ),
              ),
              value: _selectedType,
              items: _vehicleTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _addVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 28, 51, 69),
                  foregroundColor: const Color.fromARGB(253, 245, 240, 240),
                  minimumSize: const Size(double.infinity, 40),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Araç Ekle',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchVehicles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Hata: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final vehicles = snapshot.data!;
                    return ListView.builder(
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ListTile(
                            title: Text('Plaka: ${vehicle['plate']}'),
                            subtitle: Text('Türü: ${vehicle['type']}'),
                            onTap: () => _showUpdateDialog(vehicle),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteVehicle(vehicle['id']),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Henüz araç eklenmemiş.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
