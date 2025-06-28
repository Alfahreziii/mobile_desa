import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // penting untuk content-type
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/config/env.dart';

class AduanService {
  static Future<bool> createAduan({
    required String judul,
    required String keterangan,
    required String fotoPath,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak tersedia. Harap login terlebih dahulu.');
    }

    var uri = Uri.parse('${Env.baseUrl}/aduan');
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      })
      ..fields['judul'] = judul
      ..fields['keterangan'] = keterangan;

    // Tambahkan file gambar
    var file = await http.MultipartFile.fromPath(
      'foto', // pastikan field name ini sesuai dengan backend
      fotoPath,
      contentType: MediaType('image', _getImageMimeType(fotoPath)),
    );

    request.files.add(file);

    var response = await request.send();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      print(await response.stream
          .bytesToString()); // print pesan error dari backend
      return false;
    }
  }

  static String _getImageMimeType(String path) {
    if (path.endsWith('.png')) return 'png';
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'jpeg';
    if (path.endsWith('.gif')) return 'gif';
    return 'jpeg'; // default
  }
}
