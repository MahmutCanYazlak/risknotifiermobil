import 'package:flutter/material.dart';

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
  final List<Map<String, String>> _addedVehicles = [];
  int _currentPage = 0;
  final int _vehiclesPerPage = 4;

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  bool _isPlateNumberValid(String plateNumber) {
    // Türkiye plakaları için basit bir doğrulama (örneğin "34 ABC 123" formatı)
    final plateRegex = RegExp(r'^\d{2} [A-Z]{1,3} \d{1,4}$');
    return plateRegex.hasMatch(plateNumber);
  }

  void _addVehicle() {
    final String plateNumber = _plateNumberController.text;

    if (plateNumber.isNotEmpty && _selectedType != null) {
      if (!_isPlateNumberValid(plateNumber)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Geçersiz plaka formatı!')),
        );
        return;
      }

      setState(() {
        _addedVehicles.add({
          'plate': plateNumber,
          'type': _selectedType!,
        });
      });

      // Formu sıfırlama
      _plateNumberController.clear();
      setState(() {
        _selectedType = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Araç başarıyla eklendi!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
    }
  }

  void _updateVehicle(int index) {
    final vehicle = _addedVehicles[index];
    _plateNumberController.text = vehicle['plate']!;
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
                setState(() {
                  _addedVehicles[index] = {
                    'plate': _plateNumberController.text,
                    'type': _selectedType!,
                  };
                });
                _plateNumberController.clear();
                _selectedType = null;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Araç başarıyla güncellendi!')),
                );
              },
              child: const Text('Güncelle'),
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

  List<Map<String, String>> _getCurrentPageVehicles() {
    final start = _currentPage * _vehiclesPerPage;
    final end = start + _vehiclesPerPage;
    return _addedVehicles.sublist(
      start,
      end > _addedVehicles.length ? _addedVehicles.length : end,
    );
  }

  void _nextPage() {
    if ((_currentPage + 1) * _vehiclesPerPage < _addedVehicles.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
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
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getCurrentPageVehicles().length,
                      itemBuilder: (context, index) {
                        final vehicle = _getCurrentPageVehicles()[index];
                        return GestureDetector(
                          onTap: () => _updateVehicle(index),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 3,
                            child: ListTile(
                              title: Text('Plaka: ${vehicle['plate']}'),
                              subtitle: Text('Türü: ${vehicle['type']}'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_addedVehicles.length > 4)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _previousPage,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Önceki'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Sayfa ${_currentPage + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _nextPage,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Sonraki'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
