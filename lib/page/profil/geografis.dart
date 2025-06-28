import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:concept/config/env.dart';
import 'package:concept/core/models/geografis_model.dart';
import 'package:concept/core/services/cache/custom_cache_manager.dart';
import 'package:concept/core/services/geografis_service.dart';

class GeografisPage extends StatefulWidget {
  const GeografisPage({super.key, this.title});
  final String? title;

  @override
  State<GeografisPage> createState() => _GeografisPageState();
}

class _GeografisPageState extends State<GeografisPage> {
  List<Geografis> geografisList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGeografis();
  }

  void _loadGeografis() async {
    try {
      final result = await GeografisService.fetchGeografis();
      setState(() {
        geografisList = result;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geografis'),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshGeografis,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: geografisList.length,
                itemBuilder: (context, index) {
                  final geografis = geografisList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Judul di atas gambar dan di tengah
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Text(
                            geografis.judul,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF2E294A),
                            ),
                          ),
                        ),
                        if (geografis.foto.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: '${Env.fileUrl}/${geografis.foto}',
                                cacheManager: CustomCacheManager.instance,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 150,
                                  color: Colors.grey[200],
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2)),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<void> _refreshGeografis() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await GeografisService.fetchGeografis();
      setState(() {
        geografisList = result;
      });
    } catch (e) {
      print('Refresh Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
