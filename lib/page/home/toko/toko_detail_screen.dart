import 'package:flutter/material.dart';
import 'package:concept/core/models/toko_model.dart';
import 'package:concept/core/models/product_model.dart';
import 'package:concept/core/services/product_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:concept/config/env.dart';
import 'package:concept/core/services/cache/custom_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TokoDetailScreen extends StatefulWidget {
  final Toko toko;

  const TokoDetailScreen({super.key, required this.toko});

  @override
  State<TokoDetailScreen> createState() => _TokoDetailScreenState();
}

class _TokoDetailScreenState extends State<TokoDetailScreen> {
  List<Product> _produkToko = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProdukToko();
  }

  Future<void> _loadProdukToko() async {
    try {
      final semuaProduk = await ProductService.fetchProduct();
      if (!mounted) return;

      final produkToko =
          semuaProduk.where((p) => p.idToko == widget.toko.id).toList();

      setState(() {
        _produkToko = produkToko;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk: $e')),
      );
    }
  }

  void _showProductDetailModal(Product product) async {
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
                  product.namaProduk,
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final message = '''
Halo, saya ingin membeli produk:
📦 Nama Produk: ${product.namaProduk}
💵 Harga: Rp ${product.harga}
🛒 Stok: ${product.stok}

Apakah masih tersedia?
''';
                      _launchWhatsApp(product.noHpToko, message);
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

  void _launchWhatsApp(String noHp, String message) async {
    String phone = noHp.replaceFirst('0', '62');
    final url =
        Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final toko = widget.toko;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Detail Toko',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: '${Env.fileUrl}/${toko.foto}',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  cacheManager: CustomCacheManager.instance,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.store, size: 60),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toko.namaToko ?? 'Nama Toko Tidak Tersedia',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(toko.alamat ?? 'Alamat Toko Tidak Tersedia'),
                    const SizedBox(height: 2),
                    Text('📞 ${toko.noHp}'),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Produk Toko Ini',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _produkToko.isEmpty
                  ? const Text('Belum ada produk.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _produkToko.length,
                      itemBuilder: (context, index) {
                        final item = _produkToko[index];
                        return GestureDetector(
                          onTap: () => _showProductDetailModal(item),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            color: Colors.white,
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: '${Env.fileUrl}/${item.foto}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  cacheManager: CustomCacheManager.instance,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                              title: Text(item.namaProduk),
                              subtitle: Text(NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(item.harga)),
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
