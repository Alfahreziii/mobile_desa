// lib/config/routes.dart
import 'package:flutter/material.dart';
import 'package:smartofficial/page/auth/login.dart';
import 'package:smartofficial/page/home/homepages.dart';
import 'package:smartofficial/page/auth/loginsignup.dart';
import 'package:smartofficial/page/auth/signup.dart';
import 'package:smartofficial/page/informasi/berita/detail_berita.dart';
import 'package:smartofficial/core/models/berita_model.dart';
import 'package:smartofficial/page/informasi/informasi.dart';
import 'package:smartofficial/page/laporan/laporan.dart';
import 'package:smartofficial/page/surat/surat.dart';
import 'package:smartofficial/page/profil/profil.dart';
import 'package:smartofficial/page/profil/pengurus.dart';
import 'package:smartofficial/page/profil/geografis.dart';
import 'package:smartofficial/page/aduan/aduan.dart';
import 'package:smartofficial/page/home/profile/edit.dart';
import 'package:smartofficial/page/home/profile/emailpassword.dart';
import 'package:smartofficial/page/iuran/iuran.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginPage(),
    '/loginsign': (context) => const LoginPageSign(),
    '/signup': (context) => const SignupPage(),
    '/home': (context) => const HomePage(),
    '/informasi': (context) => const InformasiPage(),
    '/laporan': (context) => const LaporanPage(),
    '/surat': (context) => const SuratPage(),
    '/profil': (context) => const ProfilPage(),
    '/pengurus': (context) => const PengurusPage(),
    '/geografis': (context) => const GeografisPage(),
    '/aduan': (context) => const AduanPage(),
    '/iuran': (context) => const IuranPage(),
  };

  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, bool isLoggedIn) {
    if (isLoggedIn &&
        (settings.name == '/login' ||
            settings.name == '/loginsign' ||
            settings.name == '/signup')) {
      return MaterialPageRoute(builder: (_) => const HomePage());
    }
    if (settings.name == '/editprofile') {
      try {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditProfilePage(currentUser: args['currentUser']),
        );
      } catch (e) {
        logger.d("Error saat parsing argumen edit profile: $e");
        return null;
      }
    }
    if (settings.name == '/emailpassword') {
      try {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EmailPasswordPage(
            currentUser: args['currentUser'],
          ),
        );
      } catch (e) {
        logger.d("Error parsing args untuk emailpassword: $e");
        return null;
      }
    }

    if (settings.name == '/detail-berita') {
      try {
        final berita = settings.arguments as Berita;
        return MaterialPageRoute(
          builder: (_) => DetailBeritaPage(berita: berita),
        );
      } catch (e) {
        logger.d("Error saat parsing argumen detail berita: $e");
        return null;
      }
    }

    return null;
  }
}
