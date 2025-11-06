import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment.dart'; // تأكد أن لديك ملف Appointment
import 'Users.dart';

class Patient extends User {
  // اسم المجموعة في Firestore
  final String _collectionName = 'appointments';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Patient({
    required super.userId,
    required super.firstName,
    required super.secondName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
  }) : super(role: 'patient');

  // إضافة موعد
  Future<void> addAppointment(
    String doctorName,
    DateTime dateTime,
    String notes,
  ) async {
    await _firestore.collection(_collectionName).add({
      'patientId': userId,
      'doctorName': doctorName,
      'dateTime': dateTime,
      'notes': notes,
    });
  }

  // تعديل موعد
  Future<void> updateAppointment(
    String id, {
    required String doctorName,
    required DateTime dateTime,
    required String notes,
  }) async {
    await _firestore.collection(_collectionName).doc(id).update({
      'doctorName': doctorName,
      'dateTime': dateTime,
      'notes': notes,
    });
  }

  // حذف موعد
  Future<void> deleteAppointment(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }

  // استعراض المواعيد
  Stream<List<Appointment>> getAppointments() {
    return _firestore
        .collection(_collectionName)
        .where('patientId', isEqualTo: userId)
        .orderBy('dateTime')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Appointment.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
