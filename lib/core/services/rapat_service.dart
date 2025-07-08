import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/core/models/rapat_model.dart';
import 'package:concept/config/env.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class RapatService {
  static Future<List<Rapat>> fetchRapat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak tersedia. Harap login terlebih dahulu.');
    }

    final response = await http.get(
      Uri.parse('${Env.baseUrl}/rapat'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List list = jsonData['data'];
      return list.map((json) => Rapat.fromJson(json)).toList();
    } else {
      logger.d('Status: ${response.statusCode}');
      logger.d('Response: ${response.body}');
      throw Exception('Gagal mengambil data Rapat');
    }
  }
}
