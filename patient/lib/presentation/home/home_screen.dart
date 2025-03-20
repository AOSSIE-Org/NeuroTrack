import 'package:flutter/material.dart';
import 'package:patient/presentation/reports/reports_screen.dart';
import 'package:patient/presentation/calendar/calendar_screen.dart';
import 'package:patient/presentation/notifications/updates_screen.dart';
import 'package:patient/presentation/profile/profile_screen.dart';
import './home_content.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track selected tab

  late List<Widget> _screens; // Declare _screens as late

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(userName: widget.userName), // Home content UI
      ReportsScreen(),
      CalendarScreen(),
      UpdatesScreen(),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Switch screen dynamically
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
), // Display selected screen
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    List<String> icons = [
      'assets/home.png',
      'assets/Report.png',
      'assets/Calendar.png',
      'assets/Notifications.png',
      'assets/Profile.png'
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          icons.length,
          (index) => _buildNavItem(icons[index], index),
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: ImageIcon(
          AssetImage(assetPath),
          color: isSelected ? const Color(0xFFCB6CE6) : Colors.grey,
        ),
      ),
    );
  }
}
