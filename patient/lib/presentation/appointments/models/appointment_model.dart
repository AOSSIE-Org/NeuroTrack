//dummy/temporary model class for appointment
// This should be replaced with the actual model class used in the app
class AppointmentModel {
  final String id;
  final String serviceType;
  final DateTime appointmentDate;
  final String timeSlot;
  final bool isCompleted;

  AppointmentModel({
    required this.id,
    required this.serviceType,
    required this.appointmentDate,
    required this.timeSlot,
    this.isCompleted = false,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      serviceType: json['serviceType'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      timeSlot: json['timeSlot'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceType': serviceType,
      'appointmentDate': appointmentDate.toIso8601String(),
      'timeSlot': timeSlot,
      'isCompleted': isCompleted,
    };
  }
}
