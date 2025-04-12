import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';

class ServiceSelectionCard extends StatelessWidget {
  final String serviceType;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceSelectionCard({
    super.key,
    required this.serviceType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.secondaryColor : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                serviceType,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.secondaryColor
                        : Colors.grey.shade400,
                    width: 1.5,
                  ),
                  color: Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.circle,
                        size: 16,
                        color: AppTheme.secondaryColor,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
