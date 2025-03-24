import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/provider/appointments_provider.dart';
import 'package:provider/provider.dart';

class TimeSlotBottomSheet extends StatelessWidget {
  final List<String> timeSlots;
  final String? selectedTimeSlot;
  final Function(String) onTimeSelected;

  const TimeSlotBottomSheet({
    super.key,
    required this.timeSlots,
    this.selectedTimeSlot,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Consumer<AppointmentsProvider>(
      builder: (context, appointmentsProvider, child) {
        return Container(
          height: size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Row(
                  children: [
                    Text(
                      'Select Time',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context), // Pop on cancel
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(color: Colors.grey, height: 1, thickness: 0.5),
              ),

              // Time slots grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final timeSlot = timeSlots[index];
                    final isSelected =
                        appointmentsProvider.selectedTimeSlot == timeSlot;

                    return GestureDetector(
                      onTap: () {
                        // Update the selected time slot in the appointmentsProvider
                        appointmentsProvider.setSelectedTimeSlot(timeSlot);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.secondaryColor.withOpacity(0.1)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.secondaryColor
                                : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            timeSlot,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.secondaryColor
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Confirm button
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  left: 24,
                  right: 24,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (appointmentsProvider.selectedTimeSlot.isNotEmpty) {
                        onTimeSelected(appointmentsProvider.selectedTimeSlot);
                        Navigator.pop(context); // Pop on confirm
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
