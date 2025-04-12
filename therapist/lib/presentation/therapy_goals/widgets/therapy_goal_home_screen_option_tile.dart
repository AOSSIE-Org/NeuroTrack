import 'package:flutter/material.dart';

class TherapyGoalHomeScreenOptionTile extends StatelessWidget {
  const TherapyGoalHomeScreenOptionTile({
    super.key,
    required this.title,
    required this.color,
    required this.imagePath,
    required this.isLeading,
    required this.onTap,
  });

  final String title;
  final Color color;
  final String imagePath;
  final bool isLeading;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 158,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          spacing: 40,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLeading) ...[
              Image.asset(
                imagePath,
                width: 80,
                height: 128,
              ),
            ],
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!isLeading) ...[
              Image.asset(
                imagePath,
                width: 80,
                height: 128,
              ),
            ],
          ],
        ),
      ),
    );
  }
}