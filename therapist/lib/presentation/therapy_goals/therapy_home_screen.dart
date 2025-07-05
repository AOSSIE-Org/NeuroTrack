import 'package:flutter/material.dart';
import 'package:therapist/presentation/therapy_goals/therapy_goals_screen.dart';
import 'package:therapist/presentation/therapy_goals/widgets/therapy_goal_home_screen_option_tile.dart';

import '../daily_activities/daily_activities_screen.dart';

class TherapyHomeScreen extends StatelessWidget {
  const TherapyHomeScreen({super.key, required this.patientId, required this.name});

  final String patientId;
  final String name;

  AppBar _buildHeader(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/abdul.png',
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(width: 15),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color:Color(0xff111847),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Patient ID: ${patientId.substring(0, 6)}',
                style: const TextStyle(
                  color: Color(0xff6D6D6D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToTailoredGoals (BuildContext context, String patientId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TherapyGoalsScreen(
          patientId: patientId,
        ),
      ),
    );
  }
  void _navigateToDailyActivities (BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyActivitiesScreen()));
  }

  void _navigateToDevelopmentMilestones (BuildContext context) {
    // TODO: Implement navigation to Development Milestones screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHeader(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18,),
            TherapyGoalHomeScreenOptionTile(
              title: 'Tailored\nGoals',
              color: const Color(0xffF9F3E3),
              imagePath: 'assets/health_tracking.png',
              isLeading: false,
              onTap: () => _navigateToTailoredGoals(context, patientId),
            ),
            TherapyGoalHomeScreenOptionTile(
              title: 'Daily\nActivities',
              color: const Color(0xffFEF4F0),
              imagePath: 'assets/daily_activities.png',
              isLeading: true,
              onTap: () => _navigateToDailyActivities(context),
            ),
            TherapyGoalHomeScreenOptionTile(
              title: 'Development\nMilestones',
              color: const Color(0xffF5FAF4),
              imagePath: 'assets/development_milestones.png',
              isLeading: false,
              onTap: () => _navigateToDevelopmentMilestones(context),
            ),
          ],
        ),
      ),
    );
  }
}