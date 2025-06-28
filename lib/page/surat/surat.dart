import 'package:flutter/material.dart';
import 'package:concept/core/services/surat_service.dart';
import 'package:concept/core/services/jenissurat_service.dart';
import 'package:concept/core/models/jenissurat_model.dart';

class SuratPage extends StatefulWidget {
  const SuratPage({super.key});

  @override
  State<SuratPage> createState() => _SuratPageState();
}

class _SuratPageState extends State<SuratPage> {
  String? _responseMessage;
  Color? _responseColor;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tujuanController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  List<JenisSurat> jenisList = [];
  JenisSurat? selectedJenis;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadJenisSurat();
  }

  void _loadJenisSurat() async {
    try {
      final result = await JenisSuratService.fetchJenisSurat();
      setState(() {
        jenisList = result;
        if (jenisList.isNotEmpty) selectedJenis = jenisList.first;
      });
    } catch (e) {
      print(e);
    }
  }

  void _submitSurat() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = null;
    });

    try {
      await SuratService.createSurat(
        atasNama: _namaController.text,
        idJenisSurat: selectedJenis!.id,
        ditunjukan: _tujuanController.text,
        keterangan: _keteranganController.text,
      );

      setState(() {
        _responseMessage = "Surat berhasil ditambahkan.";
        _responseColor = Colors.green.shade700;

        // Clear form (opsional)
        _namaController.clear();
        _tujuanController.clear();
        _keteranganController.clear();
        selectedJenis = jenisList.isNotEmpty ? jenisList.first : null;
      });
    } catch (e) {
      setState(() {
        _responseMessage = "Gagal menambahkan surat.";
        _responseColor = Colors.red.shade700;
      });
    }

    setState(() => _isLoading = false);
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFA5A5A5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFA5A5A5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1E5993), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
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
          'Surat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Form Surat',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text(
                      'Pastikan data yang Anda isi sudah benar dan sesuai dengan identitas diri. Setelah permohonan terkirim, pihak desa akan memproses dan menghubungi Anda jika diperlukan.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    if (_responseMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 4),
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _responseColor?.withOpacity(0.1),
                          border:
                              Border.all(color: _responseColor ?? Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _responseMessage!,
                          style: TextStyle(
                            color: _responseColor ?? Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      'Jenis Surat',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.white, // background dropdown list
                        shadowColor:
                            Colors.black.withOpacity(0.2), // efek shadow
                        cardTheme: CardThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 6, // efek shadow lebih terasa
                        ),
                      ),
                      child: DropdownButtonFormField<JenisSurat>(
                        value: selectedJenis,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFA5A5A5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFA5A5A5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF1E5993), width: 1.5),
                          ),
                        ),
                        items: jenisList.map((jenis) {
                          return DropdownMenuItem(
                            value: jenis,
                            child: Text(jenis.nama_jenis),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedJenis = value!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Pilih jenis surat' : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Atas Nama',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFA5A5A5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFA5A5A5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xFF1E5993), width: 1.5),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ditunjukan Kepada',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _tujuanController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFA5A5A5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFA5A5A5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xFF1E5993), width: 1.5),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Tujuan wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Keterangan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _keteranganController,
                      minLines: 4,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFA5A5A5)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFA5A5A5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xFF1E5993), width: 1.5),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Keterangan wajib diisi' : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitSurat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5993),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Simpan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
