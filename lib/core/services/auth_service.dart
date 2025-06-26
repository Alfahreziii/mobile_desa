import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/config/env.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['data']?['token'];

      if (token != null) {
        // Ambil profil user
        final profileResponse = await http.get(
          Uri.parse('${Env.baseUrl}/users/profile'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (profileResponse.statusCode == 200) {
          final profileData = json.decode(profileResponse.body);
          final user = profileData['data'];

          // Simpan ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('token', token);
          await prefs.setString('userName', user['name']);
          await prefs.setString('userEmail', user['email']);

          return {
            'success': true,
            'message': data['message'] ?? 'Login berhasil',
          };
        } else {
          return {
            'success': false,
            'message': 'Login berhasil, tapi gagal ambil data user',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Token tidak ditemukan di respons.',
        };
      }
    } else {
      final error = json.decode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Login gagal.',
      };
    }
  }
}
