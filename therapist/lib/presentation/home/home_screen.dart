import 'package:flutter/material.dart';
import '../widget/stats_card.dart';
import '../widget/patient_card.dart';
import '../sessions/sessions_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const SessionsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:
                ImageIcon(AssetImage('assets/Calendar.png')),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/Profile.png')),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Therapist',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatsCard(
                  imagePath: 'assets/icon1.png',
                  backgroundColor: Color(0xFFFEE8E8),
                  label: 'Patients',
                  value: '02',
                ),
                StatsCard(
                  imagePath: 'assets/icon2.png',
                  backgroundColor: Color(0xFFF1E8FE),
                  label: 'Sessions',
                  value: '20',
                ),
                StatsCard(
                  imagePath: 'assets/icon3.png',
                  backgroundColor: Color(0xFFE8FEF0),
                  label: 'Therapies',
                  value: '13',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PatientCard(
            name: 'Abdul Aziz',
            id: '#234312',
            phone: '+91 9845567890',
            email: 'abdul@mail.com',
            package: 'Basic',
            duration: '60 Days',
            imagePath: 'assets/abdul.png',
          ),
          const SizedBox(height: 16),
          PatientCard(
            name: 'Rohit Kumar',
            id: '#87213',
            phone: '+91 9834564392',
            email: 'rohit@mail.com',
            package: 'Basic',
            duration: '30 Days',
            imagePath: 'assets/rohit.png',
          ),
        ],
      ),
    );
  }
}
