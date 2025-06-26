import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/core/models/tahlil_model.dart';
import 'package:concept/config/env.dart';

class TahlilService {
  static Future<List<Tahlil>> fetchTahlil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak tersedia. Harap login terlebih dahulu.');
    }

    final response = await http.get(
      Uri.parse('${Env.baseUrl}/tahlil'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List list = jsonData['data'];
      return list.map((json) => Tahlil.fromJson(json)).toList();
    } else {
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      throw Exception('Gagal mengambil data Kerja Bakti');
    }
  }
}
