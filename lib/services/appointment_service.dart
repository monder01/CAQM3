import 'package:cloud_firestore/cloud_firestore.dart';
import '../tappointment.dart';

class AppointmentService {
  final CollectionReference _appointmentsCollection = FirebaseFirestore.instance
      .collection('appointments');

  // 🔹 إضافة موعد جديد
  Future<void> addAppointment(Appointment appointment) async {
    await _appointmentsCollection.doc(appointment.appointmentId).set({
      'appointmentId': appointment.appointmentId,
      'patientId': appointment.patientId,
      'doctorId': appointment.doctorId,
      'appointmentDate': appointment.appointmentDate?.toIso8601String(),
      'appointmentTime': appointment.appointmentTime,
      'status': appointment.status,
    });
  }

  // 🔹 جلب المواعيد الخاصة بمريض معين
  Future<List<Appointment>> getAppointmentsByPatient(String patientId) async {
    final snapshot = await _appointmentsCollection
        .where('patientId', isEqualTo: patientId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Appointment()
        ..appointmentId = data['appointmentId']
        ..patientId = data['patientId']
        ..doctorId = data['doctorId']
        ..appointmentDate = data['appointmentDate'] != null
            ? DateTime.parse(data['appointmentDate'])
            : null
        ..appointmentTime = data['appointmentTime']
        ..status = data['status'];
    }).toList();
  }

  // 🔹 تحديث موعد
  Future<void> updateAppointment(Appointment appointment) async {
    await _appointmentsCollection.doc(appointment.appointmentId).update({
      'appointmentDate': appointment.appointmentDate?.toIso8601String(),
      'appointmentTime': appointment.appointmentTime,
      'status': appointment.status,
    });
  }

  // 🔹 حذف موعد
  Future<void> deleteAppointment(String appointmentId) async {
    await _appointmentsCollection.doc(appointmentId).delete();
  }

  // 🔹 جلب المواعيد الخاصة بطبيب (اختياري لاحقًا)
  Future<List<Appointment>> getAppointmentsByDoctor(String doctorId) async {
    final snapshot = await _appointmentsCollection
        .where('doctorId', isEqualTo: doctorId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Appointment()
        ..appointmentId = data['appointmentId']
        ..patientId = data['patientId']
        ..doctorId = data['doctorId']
        ..appointmentDate = data['appointmentDate'] != null
            ? DateTime.parse(data['appointmentDate'])
            : null
        ..appointmentTime = data['appointmentTime']
        ..status = data['status'];
    }).toList();
  }
}
