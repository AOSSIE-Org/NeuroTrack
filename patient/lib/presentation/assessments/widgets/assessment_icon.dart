import 'package:flutter/material.dart';

class AssessmentIcon extends StatelessWidget {
  final String icon;

  const AssessmentIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the icon is a network URL or an asset path
    if (icon.startsWith('http')) {
      return Image.network(
        icon,
        width: 80,
        height: 80,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error_outline, size: 80);
        },
      );
    } else {
      return Image.asset(
        icon,
        width: 80,
        height: 80,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error_outline, size: 80);
        },
      );
    }
  }
}
