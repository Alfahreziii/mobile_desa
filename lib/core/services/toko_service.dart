// lib/core/services/toko_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:concept/core/models/toko_model.dart';
import 'package:concept/config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokoService {
  static Future<List<Toko>> fetchTokoList() async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/toko'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Toko>.from(data.map((e) => Toko.fromJson(e)));
    } else {
      throw Exception('Gagal mengambil data toko');
    }
  }

  static Future<Toko> getTokoById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    final response = await http.get(
      Uri.parse('${Env.baseUrl}/toko'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final tokoList = List<Toko>.from(data.map((e) => Toko.fromJson(e)));
      return tokoList.firstWhere(
        (toko) => toko.id == id,
        orElse: () => throw Exception('Toko tidak ditemukan'),
      );
    } else {
      throw Exception('Gagal mengambil data toko');
    }
  }
}
