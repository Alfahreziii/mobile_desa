import 'package:flutter/material.dart';
import 'package:concept/core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("email or password cannot be empty.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.login(email, password);

      if (result['success']) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorDialog(result['message']);
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
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
                  bottom: BorderSide(color: Color(0xFFFB0711), width: 9.08),
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Bar
                  const SizedBox(height: 45),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset(
                          -11, 0), // Ubah nilai x untuk menggeser ke kiri
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pushNamed(context, '/loginsign');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/image/logo.png',
                    ),
                  ),
                  const SizedBox(height: 56),
                  // Login Title
                  Align(
                    alignment: Alignment.centerLeft, // Mengatur gambar ke kiri
                    child: Image.asset(
                      'assets/image/login.png',
                    ),
                  ),
                  const Text(
                    'Hello There!\nWelcome Back',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF2E294A),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),
                  // Input Forms
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color(0xFF6D697A),
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFB0711)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color(0xFF6D697A),
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFB0711)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Login Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFB0711),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 7),
                            ),
                            onPressed: _login,
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Color(0xFF6D697A),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          ' Sign up',
                          style: TextStyle(
                            color: Color(0xFFFB0711),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
