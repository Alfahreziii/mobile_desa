import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:concept/config/env.dart';
import 'package:concept/core/models/pengurus_model.dart';
import 'package:concept/core/services/cache/custom_cache_manager.dart';
import 'package:concept/core/services/pengurus_service.dart';

class PengurusPage extends StatefulWidget {
  const PengurusPage({super.key, this.title});
  final String? title;

  @override
  State<PengurusPage> createState() => _PengurusPageState();
}

class _PengurusPageState extends State<PengurusPage> {
  List<Pengurus> pengurusList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPengurus();
  }

  void _loadPengurus() async {
    try {
      final result = await PengurusService.fetchPengurus();
      setState(() {
        pengurusList = result;
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
        title: const Text('Susunan Pengurus'),
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
              onRefresh: _refreshPengurus,
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.55,
                ),
                itemCount: pengurusList.length,
                itemBuilder: (context, index) {
                  final pengurus = pengurusList[index];

                  return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pengurus.foto.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              left: 4,
                              right: 4,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: '${Env.fileUrl}/${pengurus.foto}',
                                cacheManager: CustomCacheManager.instance,
                                width: double.infinity,
                                height: 150,
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
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pengurus.jabatan_rel ?? pengurus.jabatan,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF2E294A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pengurus.nama,
                                style: const TextStyle(fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.email,
                                      size: 12, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      pengurus.email,
                                      style: const TextStyle(fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.phone,
                                      size: 12, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    pengurus.no_hp,
                                    style: const TextStyle(fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 12, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      pengurus.alamat,
                                      style: const TextStyle(fontSize: 13),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<void> _refreshPengurus() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await PengurusService.fetchPengurus();
      setState(() {
        pengurusList = result;
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
