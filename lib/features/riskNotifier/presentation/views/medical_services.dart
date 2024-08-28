import 'package:flutter/material.dart';

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
  bool _isDiseaseAdded = false;
  bool _isDiseaseNameEmpty = true;
  String? _addedDisease;
  final List<Map<String, String>> _addedMedicines = [];

  @override
  void initState() {
    super.initState();

    _diseaseController.addListener(() {
      setState(() {
        _isDiseaseNameEmpty = _diseaseController.text.isEmpty;
      });
    });
  }

  void _addDisease() {
    setState(() {
      _addedDisease = _diseaseController.text;
      _isDiseaseAdded = true;
    });
  }

  void _addMedicine() {
    final String medicineName = _medicineNameController.text;

    if (medicineName.isNotEmpty &&
        _selectedMealTime != null &&
        _selectedFrequency != null) {
      setState(() {
        _addedMedicines.add({
          'name': medicineName,
          'mealTime': _selectedMealTime!,
          'frequency': _selectedFrequency!,
        });
      });

      _medicineNameController.clear();
      _selectedMealTime = null;
      _selectedFrequency = null;
    }
  }

  void _updateMedicine(int index) {
    final medicine = _addedMedicines[index];
    _medicineNameController.text = medicine['name']!;
    _selectedMealTime = medicine['mealTime'];
    _selectedFrequency = medicine['frequency'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('İlacı Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _medicineNameController,
                decoration: InputDecoration(
                  labelText: 'İlaç Adı',
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
                decoration: InputDecoration(
                  labelText: 'Aç mı Tok mu?',
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
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Günde Kaç Kere?',
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
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _addedMedicines[index] = {
                    'name': _medicineNameController.text,
                    'mealTime': _selectedMealTime!,
                    'frequency': _selectedFrequency!,
                  };
                });
                _medicineNameController.clear();
                _selectedMealTime = null;
                _selectedFrequency = null;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('İlaç başarıyla güncellendi!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 28, 51, 69), // Arka plan rengi
                foregroundColor: Colors.white, // Metin rengi
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Buton kenarlarının yuvarlaklığı
                ),
              ),
              child: const Text('Güncelle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color.fromARGB(255, 221, 57, 13), // Metin rengi
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            if (!_isDiseaseAdded) ...[
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
            ] else ...[
              Text(
                'Eklenen Hastalık: $_addedDisease',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
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
                    _selectedFrequency =
                        null; // Yeni seçim yapılırsa, ikinci dropdown'u sıfırla
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
                        : null, // Buton seçimsizken devre dışı
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedMealTime != null && _selectedFrequency != null
                          ? const Color.fromARGB(255, 28, 51, 69)
                          : const Color.fromRGBO(
                              221, 57, 13, 0.5), // Devre dışı iken farklı renk
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  disabledBackgroundColor: const Color.fromRGBO(
                      221, 57, 13, 0.5), // Devre dışı arka plan rengi
                  disabledForegroundColor:
                      Colors.white70, // Devre dışı yazı rengi
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
                        onTap: () => _updateMedicine(index),
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
