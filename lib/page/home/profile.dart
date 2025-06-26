import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('userName');
    String? email = prefs.getString('userEmail');

    setState(() {
      userName = username ?? 'No Name';
      userEmail = email ?? 'No Email';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Hapus data login dari SharedPreferences
    await prefs.clear();
    // Navigasikan ke halaman login setelah logout
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E5993), // Warna latar biru
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF1E5993),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30), // Margin atas
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Image.asset(
                      'assets/image/default_profile.png', // Your logo path
                      width: 80,
                      height: 80, // Set appropriate size
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  const ListTile(
                    title: Text(
                      'Account Settings',
                      style: TextStyle(
                        color: Color(0xFF6D697A),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Color(0xFF2E294A),
                    ),
                    title: Text(
                      'Personal Information,',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.lock,
                      color: Color(0xFF2E294A),
                    ),
                    title: Text(
                      'Password & Security',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.payment,
                      color: Color(0xFF2E294A),
                    ),
                    title: Text(
                      'Payment Method',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                  ),
                  const ListTile(
                    title: Text(
                      'Other',
                      style: TextStyle(
                        color: Color(0xFF6D697A),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.help,
                      color: Color(0xFF2E294A),
                    ),
                    title: Text(
                      'Help Center',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Color(0xFF2E294A),
                    ),
                    title: Text(
                      'Rate Us',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Color(0xFF2E294A),
                    ),
                    title: const Text(
                      'Add Product',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/addproduct'); // Panggil fungsi logout
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.edit,
                      color: Color(0xFF2E294A),
                    ),
                    title: const Text(
                      'Edit Product',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/updateproduct'); // Panggil fungsi logout
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Color(0xFF2E294A),
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                    onTap: () {
                      _logout(context); // Panggil fungsi logout
                    },
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
