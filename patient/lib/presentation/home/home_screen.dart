import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/presentation/activities/daily_activities_screen.dart';
import 'package:patient/presentation/appointments/appointment_list_screen.dart';
import 'package:patient/presentation/chatbot/chatbot_screen.dart';
import 'package:patient/presentation/home/widgets/home_screen_slider.dart';
import 'package:patient/presentation/home/widgets/therapy_goal_card.dart';
import 'package:patient/presentation/operations/therapy_goals.dart';
import 'package:patient/presentation/reports/report_screen.dart'; // Import the new widget
import 'package:patient/presentation/notification/updates_screen.dart';

import '../../gen/assets.gen.dart';

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
      const AppointmentListScreen(),
      UpdatesScreen(),
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

            // Bottom Navigation Bar
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
                  _buildNavItem(Assets.icons.icHome, 0),
                  _buildNavItem(Assets.icons.icReport, 1),
                  _buildNavItem(Assets.icons.icCalendar, 2),
                  _buildNavItem(Assets.icons.icNotifications, 3),
                  _buildNavItem(Assets.icons.icProfile, 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(SvgGenImage genIcon, int index) {
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
          child: genIcon.svg(
            color:
                _selectedIndex == index ? AppTheme.secondaryColor : Colors.grey,
          )),
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatbotScreen()),
              );
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Assets.icons.icChatbot.svg(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const LevelIndicator(currentLevel: 5, maxLevel: 18),
                const SizedBox(height: 15),
                // Using the reusable TherapyGoalCard three times
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TherapyGoalsScreen()),
                    );
                  },
                  child: TherapyGoalCard(
                    title: 'Therapy',
                    subtitle: 'Goals',
                    illustration: Assets.illustrations.i9nGoals,
                    backgroundColor: Color(0xFFF9F3E3),
                  ),
                ),
                const SizedBox(height: 15),
                // Daily Activities Card

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DailyActivitiesScreen()),
                    );
                  },
                  child: TherapyGoalCard(
                    title: 'Daily',
                    subtitle: 'Activities',
                    illustration: Assets.illustrations.i9nActivities,
                    backgroundColor: Color(0xFFFEF4F0),
                    imageOnLeft: true,
                  ),
                ),

                const SizedBox(height: 15),
                // Development Milestones Card
                TherapyGoalCard(
                  title: 'Development',
                  subtitle: 'Milestones',
                  illustration: Assets.illustrations.i9nMilestones,
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

  Widget _buildProfileContent() {
    return const Center(
        child: Text('Profile Screen', style: TextStyle(fontSize: 24)));
  }
}
