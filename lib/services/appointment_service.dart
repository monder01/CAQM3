import 'package:cloud_firestore/cloud_firestore.dart';
import '../tappointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'appointments';

  // 🟢 إضافة موعد جديد
  Future<void> addAppointment(Appointment appointment) async {
    final docRef = _firestore.collection(collectionName).doc();
    appointment.appointmentId = docRef.id;

    await docRef.set(appointment.toMap());
  }

  // 🟡 تحديث موعد موجود
  Future<void> updateAppointment(Appointment appointment) async {
    if (appointment.appointmentId == null) {
      throw Exception('Appointment ID is required to update');
    }

    await _firestore
        .collection(collectionName)
        .doc(appointment.appointmentId)
        .update(appointment.toMap());
  }

  // 🔴 حذف موعد
  Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection(collectionName).doc(appointmentId).delete();
  }

  // 🔵 جلب جميع المواعيد لمريض محدد
  Future<List<Appointment>> getAppointmentsByPatient(String patientId) async {
    QuerySnapshot snapshot = await _firestore
        .collection(collectionName)
        .where('patientId', isEqualTo: patientId)
        .get();

    return snapshot.docs
        .map((doc) => Appointment.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
