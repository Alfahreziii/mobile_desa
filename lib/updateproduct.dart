import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class updateProduct extends StatefulWidget {
  const updateProduct({super.key, this.title});
  final String? title;

  @override
  _updateProductState createState() => _updateProductState();
}

class _updateProductState extends State<updateProduct>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = "All";
  String searchQuery = ""; // Variabel untuk menyimpan query pencarian
  List<ProductCard> allProducts = []; // List untuk menyimpan data produk

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      setState(() {
        selectedCategory = _tabController.index == 0
            ? "All"
            : _tabController.index == 1
                ? "Food"
                : _tabController.index == 2
                    ? "Drink"
                    : _tabController.index == 3
                        ? "Snack"
                        : "";
      });
    });
    fetchProducts(); // Memanggil fungsi untuk mengambil data produk
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8000/product')); // Ganti dengan URL API Anda

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = (data['products'] as List)
            .map((product) => ProductCard.fromJson(product, deleteProduct))
            .toList();

        setState(() {
          allProducts = products;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/delete_product/$productId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          allProducts.removeWhere((product) => product.id_product == productId);
        });
      } else {
        throw Exception('Failed to delete product');
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
      final matchesCategory =
          selectedCategory == "All" || product.category == selectedCategory;
      return matchesSearchQuery &&
          matchesCategory; // Hanya produk yang cocok dengan kategori dan query
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // Remove AppBar and replace it with a custom header
      body: Column(
        children: [
          // Tab Bar
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(0, 25), // Ubah nilai x untuk menggeser ke kiri
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              indicator: const BoxDecoration(
                color: Color(0xFF2D4F2B),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              unselectedLabelColor: const Color(0xFF2E294A),
              labelStyle: const TextStyle(
                fontFamily: 'biasa1',
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Food"),
                Tab(text: "Drink"),
                Tab(text: "Snacks"),
              ],
            ),
          ),

          // ListView of products
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchProducts,
              child: ListView(
                padding: const EdgeInsets.all(5),
                children: filteredProducts.isEmpty
                    ? [const Center(child: Text("No products found."))]
                    : filteredProducts, // Tampilkan hasil filter dan pencarian
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
  final String id_product;
  final Function(String) onDelete;

  const ProductCard({
    super.key,
    required this.imageAssetPath,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.id_product,
    required this.onDelete,
  });

  factory ProductCard.fromJson(
      Map<String, dynamic> json, Function(String) onDelete) {
    return ProductCard(
      imageAssetPath: json['image'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
      id_product: json['id_product'],
      onDelete: onDelete, // Pastikan fungsi ini dioper ke parameter
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ), // Margin luar untuk card
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Radius untuk sudut card
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.2), // Warna bayangan dengan transparansi
            offset: const Offset(
                0, 25), // Jarak bayangan (x: horizontal, y: vertikal)
            blurRadius: 30, // Seberapa buram bayangan
            spreadRadius: 0, // Seberapa jauh bayangan menyebar
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white, // Pastikan background dari Card tetap putih
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Use Stack to overlay the heart icon on top of the image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: 'http://10.0.2.2:8000/products/$imageAssetPath',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned for placing the heart icon inside the image
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: SizedBox(
                        width: 28, // Adjust this for circular background size
                        height: 28, // Adjust this for circular background size
                        child: IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Colors.red,
                          onPressed: () {},
                          iconSize: 16, // Adjust this for the heart icon size
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets
                              .zero, // Removes extra padding around the icon
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'biasa',
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6D697A),
                          fontFamily: 'biasa1',
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6D697A),
                        fontFamily: 'biasa1',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp$price',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E294A),
                            fontFamily: 'biasa',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D4F2B),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            minimumSize: const Size(50, 28),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/editproduct',
                                arguments: {
                                  'productId':
                                      id_product, // Ganti dengan ID produk yang sesuai
                                  'productData': {
                                    'title': title,
                                    'description': description,
                                    'price': price,
                                    'category': category, // Tambahkan kategori
                                    'image':
                                        imageAssetPath, // Tambahkan path gambar
                                  },
                                },
                              );
                            },
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'biasa1',
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Product'),
                                content: const Text(
                                    'Are you sure you want to delete this product?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete ?? false) {
                              onDelete(
                                  id_product); // Pastikan ini memanggil properti onDelete
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Product deleted successfully!')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            minimumSize: const Size(50, 28),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black,
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'biasa1',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
