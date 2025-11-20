import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'editAppointmentPage.dart';
import 'appointmentsPages.dart';
import 'formpage.dart';

class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({super.key});

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text("My Appointments")),
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .where('userId', isEqualTo: currentUser.uid)
            .snapshots(), // تم إزالة orderBy لتجنب مشاكل index
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

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
              final data = appointment.data() as Map<String, dynamic>;
              final token = data['token'] ?? '-';
              final status = data['status'] ?? '-';
              final doctorId = data['doctorId'] ?? '';

              bool isNext =
                  status == 'pending' &&
                  !appointments.take(index).any((d2) {
                    final m = d2.data() as Map<String, dynamic>;
                    return m['status'] == 'pending';
                  });

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
                    color: isNext ? Colors.green[50] : null,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('$token')),
                      title: Text("Doctor: $doctorName"),
                      subtitle: Text(
                        "Day: ${data['day']}\nTime: ${data['time']}\nStatus: $status",
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
                                    currentDay: data['day'],
                                    currentTime: data['time'],
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

      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Add Appointment",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Appointmentspage()),
            ),
          ),
          SpeedDialChild(
            child: Icon(Icons.note_add),
            label: "Form Page",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadPdfPage()),
            ),
          ),
        ],
      ),
    );
  }
}
