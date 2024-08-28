import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _EarthquakeScreenState createState() => _EarthquakeScreenState();
}

class _EarthquakeScreenState extends State<SearchScreen> {
  List<dynamic> earthquakes = [];

  @override
  void initState() {
    super.initState();
    fetchEarthquakes();
  }

  Future<void> fetchEarthquakes() async {
    final response = await http.get(
        Uri.parse('https://api.orhanaydogdu.com.tr/deprem/live.php?limit=100'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        earthquakes = data['result'];
      });
    } else {
      if (kDebugMode) {
        print('Failed to load earthquake data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: earthquakes.isEmpty
          ? const Center(child: Text('Son depremler bulunamadı'))
          : ListView.builder(
              itemCount: earthquakes.length,
              itemBuilder: (context, index) {
                var quake = earthquakes[index];
                return ListTile(
                  title: Text(quake['lokasyon']),
                  subtitle: Text(
                      'Büyüklük: ${quake['mag']} - Tarih: ${quake['date']}'),
                );
              },
            ),
    );
  }
}

void main() => runApp(const MaterialApp(home: SearchScreen()));
