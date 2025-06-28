import 'package:flutter/material.dart';
import 'package:concept/core/models/user_model.dart';
import 'package:concept/core/services/user_service.dart';
import 'package:concept/core/services/shared_prefs_service.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel currentUser;

  const EditProfilePage({required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late UserModel _user;
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _user = widget.currentUser;
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _message = '';
      });

      final success = await UserService.updateProfile(_user);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        await SharedPrefsService.saveUser(_user); // ✅ Simpan perubahan ke lokal
        setState(() {
          _message = 'Profil berhasil diperbarui';
        });
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(
              context, true); // ✅ Kembali + kasih sinyal ke halaman sebelumnya
        }
      } else {
        setState(() {
          _message = 'Gagal memperbarui profil';
        });
      }
    }
  }

  Widget _buildDropdownField(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: Colors.white,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            fillColor: Colors.white,
          ),
          validator: (val) =>
              val == null || val.isEmpty ? 'Wajib dipilih' : null,
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(value) ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    dialogBackgroundColor:
                        Colors.white, // ✅ Background datepicker jadi putih
                    colorScheme: ColorScheme.light(
                      primary: Color(0xFF1E5993), // warna tombol/aksen
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              final formatted =
                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
              onChanged(formatted);
              setState(() {}); // agar UI terupdate
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              initialValue: value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String initialValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: onChanged,
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Wajib diisi' : null,
        ),
      ],
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
          'Edit Profile',
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
                      const Text('Form Edit Pofile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      const Text(
                        'Pastikan data yang Anda isi sudah benar dan sesuai dengan identitas diri.',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      if (_message.isNotEmpty) const SizedBox(height: 16),
                      const SizedBox(height: 12),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _message,
                            style: TextStyle(
                              color: _message.contains('berhasil')
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      _buildTextField('Nama', _user.name,
                          (val) => _user = _user.copyWith(name: val)),
                      const SizedBox(height: 12),
                      _buildTextField('Nomor KK', _user.nomorKK,
                          (val) => _user = _user.copyWith(nomorKK: val)),
                      const SizedBox(height: 12),
                      _buildTextField('Nomor NIK', _user.nomorNIK,
                          (val) => _user = _user.copyWith(nomorNIK: val)),
                      const SizedBox(height: 12),
                      _buildTextField('Tempat Lahir', _user.tempatLahir,
                          (val) => _user = _user.copyWith(tempatLahir: val)),
                      const SizedBox(height: 12),
// Tanggal Lahir (pakai DatePicker)
                      _buildDateField(
                        'Tanggal Lahir',
                        _user.tanggalLahir.length >= 10
                            ? _user.tanggalLahir.substring(0, 10)
                            : _user.tanggalLahir,
                        (val) => _user = _user.copyWith(tanggalLahir: val),
                      ),

                      const SizedBox(height: 12),

// Jenis Kelamin (pakai Dropdown)
                      _buildDropdownField(
                        'Jenis Kelamin',
                        _user.jenisKelamin,
                        ['Laki-laki', 'Perempuan'],
                        (val) =>
                            _user = _user.copyWith(jenisKelamin: val ?? ''),
                      ),
                      const SizedBox(height: 12),
                      _buildTextField('Pekerjaan', _user.pekerjaan,
                          (val) => _user = _user.copyWith(pekerjaan: val)),
                      const SizedBox(height: 12),
                      _buildTextField('Status', _user.status,
                          (val) => _user = _user.copyWith(status: val)),
                      const SizedBox(height: 12),
                      _buildTextField('Alamat RT005', _user.alamatRT005,
                          (val) => _user = _user.copyWith(alamatRT005: val)),
                      const SizedBox(height: 12),
                      _buildTextField('Alamat KTP', _user.alamatKTP,
                          (val) => _user = _user.copyWith(alamatKTP: val)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
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
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                ),
              ),
            ],
          )),
    );
  }
}
