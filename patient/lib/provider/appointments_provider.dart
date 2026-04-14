import 'package:flutter/material.dart';
import 'package:patient/core/core.dart';
import 'package:patient/core/repository/auth/auth.dart';
import 'package:patient/model/patient_models/patient_models.dart';
import 'package:patient/presentation/appointments/models/appointment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentsProvider extends ChangeNotifier {

  AppointmentsProvider({
    required AuthRepository authRepository,
    required PatientRepository patientRepository,
  }) : _authRepository = authRepository, _patientRepository = patientRepository;

  final AuthRepository _authRepository;
  final PatientRepository _patientRepository;

  static const List<String> _serviceTypes = [
    'Consultation',
    'Therapy Session',
    'Assessment Evaluation',
  ];

  final List<AppointmentModel> _appointments = [];
  List<String> _availableTimeSlots = [];
  bool _isFetchingSlots = false;
  int _fetchToken = 0; 

  String _selectedService = 'Consultation';
  DateTime? _selectedDate;
  String _selectedTimeSlot = '';
  String _therapistId = '';
  bool _isSubmitting = false;
  String? _bookingError;

  // Getters
  List<String> get serviceTypes => _serviceTypes;
  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);
  String get selectedService => _selectedService;
  DateTime? get selectedDate => _selectedDate;
  String get selectedTimeSlot => _selectedTimeSlot;
  bool get hasAppointments => _appointments.isNotEmpty;
  List<String> get availableTimeSlots => _availableTimeSlots;
  bool get isFetchingSlots => _isFetchingSlots;
  bool get isSubmitting => _isSubmitting;
  String? get bookingError => _bookingError;
  String get therapistId => _therapistId;
 // List<Map<String, dynamic>> get timeSlots => List.unmodifiable(_timeSlots);


  // Setters

  set availableTimeSlots(List<String> timeSlots) {
    _availableTimeSlots = timeSlots;
  }

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
    _availableBookingSlots(date);
  }

  void setSelectedTimeSlot(String timeSlot) {
    if (_selectedTimeSlot != timeSlot) {
      _selectedTimeSlot = timeSlot;
      notifyListeners();
    }
  }

  void _availableBookingSlots(DateTime date) async {
    final token = ++_fetchToken;
    _isFetchingSlots = true;
    _availableTimeSlots = [];
    notifyListeners();
    try {
      final supabase = Supabase.instance.client;
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        availableTimeSlots = [];
        return;
      }
      final userId = currentUser.id;

      final patientRow = await supabase
          .from('patient')
          .select('therapist_id')
          .eq('id', userId)
          .maybeSingle();

      if (token != _fetchToken) return;

      var therapistId = patientRow?['therapist_id'] as String?;

      if (therapistId == null || therapistId.isEmpty) {
        final sessionRow = await supabase
            .from('session')
            .select('therapist_id')
            .eq('patient_id', userId)
            .eq('status', 'accepted')
            .order('timestamp', ascending: false)
            .limit(1)
            .maybeSingle();

        if (token != _fetchToken) return;
        therapistId = sessionRow?['therapist_id'] as String?;
      }

      if (therapistId == null || therapistId.isEmpty) {
        availableTimeSlots = [];
        return;
      }

      final therapistRow = await supabase
          .from('therapist')
          .select('start_availability_time, end_availability_time')
          .eq('id', therapistId)
          .maybeSingle();

      if (token != _fetchToken) return;

      final startTime = therapistRow?['start_availability_time'] as String? ?? '9:00';
      final endTime = therapistRow?['end_availability_time'] as String? ?? '18:00';

      final result = await _authRepository.getAvailableBookingSlotsForTherapist(
        therapistId, date, startTime, endTime);
      _therapistId = therapistId ?? '';
      notifyListeners();

      if (token != _fetchToken) return;

      if(result is ActionResultSuccess) {
        availableTimeSlots = result.data as List<String>;
      } else {
        availableTimeSlots = [];
      }
    } catch(e) {
      print(e);
      if (token == _fetchToken) {
        availableTimeSlots = [];
      }
    } finally {
      if (token == _fetchToken) {
        _isFetchingSlots = false;
        notifyListeners();
      }
    }
  }

  /// Helper method to format `TimeOfDay` into readable string.
  String _formatTimeOfDay(TimeOfDay time, BuildContext context) {
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  // Fetch all appointments from the patient repository
  Future<void> fetchAllAppointments() async {
    try {
      final result = await _patientRepository.fetchAllAppointments();
      if(result is ActionResultSuccess) {
        _appointments.clear();
        _appointments.addAll(result.data as List<AppointmentModel>);
      }
      if(result is ActionResultFailure) {
        if(result.statusCode == 404) {
          _appointments.clear();
        }
      }
    } catch(e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  /// Creates a new appointment and resets selection. Future: Save to Supabase.
  Future<bool> createAppointment() async {
    if (_isSubmitting) return false;

    _bookingError = null;

    if (_selectedDate == null) {
      _bookingError = 'Please select a date before booking.';
      notifyListeners();
      return false;
    }

    if (_selectedTimeSlot.isEmpty) {
      _bookingError = 'Please select a time slot before booking.';
      notifyListeners();
      return false;
    }

    if (_therapistId.isEmpty) {
      _bookingError = 'No therapist assigned. Please contact support.';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final slotDateTime = _parseSlotToDateTime(_selectedTimeSlot, _selectedDate!);

      if (slotDateTime == null) {
        _bookingError = 'Selected time slot is invalid. Please choose another slot.';
        return false;
      }

      final appointmentModel = PatientScheduleAppointmentModel(
        patientId: Supabase.instance.client.auth.currentUser!.id,
        therapistId: _therapistId,
        serviceType: _selectedService,
        date: slotDateTime.toIso8601String(),
        slot: _selectedTimeSlot,
        appointmentName: 'Appointment with the Therapist',
      );

      final result = await _authRepository.bookConsultation(
        appointmentModel.toEntity().toConsultationRequestEntity(),
      );

      if (result is ActionResultSuccess) {
        _bookingError = null;
        return true;
      } else {
        _bookingError = 'Booking failed. Please try again.';
        return false;
      }
    } catch (e) {
      _bookingError = 'An unexpected error occurred. Please try again.';
      print(e);
      return false;
    } finally {
      _isSubmitting = false;
      fetchAllAppointments();
      notifyListeners();
    }
  }

  /// Deletes an appointment by ID.
  Future<bool> deleteAppointment(String id) async {
    try {
      final result = await _patientRepository.deleteAppointment(id);
      if(result is ActionResultSuccess) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
      return false;
    } finally {
      fetchAllAppointments();
      notifyListeners();
    }
  }

  /// Clears selected service, date, and time slot.
  void clearSelections() {
    _selectedService = 'Consultation';
    _selectedDate = null;
    _selectedTimeSlot = '';
    _therapistId = '';
    _isSubmitting = false;
    _bookingError = null;
    notifyListeners();
  }
  DateTime? _parseSlotToDateTime(String slot, DateTime date) {
    try {
      final trimmed = slot.trim();
      if (trimmed.isEmpty) return null;
      final parts = trimmed.split(' ');
      final timeParts = parts[0].split(':');
      if (timeParts.length < 2) return null;
      final parsedHour = int.tryParse(timeParts[0]);
      final parsedMinute = int.tryParse(timeParts[1]);
      if (parsedHour == null || parsedMinute == null) return null;
      if (parsedHour < 0 || parsedHour > 23) return null;
      if (parsedMinute < 0 || parsedMinute > 59) return null;
      int hour = parsedHour;
      final minute = parsedMinute;
      final isPM = parts.length > 1 && parts[1].toUpperCase() == 'PM';
      final isAM = parts.length > 1 && parts[1].toUpperCase() == 'AM';
      if (isPM && hour != 12) hour += 12;
      if (isAM && hour == 12) hour = 0;
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (_) {
      return null;
    }
  }
}
