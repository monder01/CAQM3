//AdminPatientAppointmentsPage.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editAppointmentPage.dart';
import 'appointmentsPages.dart';

class AdminPatientAppointmentsPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientPhone;

  const AdminPatientAppointmentsPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
  });

  @override
  State<AdminPatientAppointmentsPage> createState() =>
      _AdminPatientAppointmentsPageState();
}

class _AdminPatientAppointmentsPageState
    extends State<AdminPatientAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments: ${widget.patientName}"),
        backgroundColor: Colors.amberAccent[200],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Appointmentspage(patientId: widget.patientId),
            ),
          );
        },
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .where('userId', isEqualTo: widget.patientId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text("No appointments."));

          return ListView(
            children: docs.map((doc) {
              return Card(
                child: ListTile(
                  title: Text("Day: ${doc['day']}"),
                  subtitle: Text("Time: ${doc['time']}"),

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
                                appointmentId: doc.id,
                                currentDay: doc['day'],
                                currentTime: doc['time'],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Appointments')
                              .doc(doc.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
