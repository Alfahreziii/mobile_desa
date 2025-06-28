import 'package:flutter/material.dart';
import 'package:concept/core/models/user_model.dart';
import 'package:concept/core/services/user_service.dart';
import 'package:concept/core/services/shared_prefs_service.dart';

class EmailPasswordPage extends StatefulWidget {
  final UserModel currentUser;

  const EmailPasswordPage({required this.currentUser});

  @override
  State<EmailPasswordPage> createState() => _EmailPasswordPageState();
}

class _EmailPasswordPageState extends State<EmailPasswordPage> {
  late UserModel _user;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSuccess = false;
  String _message = '';
  late String _initialEmail;
  String _oldPassword = '';

  @override
  void initState() {
    super.initState();
    _user = widget.currentUser.copyWith(password: '');
    _initialEmail = widget.currentUser.email;
  }

  Future<void> _submit() async {
    final emailChanged = _user.email != _initialEmail;
    final passwordFilled = _user.password.trim().isNotEmpty;

    if (!emailChanged && !passwordFilled) {
      setState(() {
        _message = 'Tidak ada perubahan yang dilakukan.';
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      await _promptOldPassword();

      if (_oldPassword.isEmpty) {
        setState(() {
          _message = 'Password lama wajib diisi untuk konfirmasi.';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _message = '';
      });

      final result = await UserService.updateEmailPassword(_user, _oldPassword);

      setState(() {
        _isLoading = false;
        _message = result['message'] ?? '';
        _isSuccess = result['success'] ?? false;
      });

      if (result['success']) {
        await SharedPrefsService.saveUser(_user.copyWith(password: ''));
      }
    }
  }

  Future<void> _promptOldPassword() async {
    String tempPassword = '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Password'),
          content: TextField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Masukkan Password Lama',
            ),
            onChanged: (val) {
              tempPassword = val;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(tempPassword),
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _oldPassword = result;
      });
    }
  }

  String? _validateEmail(String? val) {
    if (val == null || val.isEmpty) return 'Email wajib diisi';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(val) ? null : 'Format email tidak valid';
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
          'Email & Password',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Text('Form Email & Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text(
                      'Pastikan data yang Anda isi sudah benar dan sesuai dengan identitas diri. Setelah permohonan terkirim, pihak desa akan memproses dan menghubungi Anda jika diperlukan.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    if (_message.isNotEmpty) const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _message,
                        style: TextStyle(
                          color: _isSuccess ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text('Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: _user.email,
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
                      onChanged: (val) => _user = _user.copyWith(email: val),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 12),
                    const Text('Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 6),
                    TextFormField(
                        obscureText: true,
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
                        onChanged: (val) =>
                            _user = _user.copyWith(password: val),
                        validator: (val) {
                          if (val != null && val.isNotEmpty && val.length < 6) {
                            return 'Minimal 6 karakter';
                          }
                          return null;
                        }),
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
                            fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
