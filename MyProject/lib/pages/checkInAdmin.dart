import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prototype1/oop/queues.dart';

class Checkinadmin extends StatefulWidget {
  const Checkinadmin({super.key});
  //add later uid for the patient not the user
  @override
  State<Checkinadmin> createState() => _CheckinadminState();
}

class _CheckinadminState extends State<Checkinadmin> {
  FirebaseFirestore queueData = FirebaseFirestore.instance;
  String? currentUser = FirebaseAuth.instance.currentUser!.uid;
  QueueL queueLine = QueueL();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل وصول المريض'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: queueData
            .collection('Appointments')
            .where('status', isEqualTo: 'WaitingToCheckIn')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text("لا توجد حالات انتظار"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              return Card(
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.amber),
                  title: Text("المريض: ${doc['PatientName']}"),
                  subtitle: Text("رقم الدور: ${doc['lineNumber']}"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('تسجيل الوصول'),
                    onPressed: () async {
                      //await queueLine.checkInPatient(doc.id);
                      setState(() {});
                    },
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
