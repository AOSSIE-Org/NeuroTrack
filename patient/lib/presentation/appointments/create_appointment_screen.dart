import 'package:flutter/material.dart';
import 'package:patient/core/theme/theme.dart';
import 'package:patient/presentation/appointments/widgets/datetime_picker_fields.dart';
import 'package:patient/presentation/appointments/widgets/service_selection_card.dart';
import 'package:patient/presentation/appointments/widgets/timeslot_bottom_sheet.dart';
import 'package:patient/provider/appointments_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule an Appointment'),
      ),
      body: Consumer<AppointmentsProvider>(
        builder: (context, appointmentProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select a Service',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 16),

                // Service selection cards
                ...appointmentProvider.serviceTypes.map(
                  (service) => ServiceSelectionCard(
                    serviceType: service,
                    isSelected: appointmentProvider.selectedService == service,
                    onTap: () {
                      appointmentProvider.setSelectedService(service);
                    },
                  ),
                )..toList(),

                const SizedBox(height: 32),

                const Text(
                  'At what time should we schedule it?',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Date picker
                DateTimePickerField(
                  label: 'Select a Date',
                  value: appointmentProvider.selectedDate != null
                      ? DateFormat('MMMM d, yyyy')
                          .format(appointmentProvider.selectedDate!)
                      : null,
                  icon: Icons.calendar_month_outlined,
                  onTap: () => _selectDate(context),
                ),

                // Time picker
                DateTimePickerField(
                  label: 'Select Time Slot',
                  value: appointmentProvider.selectedTimeSlot.isNotEmpty
                      ? appointmentProvider.selectedTimeSlot
                      : null,
                  icon: Icons.access_time,
                  onTap: () => selectTimeSlot(context),
                ),

                const Spacer(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: appointmentProvider
                                    .selectedService.isNotEmpty &&
                                appointmentProvider.selectedDate != null &&
                                appointmentProvider.selectedTimeSlot.isNotEmpty
                            ? () async {
                                final success = await appointmentProvider
                                    .createAppointment();
                                if (success && context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                          'Appointment scheduled successfully!'),
                                      backgroundColor: AppTheme.secondaryColor,
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          disabledBackgroundColor: AppTheme.secondaryColor
                              .withOpacity(0.7), // Set disabled color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Schedule It',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final appointmentProvider =
        Provider.of<AppointmentsProvider>(context, listen: false);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      appointmentProvider.setSelectedDate(picked);
    }
  }

  Future<void> selectTimeSlot(BuildContext context) async {
    final appointmentProvider =
        Provider.of<AppointmentsProvider>(context, listen: false);

    // Fetch available slots with context
    appointmentProvider.fetchAvailableSlots(context);

    // Show modal bottom sheet with slots
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TimeSlotBottomSheet(
          onTimeSelected: (timeSlot) {
            appointmentProvider.setSelectedTimeSlot(timeSlot);
          },
        );
      },
    );
  }
}
