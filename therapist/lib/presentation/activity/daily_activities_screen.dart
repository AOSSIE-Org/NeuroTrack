import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/activity_provider.dart';
import 'widgets/activity_set_card.dart';

class DailyActivitiesScreen extends StatefulWidget {
  const DailyActivitiesScreen({super.key});

  @override
  State<DailyActivitiesScreen> createState() => _DailyActivitiesScreenState();
}

class _DailyActivitiesScreenState extends State<DailyActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    // final activityProvider = Provider.of<ActivityProvider>(context);
    // final activityProvider = context.watch<ActivityProvider>();

    return Consumer<ActivityProvider>(
      builder: (context, activityProvider, child) {

    final activitySets = activityProvider.activitySets;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Daily Activities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Activity Sets
                    for (int i = 0; i < activitySets.length; i++) ...[
                      ActivitySetCard(
                        title: activitySets[i].title,
                        isExpanded: activitySets[i].isExpanded,
                        isActive: activitySets[i].isActive,
                        activities: activitySets[i].activities,
                        additionalInfo: activitySets[i].additionalInfo,
                        repeatInfo: activitySets[i].getRepeatInfo(),
                        selectedDays: activitySets[i].selectedDays,
                        onExpandToggle: () {
                          activityProvider.toggleExpanded(i);
                        },
                        onActiveToggle: (value) {
                          activityProvider.toggleActive(i, value);
                        },
                        onDaySelected: (dayIndex, value) {
                          activityProvider.updateSelectedDays(i, dayIndex, value);
                        },
                      ),
                      if (i < activitySets.length - 1) const SizedBox(height: 16),
                    ],

                    const SizedBox(height: 80), // Space for the button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: SizedBox(
          width: 200,
          child: FloatingActionButton.extended(
            onPressed: () {
              activityProvider.addActivitySet();
            },
            backgroundColor: const Color(0xFFCB6CE6),
            label: const Text(
              'Add Activity Set',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
    );
}
}