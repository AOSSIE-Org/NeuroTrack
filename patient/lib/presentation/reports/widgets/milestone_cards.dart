import 'package:flutter/material.dart';
import 'package:patient/gen/assets.gen.dart';
import 'package:patient/provider/reports_provider.dart';

// Vertical layout card (for Completed)
class CompletedMilestoneCard extends StatelessWidget {
  final MilestoneCardType cardType;
  final Color iconColor;
  final Color backgroundColor;
  final String value;
  final String label;

  const CompletedMilestoneCard({
    required this.cardType,
    required this.iconColor,
    required this.backgroundColor,
    required this.value,
    required this.label,
    super.key,
  });


  Widget get _getIcon {
    switch (cardType) {
      case MilestoneCardType.completed:
        return Assets.icons.icCompleted.svg(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          height: 40,
          width: 40,
        );
      case MilestoneCardType.missed:
        return Assets.icons.icMissed.svg(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          height: 40,
          width: 40,
        );
      case MilestoneCardType.regressed:
        return Assets.icons.icRegressed.svg(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          height: 40,
          width: 40,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196, // Fixed height to match combined height of other cards
      width: MediaQuery.of(context).size.width * 0.4, // Fixed width
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.1),
            ),
            child: _getIcon
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// Horizontal layout card (for Missed and Regressed)
class HorizontalMilestoneCard extends StatelessWidget {
  final MilestoneCardType type;
  final Color iconColor;
  final Color backgroundColor;
  final String value;
  final String label;

  const HorizontalMilestoneCard({
    required this.type,
    required this.iconColor,
    required this.backgroundColor,
    required this.value,
    required this.label,
    super.key,
  });

  Widget get _getIcon {
    switch (type) {
      case MilestoneCardType.completed:
        return Assets.icons.icCompleted.svg(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          height: 40,
          width: 40,
        );
      case MilestoneCardType.missed:
        return Assets.icons.icMissed.svg(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          height: 40,
          width: 40,
        );
      case MilestoneCardType.regressed:
        return Assets.icons.icRegressed.svg(
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          height: 40,
          width: 40,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 90, // Fixed height
      width: MediaQuery.of(context).size.width * 0.47, // Fixed width

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.1),
            ),
            child: _getIcon,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22, // Slightly smaller for horizontal layout
                      ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
