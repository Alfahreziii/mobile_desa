import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:concept/core/models/jenissurat_model.dart';
import 'package:concept/config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JenisSuratService {
  static Future<List<JenisSurat>> fetchJenisSurat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Env.baseUrl}/jenissurat'), // sesuaikan dengan endpoint kamu
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((item) => JenisSurat.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat jenis surat');
    }
  }
}
