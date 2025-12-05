import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype1/AppointmentManagementComponent/teleconsultationPage.dart';

class Doctorappointment extends StatefulWidget {
  const Doctorappointment({super.key});

  @override
  State<Doctorappointment> createState() => _DoctorappointmentState();
}

class _DoctorappointmentState extends State<Doctorappointment> {
  final String currentDoctorId = FirebaseAuth.instance.currentUser!.uid;
  final String? currentDoctorEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مواعيدي كطبيب"),
        backgroundColor: Colors.amberAccent[200],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Appointments")
            .where("doctorId", isEqualTo: currentDoctorId)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                "لا توجد مواعيد حالياً",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Colors.amber,
                    size: 35,
                  ),

                  title: Text("المريض: ${doc['patientName']}"),

                  subtitle: Text(
                    "التاريخ: ${doc['date']} - الوقت: ${doc['time']}\n"
                    "النوع: ${doc['appointmentType']} - التكلفة: \$${doc['cost']}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_num, color: Colors.blue),
                      Text(
                        "الدور: ${doc['LineNumber']}",
                        style: TextStyle(fontSize: 12),
                      ),
                      if (doc['appointmentType'] == 'إستشارة')
                        IconButton(
                          onPressed: () {
                            // الانتقال لصفحة الاستشارة عن بعد مع تمرير بريد واسم الطبيب
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Teleconsultationpage(
                                  otherUserEmail: doc['email'],
                                  otherUserName: doc['patientName'],
                                ),
                              ),
                            );
                          },
                          icon: Text(
                            "Start Session",
                          ), // نص بسيط كزر لبدء الجلسة
                        ),
                    ],
                  ),

                  onTap: () {
                    // تستطيع إضافة صفحة لعرض التفاصيل هنا
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
