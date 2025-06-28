import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:concept/core/models/iuran_model.dart';
import 'package:concept/core/services/iuran_service.dart';

class IuranPage extends StatefulWidget {
  const IuranPage({super.key});

  @override
  State<IuranPage> createState() => _IuranPageState();
}

class _IuranPageState extends State<IuranPage> {
  List<IuranModel> _iuranList = [];
  Set<int> _selectedIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIuran();
  }

  Future<void> _loadIuran() async {
    try {
      final list = await IuranService.fetchIuranList();
      setState(() {
        _iuranList = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('❌ Gagal memuat data iuran: $e');
    }
  }

  int get _totalHarga {
    return _iuranList
        .where((e) => _selectedIds.contains(e.id))
        .fold(0, (sum, e) => sum + e.harga);
  }

  String formatBulan(String bulanStr) {
    try {
      final date =
          DateTime.parse(bulanStr); // parse dari string seperti "2025-05-01"
      return DateFormat('MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return bulanStr; // fallback kalau parsing gagal
    }
  }

  Future<void> _sendToWhatsApp() async {
    final selected =
        _iuranList.where((e) => _selectedIds.contains(e.id)).toList();
    final total =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(_totalHarga);
    final bulanList = selected.map((e) => formatBulan(e.bulan)).join(', ');

    final pesan =
        'Halo, saya ingin membayar iuran sebesar $total untuk bulan: $bulanList';

    final bendaharaNo = '6282112318744'; // ← ganti dengan nomor WA bendahara
    final url = 'https://wa.me/$bendaharaNo?text=${Uri.encodeComponent(pesan)}';

    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka WhatsApp: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          'Iuran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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
                        const Text('Pembayaran Iuran',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text(
                          'Silakan isi form berikut untuk melakukan pembayaran atau pelaporan iuran. Pastikan data yang Anda masukkan sudah benar.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        RefreshIndicator(
                          onRefresh: _loadIuran,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _iuranList.length,
                            itemBuilder: (context, index) {
                              final item = _iuranList[index];
                              return CheckboxListTile(
                                visualDensity:
                                    const VisualDensity(horizontal: -4),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: item.status == 'lunas'
                                    ? true
                                    : _selectedIds.contains(item.id),
                                onChanged: item.status == 'lunas'
                                    ? null
                                    : (val) {
                                        setState(() {
                                          if (val == true) {
                                            _selectedIds.add(item.id);
                                          } else {
                                            _selectedIds.remove(item.id);
                                          }
                                        });
                                      },
                                activeColor: item.status == 'lunas'
                                    ? const Color(0xFFA5A5A5)
                                    : const Color(0xFF6EAA24),
                                checkColor: Colors.white,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatBulan(item.bulan)),
                                    if (item.status == 'lunas')
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'Lunas',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                                secondary: Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(item.harga),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Jumlah Dibayarkan:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(_totalHarga),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedIds.isEmpty ? null : _sendToWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6EAA24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Bayar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
