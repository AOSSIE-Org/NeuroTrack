import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/presentation/reports/widgets/expandable_section.dart';
import 'package:patient/presentation/reports/widgets/progress_summary.dart';
import 'package:patient/presentation/reports/widgets/milestone_cards.dart';
import 'package:patient/presentation/reports/widgets/milestone_list_item.dart';
import 'package:patient/provider/reports_provider.dart';
import 'package:provider/provider.dart';

import '../../gen/assets.gen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Access the provider
    final reportsProvider = Provider.of<ReportsProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reports',
                          style: theme.textTheme.displayMedium,
                        ),
                        Assets.icons.icCalendar.svg()
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Milestones Progress Section
                    Row(
                      children: [
                        Text(
                          'Milestones Progress',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(Jun 1 - Jun 30)',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Milestone Cards - Using provider data
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left column - Completed card
                        CompletedMilestoneCard(
                          iconPath: reportsProvider.milestoneCards[0]
                              ['iconPath'],
                          iconColor: reportsProvider.milestoneCards[0]
                              ['iconColor'],
                          backgroundColor: reportsProvider.milestoneCards[0]
                              ['backgroundColor'],
                          value: reportsProvider.milestoneCards[0]['value'],
                          label: reportsProvider.milestoneCards[0]['label'],
                        ),
                        // Right column - Missed and Regressed cards stacked
                        Column(
                          children: [
                            HorizontalMilestoneCard(
                              iconPath: reportsProvider.milestoneCards[1]
                                  ['iconPath'],
                              iconColor: reportsProvider.milestoneCards[1]
                                  ['iconColor'],
                              backgroundColor: reportsProvider.milestoneCards[1]
                                  ['backgroundColor'],
                              value: reportsProvider.milestoneCards[1]['value'],
                              label: reportsProvider.milestoneCards[1]['label'],
                            ),
                            const SizedBox(height: 12),
                            HorizontalMilestoneCard(
                              iconPath: reportsProvider.milestoneCards[2]
                                  ['iconPath'],
                              iconColor: reportsProvider.milestoneCards[2]
                                  ['iconColor'],
                              backgroundColor: reportsProvider.milestoneCards[2]
                                  ['backgroundColor'],
                              value: reportsProvider.milestoneCards[2]['value'],
                              label: reportsProvider.milestoneCards[2]['label'],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Progress Card - Using provider data
                    MilestoneProgressCard(
                      value: reportsProvider.progressCard['value'],
                      label: reportsProvider.progressCard['label'],
                      percentage:
                          (reportsProvider.progressCard['percentage'] as double)
                              .toInt(),
                      height: reportsProvider.progressCard['height'],
                    ),
                    const SizedBox(height: 24),

                    // Milestones in Details Section
                    Text(
                      'Milestones in Details',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dynamic Expandable Sections using provider data
                    ...reportsProvider.milestoneSections.map((section) {
                      final items =
                          (section['items'] as List<Map<String, String>>)
                              .map((item) => MilestoneListItem(
                                    title: item['title']!,
                                    description: item['description']!,
                                  ))
                              .toList();
                      return ExpandableSection(
                        title: section['title'],
                        children: items,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
