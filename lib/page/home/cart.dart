import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:concept/core/models/product_model.dart';
import 'package:concept/core/services/product_service.dart';
import 'package:concept/core/services/cache/custom_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:concept/config/env.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:concept/core/services/toko_service.dart';
import 'package:concept/page/home/toko/toko_detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Product>> _futureProduct;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _futureProduct = _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {
    final products = await ProductService.fetchProduct();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
    });
    return products;
  }

  Future<void> _refreshProducts() async {
    final products = await ProductService.fetchProduct();
    setState(() {
      _allProducts = products;
      _filteredProducts = searchQuery.isNotEmpty
          ? products.where((product) {
              final name = product.nama_produk.toLowerCase();
              final desc = product.deskripsi.toLowerCase();
              return name.contains(searchQuery.toLowerCase()) ||
                  desc.contains(searchQuery.toLowerCase());
            }).toList()
          : products;
    });
  }

  void _launchWhatsApp(String noHp, String message) async {
    String phone = noHp.replaceFirst('0', '62');
    final url =
        Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
      );
    }
  }

  void _filterProducts(String query) {
    final filtered = _allProducts.where((product) {
      final name = product.nama_produk.toLowerCase();
      final desc = product.deskripsi.toLowerCase();
      return name.contains(query.toLowerCase()) ||
          desc.contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      _filteredProducts = filtered;
    });
  }

  void _showProductDetailModal(Product product) async {
    final toko = await TokoService.getTokoById(product.id_toko);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (product.foto.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: '${Env.fileUrl}/${product.foto}',
                      cacheManager: CustomCacheManager.instance,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  product.nama_produk,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(product.deskripsi),
                const SizedBox(height: 8),
                Text(
                  product.stok > 0 ? 'Stok: ${product.stok}' : 'Stok Habis',
                  style: TextStyle(
                    color: product.stok > 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  NumberFormat.currency(
                          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                      .format(product.harga),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TokoDetailScreen(toko: toko),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: toko.foto != null
                              ? '${Env.fileUrl}/${toko.foto}'
                              : '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.store),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          toko.namaToko ?? 'Nama Toko Tidak Tersedia',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final message = '''
Halo, saya ingin membeli produk:
📦 Nama Produk: ${product.nama_produk}
💵 Harga: Rp ${product.harga}
🛒 Stok: ${product.stok}

Apakah masih tersedia?
''';
                      _launchWhatsApp(product.no_hp_toko, message);
                    },
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 16),
                    label: const Text('Hubungi via WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Place'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "Cari produk...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _futureProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'));
                } else if (_filteredProducts.isEmpty) {
                  return const Center(child: Text('Produk tidak ditemukan.'));
                }

                return RefreshIndicator(
                  onRefresh: _refreshProducts,
                  child: GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final item = _filteredProducts[index];
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.foto.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: '${Env.fileUrl}/${item.foto}',
                                    cacheManager: CustomCacheManager.instance,
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
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                item.nama_produk,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.deskripsi,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.stok > 0
                                    ? 'Stok: ${item.stok}'
                                    : 'Stok Habis',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      item.stok > 0 ? Colors.green : Colors.red,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(item.harga),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showProductDetailModal(item);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    textStyle: const TextStyle(fontSize: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Beli'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
