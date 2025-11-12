import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:st1/editAppointmentPage.dart';
import 'package:st1/appointmentsPages.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .where('userId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var appointments = snapshot.data!.docs;

          if (appointments.isEmpty) {
            return Center(child: Text("No Appointments Yet"));
          }

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index];
              String doctorId = appointment['doctorId'];

              // ✅ نستخدم FutureBuilder لجلب اسم الدكتور من Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Doctors')
                    .doc(doctorId)
                    .get(),
                builder: (context, doctorSnapshot) {
                  if (!doctorSnapshot.hasData) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(title: Text("Loading doctor...")),
                    );
                  }

                  var doctorData = doctorSnapshot.data!;
                  String doctorName =
                      doctorData['Full Name'] ?? 'Unknown Doctor';

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text("Doctor: $doctorName"),
                      subtitle: Text(
                        "Day: ${appointment['day']}\nTime: ${appointment['time']}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditAppointmentPage(
                                    appointmentId: appointment.id,
                                    currentDay: appointment['day'],
                                    currentTime: appointment['time'],
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('Appointments')
                                  .doc(appointment.id)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("🗑️ Appointment deleted"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),

      // ✅ الزر العائم لإضافة موعد جديد
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent[200],
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Appointmentspage()),
          );
        },
      ),
    );
  }
}
