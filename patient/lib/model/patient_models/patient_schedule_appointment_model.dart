import 'package:dart_mappable/dart_mappable.dart';

part 'patient_schedule_appointment_model.mapper.dart';

// Model class to store patient's scheduled appointment information which will be used on UI
// This class can have toEntity and fromEntity methods to convert to and from entity

@MappableClass()
class PatientScheduleAppointmentModel
    with PatientScheduleAppointmentModelMappable {
  final String patientId;
  final String therapistId;
  final String serviceType;
  final String date;
  final String slot;
  final String appointmentName;

  PatientScheduleAppointmentModel({
    required this.patientId,
    required this.therapistId,
    required this.serviceType,
    required this.date,
    required this.slot,
    required this.appointmentName,
  });
}
