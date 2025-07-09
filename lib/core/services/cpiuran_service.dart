import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartofficial/config/env.dart';
import 'package:smartofficial/core/models/cpiuran_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CpiuranService {
  static Future<List<CpiuranModel>> fetchCpiuranList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Env.baseUrl}/cpiuran'), // endpoint baru
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<CpiuranModel>.from(data.map((e) => CpiuranModel.fromJson(e)));
    } else {
      throw Exception('Gagal mengambil data iuran');
    }
  }
}
