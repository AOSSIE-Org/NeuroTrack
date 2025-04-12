import 'package:flutter/material.dart';
import 'package:therapist/core/theme/theme.dart';

class TherapyDateTimePicker extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  const TherapyDateTimePicker({
    super.key,
    required this.label,
    this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff121417),
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              icon,
              color: AppTheme.textColor,
            ),
          ],
        ),
      ),
    );
  }
}
