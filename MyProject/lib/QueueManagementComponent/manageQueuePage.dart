import 'package:flutter/material.dart';
import 'package:prototype1/QueueManagementComponent/checkInAdmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Managequeuepage extends StatefulWidget {
  const Managequeuepage({super.key});

  @override
  State<Managequeuepage> createState() => _ManagequeuepageState();
}

class _ManagequeuepageState extends State<Managequeuepage> {
  FirebaseFirestore queuedata = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة الطابور للواصلين'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final snap = await queuedata
                          .collection('Queue')
                          .limit(1)
                          .get();
                      if (snap.docs.isNotEmpty) {
                        final id = snap.docs.first.id;
                        await queuedata.collection('Queue').doc(id).update({
                          'MovingLineNumber': FieldValue.increment(-1),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم الرجوع')),
                        );
                      }
                      /*else {
                        await queuedata.collection('Queue').add({
                          'MovingLineNumber': 1,
                          'TodayLineNumber': 1,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم إنشاء الطابور')),
                        );
                      }*/
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 100,
                        color: Colors.amberAccent[200],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "الرجوع بالطابور",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.manage_accounts_rounded,
                        size: 100,
                        color: Colors.amberAccent[200],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "الطابور الأن",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),

                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Queue")
                            .limit(1)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              "0",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            );
                          }

                          final document = snapshot.data!.docs.first;
                          int todayLine = document["MovingLineNumber"];

                          return Text(
                            todayLine.toString(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final snap = await queuedata
                          .collection('Queue')
                          .limit(1)
                          .get();
                      if (snap.docs.isNotEmpty) {
                        final id = snap.docs.first.id;
                        await queuedata.collection('Queue').doc(id).update({
                          'MovingLineNumber': FieldValue.increment(1),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم التقدم')),
                        );
                      }
                      /*else {
                        await queuedata.collection('Queue').add({
                          'MovingLineNumber': 1,
                          'TodayLineNumber': 1,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم إنشاء الطابور')),
                        );
                      }*/
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        size: 100,
                        color: Colors.amberAccent[200],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "التقدم بالطابور",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
