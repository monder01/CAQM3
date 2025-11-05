import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String doctorName;
  final DateTime dateTime;
  final String notes;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.dateTime,
    required this.notes,
  });

  // إنشاء من بيانات Firestore
  factory Appointment.fromMap(String id, Map<String, dynamic> data) {
    return Appointment(
      id: id,
      doctorName: data['doctorName'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      notes: data['notes'] ?? '',
    );
  }

  // تحويل إلى Map لحفظه في Firestore
  Map<String, dynamic> toMap(String patientId) {
    return {
      'patientId': patientId,
      'doctorName': doctorName,
      'dateTime': dateTime,
      'notes': notes,
    };
  }
}
