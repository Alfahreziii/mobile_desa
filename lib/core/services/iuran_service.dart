import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:concept/config/env.dart';
import 'package:concept/core/models/iuran_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IuranService {
  static Future<List<IuranModel>> fetchIuranList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Env.baseUrl}/iuran/status'), // endpoint baru
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<IuranModel>.from(data.map((e) => IuranModel.fromJson(e)));
    } else {
      throw Exception('Gagal mengambil data iuran');
    }
  }
}
