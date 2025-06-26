import 'package:flutter/material.dart';
import 'package:concept/core/models/berita_model.dart';
import 'package:concept/config/env.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailBeritaPage extends StatelessWidget {
  final Berita berita;

  const DetailBeritaPage({super.key, required this.berita});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              Text(
                berita.judul,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 1),

              // Tanggal
              Text(
                berita.created_at_formatted,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),

              // Gambar
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: '${Env.fileUrl}/${berita.foto}',
                    placeholder: (context, url) => Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )),
              const SizedBox(height: 16),

              // Deskripsi
              Text(
                berita.deskripsi,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                  fontFamily: 'Merriweather',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
