import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:concept/page/home/home.dart';
import 'package:concept/page/home/cart.dart';
import 'package:concept/page/home/invoice.dart';
import 'package:concept/page/home/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title});
  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const HomeMain(key: PageStorageKey('home')),
    const CartScreen(key: PageStorageKey('cart')),
    const InvoicePage(key: PageStorageKey('favorite')),
    const ProfileScreen(key: PageStorageKey('profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: _pages,
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labels: const ["Home", "Market", "Invoice", "Profile"],
        icons: const [
          Icons.home,
          Icons.shopping_cart,
          Icons.receipt_long,
          Icons.people_alt
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFFA5A5A5),
        ),
        tabIconColor: const Color(0xFFA5A5A5),
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: const Color(0xFF6EAA24),
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }
}
