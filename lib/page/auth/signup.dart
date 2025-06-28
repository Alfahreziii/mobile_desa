import 'package:flutter/material.dart';
import 'package:concept/core/models/user_model.dart';
import 'package:concept/core/services/auth_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int step = 1;
  bool _isLoading = false;
  bool _showPassword = false;
  bool _isChecked = false;
  String _stepErrorMessage = '';

  bool _validateStep1() {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty;
  }

  bool _validateStep2() {
    return nomorKKController.text.trim().isNotEmpty &&
        nomorNIKController.text.trim().isNotEmpty &&
        tempatLahirController.text.trim().isNotEmpty &&
        tanggalLahirController.text.trim().isNotEmpty &&
        selectedGender.isNotEmpty;
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nomorKKController = TextEditingController();
  final nomorNIKController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final pekerjaanController = TextEditingController();
  final statusController = TextEditingController();
  final alamatRT005Controller = TextEditingController();
  final alamatKTPController = TextEditingController();

  String selectedGender = '';

  void _nextStep() => setState(() => step++);
  void _prevStep() {
    setState(() {
      step--;
      _stepErrorMessage = ''; // bersihkan error saat kembali
    });
  }

  void _submitForm() async {
    setState(() => _isLoading = true);

    if ([
      nameController.text,
      emailController.text,
      passwordController.text,
      nomorKKController.text,
      nomorNIKController.text,
      tempatLahirController.text,
      tanggalLahirController.text,
      selectedGender,
      pekerjaanController.text,
      statusController.text,
      alamatRT005Controller.text,
      alamatKTPController.text
    ].any((e) => e.trim().isEmpty)) {
      setState(() {
        _stepErrorMessage = "Semua field wajib diisi.";
        _isLoading = false;
      });
      return;
    }

    if (!_isChecked) {
      setState(() {
        _stepErrorMessage = "Anda harus menyetujui syarat dan ketentuan.";
        _isLoading = false;
      });
      return;
    }

    final user = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      nomorKK: nomorKKController.text.trim(),
      nomorNIK: nomorNIKController.text.trim(),
      tempatLahir: tempatLahirController.text.trim(),
      tanggalLahir: tanggalLahirController.text.trim(),
      jenisKelamin: selectedGender,
      pekerjaan: pekerjaanController.text.trim(),
      status: statusController.text.trim(),
      alamatRT005: alamatRT005Controller.text.trim(),
      alamatKTP: alamatKTPController.text.trim(),
    );

    final result = await AuthService.register(user);

    if (result['success']) {
      _showSuccessDialog(result['message']);
      _clearForm();
    } else {
      setState(() {
        _stepErrorMessage = result['message'] ?? 'Terjadi kesalahan.';
      });
    }

    setState(() => _isLoading = false);
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    nomorKKController.clear();
    nomorNIKController.clear();
    tempatLahirController.clear();
    tanggalLahirController.clear();
    pekerjaanController.clear();
    statusController.clear();
    alamatRT005Controller.clear();
    alamatKTPController.clear();
    _isChecked = false;
    step = 1;
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hintText,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 53, 53, 54),
            fontSize: 16,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1E5993)),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 45),
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: Offset(-11, 0), // Ubah nilai x untuk menggeser ke kiri
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(height: 45),
          // Logo
          Center(
            child: Image.asset(
              'assets/image/logo.png',
            ),
          ),
          const SizedBox(height: 56),

          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/image/signup.png',
            ),
          ),
          const Text(
            'Hello There !\nWelcome To You',
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF2E294A),
            ),
          ),
          if (_stepErrorMessage.isEmpty) const SizedBox(height: 25),
          if (_stepErrorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _stepErrorMessage,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
            ),

          _buildTextField(label: 'Name', controller: nameController),
          _buildTextField(label: 'Email', controller: emailController),
          _buildTextField(
              label: 'Password',
              controller: passwordController,
              obscureText: !_showPassword,
              suffixIcon: IconButton(
                icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_validateStep1()) {
                  setState(() {
                    _stepErrorMessage = '';
                    _nextStep();
                  });
                } else {
                  setState(() {
                    _stepErrorMessage = "Isi semua data terlebih dahulu";
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E5993),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildStep2() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/image/signup.png',
            ),
          ),
          const Text(
            'Hello There !\nWelcome To You',
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF2E294A),
            ),
          ),
          if (_stepErrorMessage.isEmpty) const SizedBox(height: 25),
          if (_stepErrorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _stepErrorMessage,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
            ),
          _buildTextField(label: 'Nomor KK', controller: nomorKKController),
          _buildTextField(label: 'Nomor NIK', controller: nomorNIKController),
          _buildTextField(
              label: 'Tempat Lahir', controller: tempatLahirController),
          _buildTextField(
              label: 'Tanggal Lahir',
              hintText: 'YYYY-MM-DD',
              controller: tanggalLahirController),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
            value: selectedGender.isEmpty ? null : selectedGender,
            items: const [
              DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
              DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
            ],
            onChanged: (val) => setState(() => selectedGender = val ?? ''),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF02046B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: _prevStep,
                      child: const Text(
                        'Prev',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
              SizedBox(width: 8),
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E5993),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        if (_validateStep2()) {
                          setState(() {
                            _stepErrorMessage = '';
                            _nextStep();
                          });
                        } else {
                          setState(() {
                            _stepErrorMessage =
                                "Isi semua data terlebih dahulu";
                          });
                        }
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )))
            ],
          )
        ],
      );

  Widget _buildStep3() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/image/signup.png',
            ),
          ),
          const Text(
            'Hello There !\nWelcome To You',
            style: TextStyle(
              fontSize: 22,
              color: Color(0xFF2E294A),
            ),
          ),
          if (_stepErrorMessage.isEmpty) const SizedBox(height: 25),
          if (_stepErrorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _stepErrorMessage,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
            ),
          _buildTextField(label: 'Pekerjaan', controller: pekerjaanController),
          _buildTextField(label: 'Status', controller: statusController),
          _buildTextField(
              label: 'Alamat RT 005', controller: alamatRT005Controller),
          _buildTextField(label: 'Alamat KTP', controller: alamatKTPController),
          Row(
            children: [
              Checkbox(
                  value: _isChecked,
                  onChanged: (val) =>
                      setState(() => _isChecked = val ?? false)),
              const Expanded(
                  child: Text('I agree to the Terms and Conditions')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF02046B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: _prevStep,
                      child: const Text(
                        'Prev',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E5993),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: Text(
                    _isLoading ? 'Submitting...' : 'Sign Up',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 57,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFF02046B), width: 34.03),
                bottom: BorderSide(color: Color(0xFF1E5993), width: 9.08),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: step == 1
              ? _buildStep1()
              : step == 2
                  ? _buildStep2()
                  : _buildStep3(),
        ),
      ],
    ));
  }
}
