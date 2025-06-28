import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/config/env.dart';
import 'package:concept/core/models/user_model.dart';

class UserService {
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('${Env.baseUrl}/users/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userData = data['data'];
        return UserModel.fromJson(userData);
      } else {
        print('❌ Gagal ambil profil: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error ambil profil: $e');
      return null;
    }
  }

  static Future<bool> updateProfile(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId'); // Pastikan disimpan saat login

    if (token == null || userId == null) {
      throw Exception('Token atau userId tidak tersedia.');
    }

    final response = await http.put(
      Uri.parse('${Env.baseUrl}/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error updateProfile: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  static Future<Map<String, dynamic>> updateEmailPassword(
      UserModel user, String oldPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token == null || userId == null) {
      return {'success': false, 'message': 'Token atau userId tidak tersedia.'};
    }

    try {
      final body = {
        'email': user.email,
        'old_password': oldPassword,
      };

      if (user.password.isNotEmpty) {
        body['password'] = user.password;
      }

      final response = await http.put(
        Uri.parse('${Env.baseUrl}/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Berhasil diperbarui',
        };
      } else {
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Terjadi kesalahan saat memperbarui',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: $e',
      };
    }
  }
}
