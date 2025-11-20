import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointmentsPages.dart';
import 'editAppointmentPage.dart';
import 'adminQueuePage.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt),
            tooltip: "Go to General Queue",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QueuePage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Appointment",
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
            .snapshots(), // بدون orderBy لتجنب مشاكل index
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty)
            return Center(
              child: Text("No appointments for ${widget.patientName}"),
            );

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final day = data['day'] ?? '-';
              final time = data['time'] ?? '-';
              final token = data['token'] ?? '-';
              final status = data['status'] ?? '-';
              final doctorId = data['doctorId'] ?? '-';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text("Day: $day  •  Time: $time"),
                  subtitle: Text("Token: $token  •  Status: $status"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        tooltip: "Edit Appointment",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAppointmentPage(
                                appointmentId: doc.id,
                                currentDay: day,
                                currentTime: time,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: "Delete Appointment",
                        onPressed: () async {
                          bool confirmed = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text(
                                "Are you sure you want to delete this appointment?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                          if (confirmed) {
                            await FirebaseFirestore.instance
                                .collection('Appointments')
                                .doc(doc.id)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Appointment deleted")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
