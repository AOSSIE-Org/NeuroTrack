import 'package:dart_mappable/dart_mappable.dart';
import 'package:patient/core/core.dart';

part 'patient_schedule_appointment_entity.mapper.dart';

// Entity class to store patient's scheduled appointment information to Supabase [SESSION] table

// This class can have toModel and fromModel methods to convert to and from model

@MappableClass()
class PatientScheduleAppointmentEntity with PatientScheduleAppointmentEntityMappable {

  @MappableField(key: 'timestamp')
  final DateTime timestamp;

  @MappableField(key: 'patient_id')
  final String patientId;

  @MappableField(key: 'therapist_id')
  final String therapistId;

  @MappableField(key: 'mode')
  final int mode;

  @MappableField(key: 'duration')
  final int duration;

  @MappableField(key: 'name')
  final String appointmentName;

  @MappableField(key: 'service_type')
  final String serviceType;

  PatientScheduleAppointmentEntity({
    required this.timestamp,
    required this.patientId,
    required this.therapistId,
    required this.mode,
    required this.duration,
    required this.appointmentName,
    required this.serviceType,
  });

  ConsultationRequestEntity toConsultationRequestEntity() {
    return ConsultationRequestEntity(
      timestamp: timestamp.toIso8601String(),
      patientId: patientId,
      therapistId: therapistId,
      mode: mode,
      duration: duration,
      isConsultation: false,
      status: 'pending',
      name: appointmentName,
    );
  }

}