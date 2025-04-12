// therapy_goal_card.dart
import 'package:flutter/material.dart';
import 'package:patient/gen/assets.gen.dart';
class TherapyGoalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final SvgGenImage illustration;
  final Color backgroundColor;
  final bool imageOnLeft;

  const TherapyGoalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.illustration,
    required this.backgroundColor,
    this.imageOnLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Prevents Row from taking full width
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageOnLeft) ...[
              _buildImage(),
              const SizedBox(width: 30),
            ],
            Flexible(
              child: _buildText(context),
            ),
            if (!imageOnLeft) ...[
              const SizedBox(width: 30),
              _buildImage(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildImage() {
    return illustration.svg(
      height: 100,
      width: 80,
      fit: BoxFit.contain,
    );
  }
}
