import 'package:flutter/material.dart';

import 'package:kedai/core/services/berita_service.dart';
import 'package:kedai/core/services/kerjabakti_service.dart';
import 'package:kedai/core/services/rapat_service.dart';
import 'package:kedai/core/services/pengajian_service.dart';
import 'package:kedai/core/services/tahlil_service.dart';

import 'package:kedai/core/models/kerjabakti_model.dart';
import 'package:kedai/core/models/berita_model.dart';
import 'package:kedai/core/models/rapat_model.dart';
import 'package:kedai/core/models/pengajian_model.dart';
import 'package:kedai/core/models/tahlil_model.dart';

import 'package:kedai/widgets/card/berita_card.dart';
import 'package:kedai/widgets/card/kerjabakti_card.dart';
import 'package:kedai/widgets/card/rapat_card.dart';
import 'package:kedai/widgets/card/pengajian_card.dart';
import 'package:kedai/widgets/card/tahlil_card.dart';

class InformasiPage extends StatefulWidget {
  const InformasiPage({super.key, this.title});
  final String? title;

  @override
  _InformasiPageState createState() => _InformasiPageState();
}

class _InformasiPageState extends State<InformasiPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = "Berita";
  String searchQuery = "";

  List<Berita> beritaList = [];
  List<Rapat> rapatList = [];
  List<KerjaBakti> kerjabaktiList = [];
  List<Pengajian> pengajianList = [];
  List<Tahlil> tahlilList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedCategory = _tabController.index == 0
              ? "Berita"
              : _tabController.index == 1
                  ? "Rapat"
                  : _tabController.index == 2
                      ? "Kerja Bakti"
                      : _tabController.index == 3
                          ? "Pengajian"
                          : "Tahlil";
        });
        fetchDataByCategory();
      }
    });

    fetchDataByCategory();
  }

  Future<void> fetchDataByCategory() async {
    try {
      if (selectedCategory == "Berita") {
        final berita = await BeritaService.fetchBerita();
        setState(() => beritaList = berita);
      } else if (selectedCategory == "Rapat") {
        final rapat = await RapatService.fetchRapat();
        setState(() => rapatList = rapat);
      } else if (selectedCategory == "Kerja Bakti") {
        final kerjabakti = await KerjabaktiService.fetchKerjaBakti();
        setState(() => kerjabaktiList = kerjabakti);
      } else if (selectedCategory == "Pengajian") {
        final pengajian = await PengajianService.fetchPengajian();
        setState(() => pengajianList = pengajian);
      } else if (selectedCategory == "Tahlil") {
        final tahlil = await TahlilService.fetchTahlil();
        setState(() => tahlilList = tahlil);
      }
      // Tambahkan fetchData untuk kategori lain
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Informasi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16.0, top: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                indicator: const BoxDecoration(
                  color: Color(0xFF02046B),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                unselectedLabelColor: const Color(0xFF2E294A),
                labelStyle: const TextStyle(fontSize: 16),
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 16), // KUNCI UTAMA DI SINI
                tabs: const [
                  Tab(text: "Berita"),
                  Tab(text: "Rapat"),
                  Tab(text: "Kerja Bakti"),
                  Tab(text: "Pengajian"),
                  Tab(text: "Tahlil"),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchDataByCategory,
              child: Builder(
                builder: (_) {
                  if (selectedCategory == "Berita") {
                    final filtered = beritaList
                        .where((b) => b.judul
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 0.98,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => BeritaCard(
                        berita: filtered[index],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail-berita',
                            arguments: beritaList[index],
                          );
                        },
                      ),
                    );
                  } else if (selectedCategory == "Rapat") {
                    final filtered = rapatList
                        .where((r) => r.bahasan
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          RapatCard(rapat: filtered[index]),
                    );
                  } else if (selectedCategory == "Kerja Bakti") {
                    final filtered = kerjabaktiList
                        .where((r) => r.tempat
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          KerjaBaktiCard(kerjabakti: filtered[index]),
                    );
                  } else if (selectedCategory == "Pengajian") {
                    final filtered = pengajianList
                        .where((r) => r.judul
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          PengajianCard(pengajian: filtered[index]),
                    );
                  } else if (selectedCategory == "Tahlil") {
                    final filtered = tahlilList
                        .where((r) => r.judul
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()))
                        .toList();
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          TahlilCard(tahlil: filtered[index]),
                    );
                  }
                  return const Center(child: Text("Tidak ada data."));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
