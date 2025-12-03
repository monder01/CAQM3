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
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_upward)),
            IconButton(
              onPressed: () async {
                final serverTime = Timestamp.now();
                final date = serverTime.toDate();
                final finalDate = "${date.year}-${date.month}-${date.day}";

                final queueDoc = queueData.collection("Queue").doc();
                await queueDoc.set({'createdAt': finalDate});

                await queueDoc.collection("QueueLine").add({
                  'patientId': currentUser,
                  'status': 'CheckedIn',
                  'time': FieldValue.serverTimestamp(),
                });
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("succesfull try")));
              },
              icon: Icon(Icons.restore),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_downward)),
          ],
        ),
      ),
    );
  }
}
