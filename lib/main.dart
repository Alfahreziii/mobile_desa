import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:concept/config/routes.dart';
import 'package:concept/core/services/shared_prefs_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final isLoggedIn = await SharedPrefsService.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'concept',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Merriweather',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: isLoggedIn ? '/home' : '/loginsign',
      routes: AppRoutes.routes,
      onGenerateRoute: (settings) =>
          AppRoutes.onGenerateRoute(settings, isLoggedIn),
    );
  }
}
