import 'package:flutter/material.dart';

class ActivitySet {
  final String title;
  final List<String> activities;
  final String? additionalInfo;
  final List<bool> selectedDays;
  bool isExpanded;
  bool isActive;

  ActivitySet({
    required this.title,
    required this.activities,
    this.additionalInfo,
    required this.selectedDays,
    this.isExpanded = false,
    this.isActive = false,
  });

  String getRepeatInfo() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selectedDayNames = selectedDays
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => days[entry.key])
        .toList();

    if (selectedDayNames.isEmpty) {
      return 'No Active Schedule';
    } else if (selectedDayNames.length == 7) {
      return 'Repeats Every Day';
    } else {
      return 'Repeats ${selectedDayNames.join(', ')}';
    }
  }
}

class ActivityProvider extends ChangeNotifier {
  final List<ActivitySet> _activitySets = [
    ActivitySet(
      title: 'Activity Set 1',
      activities: const [
        'Brush Teeth',
        'Write legibly for a 10-minute period with minimal hand fatigue within 1 month',
        'Independently comb hair and wash face within 1 week'
      ],
      selectedDays: List.generate(7, (_) => false),
    ),
    ActivitySet(
      title: 'Activity Set 2',
      activities: const [
        'Brush Teeth',
        'Write legibly for a 10-minute period with minimal hand fatigue within 1 month',
      ],
      additionalInfo: '5 more activities',
      selectedDays: List.generate(7, (_) => false),
    ),
    ActivitySet(
      title: 'Activity Set 3',
      activities: const [
        'Brush Teeth',
        'Write legibly for a 10-minute period with minimal hand fatigue within 1 month',
      ],
      additionalInfo: '5 more activities',
      selectedDays: List.generate(7, (_) => false),
    ),
  ];

  List<ActivitySet> get activitySets => _activitySets;

  void toggleExpanded(int index) {
    _activitySets[index].isExpanded = !_activitySets[index].isExpanded;
    notifyListeners();
  }

  void toggleActive(int index, bool value) {
    _activitySets[index].isActive = value;
    _activitySets[index].isExpanded = value;
    notifyListeners();
  }

  void updateSelectedDays(int activitySetIndex, int dayIndex, bool value) {
    _activitySets[activitySetIndex].selectedDays[dayIndex] = value;
    notifyListeners();
  }

  void addActivitySet() {
    // Implementation for adding a new activity set
    notifyListeners();
  }
}