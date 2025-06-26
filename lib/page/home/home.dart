import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/core/models/berita_model.dart';
import 'package:concept/core/services/berita_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:concept/config/env.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key, this.title});
  final String? title;

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> with TickerProviderStateMixin {
  String userName = '';

  List<Berita> beritaList = [];

  void _loadBerita() async {
    try {
      final berita = await BeritaService.fetchBerita();
      setState(() {
        beritaList = berita.reversed.take(5).toList(); // ambil 5 berita terbaru
      });
    } catch (e) {
      print(e.toString());
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
      backgroundColor: const Color(0xFFF5F5F5),
      // Remove AppBar and replace it with a custom header
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 50),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(8, (index) {
                  final List<Map<String, dynamic>> menuItems = [
                    {
                      'title': 'INFORMASI',
                      'image': 'assets/image/informasi.png',
                      'route': '/informasi',
                    },
                    {
                      'title': 'ADUAN',
                      'image': 'assets/image/aduan.png',
                      'route': '/iuran',
                    },
                    {
                      'title': 'SURAT',
                      'image': 'assets/image/surat.png',
                      'route': '/berita',
                    },
                    {
                      'title': 'IURAN',
                      'image': 'assets/image/iuran.png',
                      'route': '/kegiatan',
                    },
                    {
                      'title': 'DONASI',
                      'image': 'assets/image/donasi.png',
                      'route': '/layanan',
                    },
                    {
                      'title': 'PROFIL',
                      'image': 'assets/image/profil.png',
                      'route': '/info',
                    },
                    {
                      'title': 'Kontak',
                      'image': 'assets/image/agenda.png',
                      'route': '/kontak',
                    },
                    {
                      'title': 'LAPORAN',
                      'image': 'assets/image/laporan.png',
                      'route': '/lainnya',
                    },
                  ];

                  final item = menuItems[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, item['route']);
                    },
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
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            //Informasi Terkini
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Informasi Terkini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E294A),
                ),
              ),
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: beritaList.length,
                itemBuilder: (context, index) {
                  final berita = beritaList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detail-berita',
                        arguments: berita,
                      );
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: '${Env.fileUrl}/${berita.foto}',
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2)),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, left: 8.0, top: 8.0),
                            child: Text(
                              berita.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF2E294A),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              berita.created_at_formatted,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
