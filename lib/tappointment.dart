class Appointment {
  String? appointmentId;
  String? patientId;
  String? doctorId;
  DateTime? appointmentDate;
  String? status;
  String? appointmentTime;

  Appointment({
    this.appointmentId,
    this.patientId,
    this.doctorId,
    this.appointmentDate,
    this.status = 'pending',
    this.appointmentTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate?.toIso8601String(),
      'status': status,
      'appointmentTime': appointmentTime,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      appointmentId: map['appointmentId'],
      patientId: map['patientId'],
      doctorId: map['doctorId'],
      appointmentDate: map['appointmentDate'] != null
          ? DateTime.parse(map['appointmentDate'])
          : null,
      status: map['status'],
      appointmentTime: map['appointmentTime'],
    );
  }
}
