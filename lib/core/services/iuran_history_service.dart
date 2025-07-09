import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartofficial/core/models/iuran_history_model.dart';
import 'package:smartofficial/config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IuranHistoryService {
  static Future<List<IuranHistoryModel>> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Env.baseUrl}/pembayaran/me'), // endpoint baru
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<IuranHistoryModel>.from(
          data.map((e) => IuranHistoryModel.fromJson(e)));
    } else {
      throw Exception('Gagal mengambil data iuran');
    }
  }
}
