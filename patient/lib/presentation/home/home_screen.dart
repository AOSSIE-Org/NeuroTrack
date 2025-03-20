// home_screen.dart
import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/presentation/home/widgets/home_screen_slider.dart';
import 'package:patient/presentation/home/widgets/therapy_goal_card.dart';
import 'package:patient/presentation/reports/report_screen.dart'; // Import the new widget

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({
    super.key,
    required this.userName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildHomeContent(),
      const ReportsScreen(),
      _buildCalendarContent(),
      _buildNotificationsContent(),
      _buildProfileContent(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _screens[_selectedIndex]),
            Container(
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
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem('assets/home.png', 0),
                  _buildNavItem('assets/report.png', 1),
                  _buildNavItem('assets/calendar.png', 2),
                  _buildNavItem('assets/notifications.png', 3),
                  _buildNavItem('assets/profile.png', 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String assetPath, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ImageIcon(
          AssetImage(assetPath),
          color:
              _selectedIndex == index ? AppTheme.secondaryColor : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back',
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 2, 2, 2)),
          ),
          Text(
            widget.userName,
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 2, 2),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView(
              children: const [
                LevelIndicator(currentLevel: 5, maxLevel: 18),
                SizedBox(height: 15),
                // Using the reusable TherapyGoalCard three times
                TherapyGoalCard(
                  title: 'Therapy',
                  subtitle: 'Goals',
                  imagePath: 'assets/illustration1.png',
                  backgroundColor: Color(0xFFF9F3E3),
                ),
                SizedBox(height: 15),
                TherapyGoalCard(
                  title: 'Daily',
                  subtitle: 'Activities',
                  imagePath: 'assets/illustration.png',
                  backgroundColor: Color(0xFFFEF4F0),
                  imageOnLeft: true,
                ),
                SizedBox(height: 15),
                TherapyGoalCard(
                  title: 'Development',
                  subtitle: 'Milestones',
                  imagePath: 'assets/illustration2.png',
                  backgroundColor: Color(0xFFF5FAF4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Other screen dummy content

  Widget _buildCalendarContent() {
    return const Center(
        child: Text('Calendar Screen', style: TextStyle(fontSize: 24)));
  }

  Widget _buildNotificationsContent() {
    return const Center(
        child: Text('Notifications Screen', style: TextStyle(fontSize: 24)));
  }

  Widget _buildProfileContent() {
    return const Center(
        child: Text('Profile Screen', style: TextStyle(fontSize: 24)));
  }
}
