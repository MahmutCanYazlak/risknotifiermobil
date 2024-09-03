import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class FamilyScreen extends StatefulWidget {
  final int initialIndex;
  const FamilyScreen({super.key, this.initialIndex = 0});

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _degreeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<Map<String, dynamic>> _relatives = [];
  String? _editingRelativeId; // To store the ID of the relative being edited

  @override
  void initState() {
    super.initState();
    _fetchRelatives(); // Initialize the relatives list when the screen loads
  }

  @override
  void dispose() {
    _nameController.dispose();
    _degreeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Bu metodu sınıfınıza ekleyin
  HttpClient _createHttpClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }

  // createIOClient metodu
  IOClient createIOClient() {
    var httpClient = _createHttpClient();
    return IOClient(httpClient);
  }

  String safeValue(String? value) => value?.isNotEmpty == true ? value! : '';
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? token = await _storage.read(key: 'auth_token');
      if (token == null) {
        if (mounted) {
          _showSnackBar('Token bulunamadı');
        }
        return;
      }

      try {
        var client = createIOClient();
        http.MultipartRequest request;

        // Güncelleme işlemi mi, yeni kayıt ekleme mi kontrol ediliyor
        if (_editingRelativeId != null) {
          // Güncelleme işlemi için URL'yi ID ile birlikte oluşturuyoruz
          var url = Uri.parse(
              'https://risknotifier.com/api/mobil/relative/$_editingRelativeId');
          request = http.MultipartRequest('POST', url);
        } else {
          // Yeni kayıt ekleme işlemi
          var url = Uri.parse('https://risknotifier.com/api/mobil/relative');
          request = http.MultipartRequest('POST', url);
        }

        request.headers['Authorization'] = 'Bearer $token';

        // Form alanları dolduruluyor
        request.fields['name'] = _nameController.text;
        request.fields['degree'] = _degreeController.text;
        request.fields['phone'] = _phoneController.text;
        request.fields['email'] = _emailController.text;

        var response = await client.send(request);
        var responseBody = await http.Response.fromStream(response);

        if (response.statusCode == 200) {
          _showSnackBar(_editingRelativeId == null
              ? 'Aile üyesi başarıyla eklendi!'
              : 'Aile üyesi başarıyla güncellendi!');
          _clearFormFields();
          _fetchRelatives();
          _editingRelativeId = null;
        } else {
          _showSnackBar(
              'İşlem başarısız: ${response.statusCode} - ${responseBody.body}');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Bir hata oluştu: $e');
        }
      }
    }
  }

  Future<void> _fetchRelatives() async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) {
      if (mounted) {
        _showSnackBar('Token bulunamadı');
      }
      return;
    }

    try {
      final client = HttpClientAdapter(_createHttpClient());

      final response = await client.get(
        Uri.parse('https://risknotifier.com/api/mobil'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _relatives = List<Map<String, dynamic>>.from(
              data['data'][0]['relative'] as List<dynamic>);
        });
      } else {
        _showSnackBar('Akrabalar getirilemedi: ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Bir hata oluştu: $e');
      }
    }
  }

  Future<void> _deleteRelative(String guestRelativeId) async {
    String? token = await _storage.read(key: 'auth_token');
    if (token == null) {
      if (mounted) {
        _showSnackBar('Token bulunamadı');
      }
      return;
    }

    try {
      final client = HttpClientAdapter(_createHttpClient());

      final response = await client.delete(
        Uri.parse(
            'https://risknotifier.com/api/mobil/relative/$guestRelativeId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar('Aile üyesi başarıyla silindi!');
        _fetchRelatives(); // Refresh the relatives list after deletion
      } else {
        _showSnackBar('Silme işlemi başarısız: ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Bir hata oluştu: $e');
      }
    }
  }

  void _clearFormFields() {
    _nameController.clear();
    _degreeController.clear();
    _phoneController.clear();
    _emailController.clear();
    _editingRelativeId = null; // Reset editing state
  }

  void _showSnackBar(String message) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      cursorColor: const Color.fromARGB(255, 28, 51, 69),
                      decoration: InputDecoration(
                        labelText: 'İsim',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen isim giriniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _degreeController,
                      cursorColor: const Color.fromARGB(255, 28, 51, 69),
                      decoration: InputDecoration(
                        labelText: 'Derece',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen derece giriniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      cursorColor: const Color.fromARGB(255, 28, 51, 69),
                      decoration: InputDecoration(
                        labelText: 'Telefon',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen telefon numarası giriniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: const Color.fromARGB(255, 28, 51, 69),
                      decoration: InputDecoration(
                        labelText: 'Email',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen email adresi giriniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await _submitForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 28, 51, 69),
                          foregroundColor:
                              const Color.fromARGB(253, 245, 240, 240),
                          minimumSize: const Size(double.infinity, 40),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _editingRelativeId == null
                              ? 'Aile Üyesi Ekle'
                              : 'Güncelle', // Change button text based on state
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _relatives.length,
                  itemBuilder: (context, index) {
                    final relative = _relatives[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      child: ListTile(
                        title:
                            Text('İsim: ${relative['name'] ?? 'Bilinmiyor'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Derece: ${relative['degree'] ?? 'Bilinmiyor'}'),
                            Text(
                                'Telefon: ${relative['phone'] ?? 'Bilinmiyor'}'),
                            Text('Email: ${relative['email'] ?? 'Bilinmiyor'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Formu seçili kaydın bilgileriyle doldurun
                                _nameController.text = relative['name'] ?? '';
                                _degreeController.text =
                                    relative['degree'] ?? '';
                                _phoneController.text = relative['phone'] ?? '';
                                _emailController.text = relative['email'] ?? '';

                                // Düzenleme durumunu ayarlayın
                                setState(() {
                                  _editingRelativeId =
                                      relative['id'].toString();
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (relative['id'] != null) {
                                  _deleteRelative(relative['id'].toString());
                                } else {
                                  _showSnackBar(
                                      'ID bulunamadı, silme işlemi yapılamaz.');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HttpClientAdapter extends http.BaseClient {
  final HttpClient _httpClient;

  HttpClientAdapter(this._httpClient);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final ioRequest = await _httpClient.openUrl(
      request.method,
      request.url,
    );

    request.headers.forEach((key, value) {
      ioRequest.headers.set(key, value);
    });

    final response = await ioRequest.close();

    final headers = <String, String>{};
    response.headers.forEach((key, values) {
      headers[key] = values.join(',');
    });

    final contentLength =
        response.contentLength == -1 ? null : response.contentLength;

    return http.StreamedResponse(
      response,
      response.statusCode,
      contentLength: contentLength,
      request: request,
      headers: headers,
      isRedirect: response.isRedirect,
      reasonPhrase: response.reasonPhrase,
    );
  }
}
