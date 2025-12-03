import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Appointment {
  String? appointmentId;
  DateTime? appointmentDate;
  String? date;
  String? time;
  String? reason;
  String? status; // booked, completed, canceled
  String? lineNumber;
  String? appointmentType;
  double? cost;

  /// التحقق من توفر الوقت
  Future<bool> isTimeAvailable(
    String doctorId,
    String time,
    String date,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('time', isEqualTo: time)
        .where('date', isEqualTo: date)
        .get();

    return snapshot.docs.isEmpty;
  }

  /// عرض Dialog لاختيار الطبيب
  Future<Map<String, dynamic>?> showDoctorsDialog(BuildContext context) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.person_search,
            color: Colors.amberAccent[200],
            size: 40,
          ),
          title: Text('اختر طبيب'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Doctors')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final doctorId = data['DoctorID'] ?? docs[index].id;
                    final doctorName = data['FullName'] ?? 'No Name';
                    final workingHours = List<String>.from(
                      data['WorkingHours'] ?? [],
                    );

                    return Card(
                      child: ListTile(
                        title: Text("د. $doctorName"),
                        subtitle: Text(
                          data['Specialization'] ?? 'لا يوجد تخصص',
                        ),
                        onTap: () async {
                          final selectedTime = await showTimesDialog(
                            context,
                            doctorName,
                            workingHours,
                            doctorId,
                          );
                          if (selectedTime != null) {
                            Navigator.of(context).pop({
                              'doctorId': doctorId,
                              'doctorName': doctorName,
                              'time': selectedTime,
                            });
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// عرض Dialog لاختيار الوقت
  Future<String?> showTimesDialog(
    BuildContext context,
    String doctorName,
    List<String> times,
    String doctorId,
  ) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.access_time,
            color: Colors.amberAccent[200],
            size: 40,
          ),
          title: Text('الأوقات المتاحة لـ د. $doctorName'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: times.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(times[index]),
                    onTap: () async {
                      final date = DateTime.now().toIso8601String().substring(
                        0,
                        10,
                      );
                      bool available = await isTimeAvailable(
                        doctorId,
                        times[index],
                        date,
                      );

                      if (!available) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('هذا الوقت محجوز بالفعل')),
                        );
                        return;
                      }
                      Navigator.of(context).pop(times[index]);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// حفظ الموعد
  Future<void> saveAppointment({
    required String doctorId,
    required String doctorName,
    required String time,
    String? appointmentType,
    double? cost,
    String? patientId,
  }) async {
    if (patientId == null) return;

    final date = DateTime.now().toIso8601String().substring(0, 10);
    await FirebaseFirestore.instance.collection('Appointments').add({
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientId': patientId,
      'time': time,
      'date': date,
      'appointmentType': appointmentType,
      'cost': cost,
    });
  }
}
