import 'package:flutter/material.dart';
import 'package:concept/core/models/laporan_model.dart';
import 'package:concept/core/services/laporan_service.dart';
import 'package:intl/intl.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  List<Laporan> laporanList = [];
  Laporan? selectedLaporan;

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  void _loadLaporan() async {
    try {
      final result = await LaporanService.fetchLaporan();
      setState(() {
        laporanList = result;
        if (laporanList.isNotEmpty) {
          selectedLaporan = laporanList.first;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  String formatMonth(String dateString) {
    try {
      final date = DateFormat('yyyy-MM').parse(dateString);
      return DateFormat('MMMM yyyy', 'id_ID').format(date); // contoh: Juni 2025
    } catch (e) {
      return dateString;
    }
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 5,
              child: Text(label, style: const TextStyle(fontSize: 14))),
          const Text(':'),
          const SizedBox(width: 8),
          Expanded(
              flex: 5,
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final laporan = selectedLaporan;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Text('Laporan Bulanan'),
        centerTitle: true,
      ),
      body: laporan == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.5, // 50% dari layar
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Laporan>(
                        isExpanded: true,
                        value: selectedLaporan,
                        onChanged: (value) {
                          setState(() {
                            selectedLaporan = value!;
                          });
                        },
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        items: laporanList.map((lap) {
                          return DropdownMenuItem(
                            value: lap,
                            child: Text(formatMonth(lap.tanggal_laporan)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 6)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Demografi',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text(
                          'Data ini bertujuan untuk memberikan gambaran yang jelas mengenai profil penduduk desa, serta mendukung transparansi dan perencanaan pembangunan yang lebih baik.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        buildRow(
                            'Jumlah Rumah', '${laporan.jumlah_rumah} Rumah'),
                        buildRow('Jumlah KK', '${laporan.jumlah_kk} KK'),
                        buildRow(
                            'Jumlah Jiwa', '${laporan.jumlah_penduduk} Jiwa'),
                        buildRow(
                          'Jumlah Laki-laki',
                          '${laporan.jumlah_laki} Jiwa (${((laporan.jumlah_laki / (laporan.jumlah_penduduk == 0 ? 1 : laporan.jumlah_penduduk)) * 100).toStringAsFixed(0)}%)',
                        ),
                        buildRow(
                          'Jumlah Perempuan',
                          '${laporan.jumlah_perempuan} Jiwa (${((laporan.jumlah_perempuan / (laporan.jumlah_penduduk == 0 ? 1 : laporan.jumlah_penduduk)) * 100).toStringAsFixed(0)}%)',
                        ),
                        buildRow(
                            'Jumlah Meninggal',
                            laporan.jumlah_meninggal > 0
                                ? '${laporan.jumlah_meninggal}'
                                : '-'),
                        buildRow(
                            'Jumlah Lahir',
                            laporan.jumlah_lahir > 0
                                ? '${laporan.jumlah_lahir}'
                                : '-'),
                        buildRow(
                            'Jumlah Pindah',
                            laporan.jumlah_pindah > 0
                                ? '${laporan.jumlah_pindah}'
                                : '-'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
