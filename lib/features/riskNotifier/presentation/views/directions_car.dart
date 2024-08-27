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

  void _addVehicle() {
    final String plateNumber = _plateNumberController.text;

    if (plateNumber.isNotEmpty && _selectedType != null) {
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
      appBar: AppBar(
        title: const Text('Araç Ekle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _plateNumberController,
              decoration: const InputDecoration(
                labelText: 'Plaka',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Türü',
                border: OutlineInputBorder(),
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
                child: const Text('Araç Ekle'),
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
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ListTile(
                            title: Text('Plaka: ${vehicle['plate']}'),
                            subtitle: Text('Türü: ${vehicle['type']}'),
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
