import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl => dotenv.env['API_URL'] ?? '';
  static String get fileUrl => dotenv.env['FILE_URL'] ?? '';
}
