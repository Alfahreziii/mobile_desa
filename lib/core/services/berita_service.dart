import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartofficial/core/models/berita_model.dart';
import 'package:smartofficial/config/env.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class BeritaService {
  static Future<List<Berita>> fetchBerita() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak tersedia. Harap login terlebih dahulu.');
    }

    final response = await http.get(
      Uri.parse('${Env.baseUrl}/berita'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List list = jsonData['data'];
      return list.map((json) => Berita.fromJson(json)).toList();
    } else {
      logger.d('Status: ${response.statusCode}');
      logger.d('Response: ${response.body}');
      throw Exception('Gagal mengambil data berita');
    }
  }
}
