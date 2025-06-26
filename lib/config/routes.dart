// lib/config/routes.dart
import 'package:flutter/material.dart';
import 'package:concept/page/auth/login.dart';
import 'package:concept/page/home/homepages.dart';
import 'package:concept/page/auth/loginsignup.dart';
import 'package:concept/page/auth/signup.dart';
import 'package:concept/editproduct.dart';
import 'package:concept/page/informasi/berita/detail_berita.dart';
import 'package:concept/core/models/berita_model.dart';
import 'package:concept/page/informasi/informasi.dart';
import 'package:concept/page/laporan/laporan.dart';
// import 'package:concept/page/keuangan/iuran_page.dart';
// import 'package:concept/page/surat/surat_page.dart';
// import 'package:concept/page/kegiatan/kegiatan_page.dart';
// import 'package:concept/page/layanan/donasi_page.dart';
// import 'package:concept/page/profile/profile_page.dart';
// import 'package:concept/page/kontak/kontak_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => LoginPage(),
    '/loginsign': (context) => LoginPageSign(),
    '/signup': (context) => SignupPage(),
    '/home': (context) => HomePage(),
    '/informasi': (context) => const InformasiPage(),
    '/laporan': (context) => const LaporanPage(),
    // '/iuran': (context) => const IuranPage(),
    // '/berita': (context) => const SuratPage(),
    // '/kegiatan': (context) => const KegiatanPage(),
    // '/layanan': (context) => const DonasiPage(),
    // '/info': (context) => const ProfilePage(),
    // '/kontak': (context) => const KontakPage(),
    // '/lainnya': (context) => const LaporanPage(),
  };

  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, bool isLoggedIn) {
    if (isLoggedIn &&
        (settings.name == '/login' ||
            settings.name == '/loginsign' ||
            settings.name == '/signup')) {
      return MaterialPageRoute(builder: (_) => HomePage());
    }

    if (settings.name == '/editproduct') {
      try {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditProductPage(
            productId: args['productId'],
            productData: args['productData'],
          ),
        );
      } catch (e) {
        print("Error: $e");
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
        print("Error saat parsing argumen detail berita: $e");
        return null;
      }
    }

    return null;
  }
}
