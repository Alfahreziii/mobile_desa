import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concept/core/services/shared_prefs_service.dart';
import 'package:concept/core/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';

  void _loadUserData() async {
    // Ambil data terbaru dari API
    final updatedUser = await UserService.getCurrentUser();

    if (updatedUser != null) {
      // Simpan ke SharedPreferences
      await SharedPrefsService.saveUser(updatedUser);

      setState(() {
        userName = updatedUser.name;
        userEmail = updatedUser.email;
      });
    } else {
      // fallback: pakai data lama dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('userName');
      String? email = prefs.getString('userEmail');

      setState(() {
        userName = username ?? 'No Name';
        userEmail = email ?? 'No Email';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _logout(BuildContext context) async {
    await SharedPrefsService.clearUser(); // ✅ Tambahkan ini

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Atau bisa langsung prefs.clear();

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6EAA24), // Warna latar biru
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF6EAA24),
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
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Color(0xFF2E294A),
                    ),
                    title: const Text(
                      'Personal Information',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                    onTap: () async {
                      final user = await SharedPrefsService.getUser();

                      final result = await Navigator.pushNamed(
                        context,
                        '/editprofile',
                        arguments: {'currentUser': user},
                      );

                      if (result == true) {
                        _loadUserData(); // muat ulang saat kembali
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.lock,
                      color: Color(0xFF2E294A),
                    ),
                    title: const Text(
                      'Password & Email',
                      style: TextStyle(
                        color: Color(0xFF2E294A),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2E294A),
                    ),
                    onTap: () async {
                      final user = await SharedPrefsService.getUser();
                      Navigator.pushNamed(
                        context,
                        '/emailpassword',
                        arguments: {
                          'currentUser':
                              user, // Lempar data user yang sedang login
                        },
                      );
                    },
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
