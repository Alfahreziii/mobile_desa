import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:concept/config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuratService {
  static Future<void> createSurat({
    required String atasNama,
    required int idJenisSurat,
    required String ditunjukan,
    required String keterangan,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Env.baseUrl}/surat'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'atas_nama': atasNama,
        'id_jenissurat': idJenisSurat,
        'ditunjukan': ditunjukan,
        'keterangan': keterangan,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Error: ${response.statusCode}");
      throw Exception("Gagal membuat surat");
    }
  }
}
