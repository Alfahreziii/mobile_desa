import 'package:flutter/material.dart';
import 'package:concept/page/auth/login.dart';

class LoginPageSign extends StatelessWidget {
  const LoginPageSign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          // Mengatur background image
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/image/background.png'), // Ganti dengan path gambar Anda
              fit: BoxFit.cover, // Menyesuaikan gambar ke seluruh layar
            ),
          ),
        ),
        // Top Bar with Red-White-Blue lines
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
        // Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              // Logo
              Image.asset(
                'assets/image/logo.png', // Replace with your logo file
                width: 350, // Adjust size as needed
              ),
              const SizedBox(height: 230),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Log In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1E5993),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 7),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ));
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF02046B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 7),
                        ),
                        onPressed: () {
                          // Arahkan ke halaman Sign Up
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
