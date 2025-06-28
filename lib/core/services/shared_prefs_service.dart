import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/core/models/user_model.dart';

class SharedPrefsService {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return UserModel(
      id: prefs.getString('userId') ?? '', // ✅ tambahkan ini
      name: prefs.getString('userName') ?? '',
      email: prefs.getString('userEmail') ?? '',
      password: '', // tidak perlu simpan password di local
      nomorKK: prefs.getString('nomorKK') ?? '',
      nomorNIK: prefs.getString('nomorNIK') ?? '',
      tempatLahir: prefs.getString('tempatLahir') ?? '',
      tanggalLahir: prefs.getString('tanggalLahir') ?? '',
      jenisKelamin: prefs.getString('jenisKelamin') ?? '',
      pekerjaan: prefs.getString('pekerjaan') ?? '',
      status: prefs.getString('status') ?? '',
      alamatRT005: prefs.getString('alamatRT005') ?? '',
      alamatKTP: prefs.getString('alamatKTP') ?? '',
      role: prefs.getString('role') ?? 'user',
    );
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id); // ✅ tambahkan ini
    await prefs.setString('userName', user.name);
    await prefs.setString('userEmail', user.email);
    await prefs.setString('nomorKK', user.nomorKK);
    await prefs.setString('nomorNIK', user.nomorNIK);
    await prefs.setString('tempatLahir', user.tempatLahir);
    await prefs.setString('tanggalLahir', user.tanggalLahir);
    await prefs.setString('jenisKelamin', user.jenisKelamin);
    await prefs.setString('pekerjaan', user.pekerjaan);
    await prefs.setString('status', user.status);
    await prefs.setString('alamatRT005', user.alamatRT005);
    await prefs.setString('alamatKTP', user.alamatKTP);
    await prefs.setString('role', user.role);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .clear(); // kamu bisa ganti dengan remove per key jika ingin lebih aman
  }
}
