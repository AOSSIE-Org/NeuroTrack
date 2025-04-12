import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:therapist/presentation/therapy_goals/add_therapy_details_screen.dart';
import 'package:therapist/presentation/therapy_goals/widgets/therapy_container.dart';

class TherapyDottedEmptyContainer extends StatelessWidget {
  const TherapyDottedEmptyContainer(
      {super.key, required this.therapyDetailsType});

  final TherapyDetailsType therapyDetailsType;

  void _addFromExistingTherapyDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTherapyDetailsScreen(therapyDetailsType : therapyDetailsType),
      ),
    );
  }

  String get _getTherapyDetailsText {
    switch (therapyDetailsType) {
      case TherapyDetailsType.goals:
        return 'Add Therapy Goals';
      case TherapyDetailsType.observation:
        return 'Add Therapy Observation';
      case TherapyDetailsType.regression:
        return 'Add Regression';
      case TherapyDetailsType.activities:
        return 'Add Activities';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _addFromExistingTherapyDetails(context),
      child: DottedBorder(
        color: const Color(0xffC5C3C3),
        radius: const Radius.circular(16),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 60,
          child: Text(
            _getTherapyDetailsText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff121417),
            ),
          ),
        ),
      ),
    );
  }
}
