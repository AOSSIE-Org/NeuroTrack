import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class ReportsProvider with ChangeNotifier {
  // Milestone Cards Data
  final List<Map<String, dynamic>> _milestoneCards = [
    {
      'iconPath': Assets.icons.icCompleted,
      'iconColor': Color(0xff36662C),
      'backgroundColor': Color(0xFFF5FAF4),
      'value': '2,000',
      'label': 'Completed',
      'isCompletedCard': true,
    },
    {
      'iconPath': Assets.icons.icMissed,
      'iconColor': Color(0xffFFA400),
      'backgroundColor': Color(0xFFFFF5E3),
      'value': '10',
      'label': 'Missed',
      'isCompletedCard': false,
    },
    {
      'iconPath': Assets.icons.icRegressed,
      'iconColor': Color(0xffFF3939),
      'backgroundColor': Color(0xFFFFEAEA),
      'value': '500',
      'label': 'Regressed',
      'isCompletedCard': false,
    },
  ];

  // Progress Card Data
  final Map<String, dynamic> _progressCard = const {
    'value': '12/20',
    'label': 'Milestones Completed Successfully',
    'percentage': 60.0,
    'height': 138.0,
  };

  // Milestone Sections Data
  final List<Map<String, dynamic>> _milestoneSections = const [
    {
      'title': 'Completed Milestones', 'items': [
        {
          'title': 'Development Milestone 1',
          'description': 'Successfully achieved on February 15, 2025',
        },
        {
          'title': 'Behavioral Goal 2',
          'description': 'Mastered on March 10, 2025',
        },
      ],
    },
    {
      'title': 'Missed Milestones',
      'items': [
        {
          'title': 'Communication Skill 3',
          'description': 'Expected completion: April 10, 2025',
        },
        {
          'title': 'Social Interaction Goal',
          'description': 'Target date passed: April 15, 2025',
        },
      ],
    },
    {
      'title': 'Regressed Milestones',
      'items': [
        {
          'title': 'Speech Development',
          'description': 'Showing decline since last assessment',
        },
        {
          'title': 'Motor Skills',
          'description': 'Needs immediate intervention',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get milestoneCards => _milestoneCards;
  Map<String, dynamic> get progressCard => _progressCard;
  List<Map<String, dynamic>> get milestoneSections => _milestoneSections;

  // You can add methods to update data dynamically in the future
  // For example:
  // void updateMilestoneCards(List<Map<String, dynamic>> newCards) {
  //   _milestoneCards = newCards;
  //   notifyListeners();
  // }
}
