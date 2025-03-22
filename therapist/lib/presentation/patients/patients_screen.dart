
import 'package:flutter/material.dart';

class PatientsScreen extends StatelessWidget {
  final String patientName;
  final String patientId;
  final String patientUrl;

  const PatientsScreen({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.patientUrl
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.brush_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(patientUrl),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "#$patientId",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Cards Section
              Expanded(
                child: ListView(
                  children: [
                    _buildCard(
                      title: "Tailored\nGoals",
                      image: "assets/tailored_goals.png",
                      color: const Color(0xFFFFF8E6),
                    ),
                    _buildCard(
                      title: "Daily\nActivities",
                      image: "assets/daily_activities.png",
                      color: const Color(0xFFFFF0F3),
                    ),
                    _buildCard(
                      title: "Development\nMilestones",
                      image: "assets/development_milestones.png",
                      color: const Color(0xFFF2F8F3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable card widget
  Widget _buildCard({required String title, required String image, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Image.asset(image, width: 80),
        ],
      ),
    );
  }
}
