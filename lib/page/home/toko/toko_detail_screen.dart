import 'package:flutter/material.dart';
import 'package:concept/core/models/toko_model.dart';
import 'package:concept/core/models/product_model.dart';
import 'package:concept/core/services/product_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:concept/config/env.dart';
import 'package:concept/core/services/cache/custom_cache_manager.dart';
import 'package:intl/intl.dart';

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
      final produkToko =
          semuaProduk.where((p) => p.id_toko == widget.toko.id).toList();

      setState(() {
        _produkToko = produkToko;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk: $e')),
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
                        return Card(
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
                            title: Text(item.nama_produk),
                            subtitle: Text(NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(item.harga)),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
