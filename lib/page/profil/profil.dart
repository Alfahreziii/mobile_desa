import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/core/models/berita_model.dart';
import 'package:concept/core/services/berita_service.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key, this.title});
  final String? title;

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> with TickerProviderStateMixin {
  String userName = '';
  bool isLoading = false;

  List<Berita> beritaList = [];

  void _loadBerita() async {
    setState(() {
      isLoading = true;
    });
    try {
      final berita = await BeritaService.fetchBerita();
      setState(() {
        beritaList = berita.reversed.take(5).toList();
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('userName');

    setState(() {
      userName = username ?? 'No Name';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBerita();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 16),
              color: const Color(0xFFF5F5F5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/image/logo.png', height: 55),
                      const SizedBox(width: 16),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: const Text(
                          "Taman Asri",
                          style: TextStyle(
                            color: Color(0xFF2E294A),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        "Hi 🙌🏻, $userName",
                        style: const TextStyle(
                          color: Color(0xFF2E294A),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset('assets/image/profile.png', height: 30),
                ],
              ),
            ),

            // Hero Image
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  "assets/image/hero.jpg",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
            ),

            // Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: GridView.count(
                crossAxisCount: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                childAspectRatio: 6,
                crossAxisSpacing: 10,
                children: List.generate(2, (index) {
                  final List<Map<String, dynamic>> menuItems = [
                    {
                      'title': 'Tinjauan Geografis',
                      'image': 'assets/image/geografis.jpg',
                      'route': '/geografis',
                    },
                    {
                      'title': 'Susunan Pengurus',
                      'image': 'assets/image/susunanpengurus.jpg',
                      'route': '/pengurus',
                    },
                  ];

                  final item = menuItems[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, item['route']);
                    },
                    child: SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item['image']),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            item['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
