import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartofficial/core/services/shared_prefs_service.dart';
import 'package:smartofficial/core/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';

  void _loadUserData() async {
    final updatedUser = await UserService.getCurrentUser();

    if (!mounted) return;

    if (updatedUser != null) {
      await SharedPrefsService.saveUser(updatedUser);
      setState(() {
        userName = updatedUser.name;
        userEmail = updatedUser.email;
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        userName = prefs.getString('userName') ?? 'No Name';
        userEmail = prefs.getString('userEmail') ?? 'No Email';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _logout() async {
    await SharedPrefsService.clearUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
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

  Future<void> _launchMarketPlace() async {
    final clientUrl = dotenv.env['CLIENT_URL'] ?? 'http://localhost:5173';
    final Uri url = Uri.parse('$clientUrl/toko-personal');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      _showErrorDialog("Tidak dapat membuka halaman reset password.");
    }
  }

  Future<void> _navigateToEditProfile() async {
    final user = await SharedPrefsService.getUser();
    if (!mounted) return;

    final result = await Navigator.pushNamed(
      context,
      '/editprofile',
      arguments: {'currentUser': user},
    );

    if (result == true) {
      _loadUserData();
    }
  }

  Future<void> _navigateToEmailPassword() async {
    final user = await SharedPrefsService.getUser();
    if (!mounted) return;

    Navigator.pushNamed(
      context,
      '/emailpassword',
      arguments: {'currentUser': user},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6EAA24),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF6EAA24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
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
                      'assets/image/default_profile.png',
                      width: 80,
                      height: 80,
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
                    leading: const Icon(Icons.person, color: Color(0xFF2E294A)),
                    title: const Text(
                      'Personal Information',
                      style: TextStyle(color: Color(0xFF2E294A)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Color(0xFF2E294A)),
                    onTap: _navigateToEditProfile,
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock, color: Color(0xFF2E294A)),
                    title: const Text(
                      'Password & Email',
                      style: TextStyle(color: Color(0xFF2E294A)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Color(0xFF2E294A)),
                    onTap: _navigateToEmailPassword,
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart,
                        color: Color(0xFF2E294A)),
                    title: const Text(
                      'Market Place',
                      style: TextStyle(color: Color(0xFF2E294A)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Color(0xFF2E294A)),
                    onTap: _launchMarketPlace,
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
                    leading: const Icon(Icons.logout, color: Color(0xFF2E294A)),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Color(0xFF2E294A)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Color(0xFF2E294A)),
                    onTap: _logout,
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
