import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/config/env.dart';
import 'package:concept/core/models/user_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> register(UserModel user) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    final responseData = jsonDecode(response.body);

    return {
      'success': response.statusCode == 201,
      'message': responseData['message'] ?? 'Terjadi kesalahan.',
    };
  }

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
          await prefs.setString('userId', user['id'].toString());
          await prefs.setString('userName', user['name'] ?? '');
          await prefs.setString('userEmail', user['email'] ?? '');
          await prefs.setString('nomorKK', user['nomor_kk'] ?? '');
          await prefs.setString('nomorNIK', user['nomor_nik'] ?? '');
          await prefs.setString('tempatLahir', user['tempat_lahir'] ?? '');
          await prefs.setString('tanggalLahir', user['tanggal_lahir'] ?? '');
          await prefs.setString('jenisKelamin', user['jenis_kelamin'] ?? '');
          await prefs.setString('pekerjaan', user['pekerjaan'] ?? '');
          await prefs.setString('status', user['status'] ?? '');
          await prefs.setString('alamatRT005', user['alamat_rt005'] ?? '');
          await prefs.setString('alamatKTP', user['alamat_ktp'] ?? '');
          await prefs.setString('role', user['role'] ?? '');

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
