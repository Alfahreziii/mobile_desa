import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

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
  List<ProductCard> allProducts = [];

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
    String endpoint = "";

    switch (selectedCategory) {
      case "Berita":
        endpoint = 'http://10.0.2.2:8000/berita';
        break;
      case "Rapat":
        endpoint = 'http://10.0.2.2:8000/rapat';
        break;
      case "Kerja Bakti":
        endpoint = 'http://10.0.2.2:8000/kerjabakti';
        break;
      case "Pengajian":
        endpoint = 'http://10.0.2.2:8000/pengajian';
        break;
      case "Tahlil":
        endpoint = 'http://10.0.2.2:8000/tahlil';
        break;
    }

    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<ProductCard> products = [];

        if (selectedCategory == "Berita") {
          products = (data['berita'] as List)
              .map((item) => ProductCard(
                    imageAssetPath: item['foto'] ?? '',
                    title: item['judul'] ?? '',
                    description: item['deskripsi'] ?? '',
                    category: 'Berita',
                    price: '0',
                  ))
              .toList();
        } else if (selectedCategory == "Rapat") {
          products = (data['rapat'] as List)
              .map((item) => ProductCard(
                    imageAssetPath: '',
                    title: item['hari'] ?? '',
                    description:
                        '${item['bahasan'] ?? ''} (${item['jam_mulai']} - ${item['jam_selesai']})',
                    category: 'Rapat',
                    price: '0',
                  ))
              .toList();
        }
        // Tambah kategori lain sesuai struktur data

        setState(() {
          allProducts = products;
        });
      }
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
    final filteredProducts = allProducts.where((product) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      final matchesSearchQuery =
          product.title.toLowerCase().contains(lowerCaseQuery);
      return matchesSearchQuery;
    }).toList();

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
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
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
// Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 12), // jarak antar tab
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              indicator: const BoxDecoration(
                color: Color(0xFF02046B),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              unselectedLabelColor: const Color(0xFF2E294A),
              labelStyle: const TextStyle(
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: "Berita"),
                Tab(text: "Rapat"),
                Tab(text: "Kerja Bakti"),
                Tab(text: "Pengajian"),
                Tab(text: "Tahlil"),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchDataByCategory,
              child: ListView(
                children: filteredProducts.isEmpty
                    ? [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Tidak ada data."),
                          ),
                        )
                      ]
                    : filteredProducts,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageAssetPath;
  final String title;
  final String description;
  final String category;
  final String price;

  const ProductCard({
    super.key,
    required this.imageAssetPath,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageAssetPath.isNotEmpty)
              CachedNetworkImage(
                imageUrl: 'http://10.0.2.2:8000/products/$imageAssetPath',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(description),
          ],
        ),
      ),
    );
  }
}
