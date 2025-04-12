import 'package:flutter/material.dart';
import 'package:patient/presentation/appointments/models/appointment_model.dart';

class AppointmentsProvider extends ChangeNotifier {
  static const List<String> _serviceTypes = [
    'Consultation',
    'Therapy Session',
    'Assessment Evaluation',
  ];

  final List<AppointmentModel> _appointments = [];
  final List<Map<String, dynamic>> _timeSlots = [];

  String _selectedService = 'Consultation';
  DateTime? _selectedDate;
  String _selectedTimeSlot = '';

  // Getters
  List<String> get serviceTypes => _serviceTypes;
  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
  String get selectedService => _selectedService;
  DateTime? get selectedDate => _selectedDate;
  String get selectedTimeSlot => _selectedTimeSlot;
  bool get hasAppointments => _appointments.isNotEmpty;
  List<Map<String, dynamic>> get timeSlots => List.unmodifiable(_timeSlots);

  // Setters
  void setSelectedService(String service) {
    if (_selectedService != service) {
      _selectedService = service;
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }

  void setSelectedTimeSlot(String timeSlot) {
    if (_selectedTimeSlot != timeSlot) {
      _selectedTimeSlot = timeSlot;
      notifyListeners();
    }
  }

  /// Generates available time slots between 9:00 AM - 5:00 PM with 30-minute intervals.
  void generateTimeSlots(List<String> availableSlots, BuildContext context) {
    _timeSlots.clear();
    const startTime = TimeOfDay(hour: 9, minute: 0);
    const endTime = TimeOfDay(hour: 17, minute: 0);

    for (int hour = startTime.hour; hour <= endTime.hour; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        if (hour == endTime.hour && minute > 0) continue;

        final time = TimeOfDay(hour: hour, minute: minute);
        final formattedTime = _formatTimeOfDay(time, context);

        _timeSlots.add({
          'time': formattedTime,
          'available': availableSlots.contains(formattedTime),
        });
      }
    }
    notifyListeners();
  }

  /// Simulates fetching available slots from the backend (Replace with Supabase in the future).
  void fetchAvailableSlots(BuildContext context) {
    final availableSlots = [
      '9:00 AM',
      '10:30 AM',
      '1:00 PM',
      '3:30 PM'
    ]; // Example slots

    generateTimeSlots(availableSlots, context);
  }

  /// Helper method to format `TimeOfDay` into readable string.
  String _formatTimeOfDay(TimeOfDay time, BuildContext context) {
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  /// Creates a new appointment and resets selection. Future: Save to Supabase.
  Future<bool> createAppointment() async {
    if (_selectedService.isEmpty ||
        _selectedDate == null ||
        _selectedTimeSlot.isEmpty) {
      return false;
    }

    final newAppointment = AppointmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      serviceType: _selectedService,
      appointmentDate: _selectedDate!,
      timeSlot: _selectedTimeSlot,
    );

    _appointments.add(newAppointment);
    clearSelections();
    notifyListeners();
    return true;
  }

  /// Deletes an appointment by ID.
  void deleteAppointment(String id) {
    _appointments.removeWhere((appointment) => appointment.id == id);
    notifyListeners();
  }

  /// Clears selected service, date, and time slot.
  void clearSelections() {
    _selectedService = 'Consultation';
    _selectedDate = null;
    _selectedTimeSlot = '';
    notifyListeners();
  }
}
