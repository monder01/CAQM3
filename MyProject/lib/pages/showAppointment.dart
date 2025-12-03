import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Showappointment extends StatefulWidget {
  const Showappointment({super.key, this.patientIdd});
  final String? patientIdd;

  @override
  State<Showappointment> createState() => _ShowappointmentState();
}

class _ShowappointmentState extends State<Showappointment> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String? currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.patientIdd != null) {
      currentUser = widget.patientIdd;
    } else {
      currentUser = currentUserId;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواعيدي'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .where('patientId', isEqualTo: currentUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text("لا توجد مواعيد"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              return Card(
                child: ListTile(
                  leading: Icon(Icons.schedule, color: Colors.amber),
                  title: Text("الطبيب: ${doc['doctorName']}"),
                  subtitle: Text(
                    "التاريخ: ${doc['date']} - الوقت: ${doc['time']} \nالنوع: ${doc['appointmentType']} - التكلفة: \$${doc['cost']}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('Appointments')
                              .doc(doc.id)
                              .delete();
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
