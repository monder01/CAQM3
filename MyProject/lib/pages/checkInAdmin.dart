import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prototype1/notifications.dart';
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
  late Notifications notify = Notifications();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل وصول المريض'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                        title: Text("المريض: ${doc['patientName']}"),
                        subtitle: Text("رقم الدور: ${doc['LineNumber']}"),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('تسجيل الوصول'),
                          onPressed: () async {
                            await queueLine.checkInPatient(doc.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "تم تسجيل وصول المريض ${doc['patientName']} بنجاح.",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent[200],
                  ),
                  child: Text(
                    'تهيئة الطابور',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    bool confirmed = await notify.showConfirmationDialog(
                      context,
                    );
                    if (!confirmed) return;
                    DateTime? dateNow = DateTime.now();
                    String formattedDate = dateNow.toIso8601String().substring(
                      0,
                      10,
                    );

                    await queueData.collection('Queue').get().then((
                      querySnapshot,
                    ) {
                      if (querySnapshot.docs.isNotEmpty) {
                        var queueDoc = querySnapshot.docs.first;

                        // Reset the Today's Line Number in the Queue collection
                        queueData.collection('Queue').doc(queueDoc.id).update({
                          'TodayLineNumber': 0,
                          'date': formattedDate,
                        });
                      } else {
                        // If no queue document exists, create one
                        queueData.collection('Queue').add({
                          'TodayLineNumber': 0,
                          'date': formattedDate,
                        });
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("تم تهيئة الطابور بنجاح.")),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
