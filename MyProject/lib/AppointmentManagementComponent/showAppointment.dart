import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'teleconsultationPage.dart';

class Showappointment extends StatefulWidget {
  const Showappointment({super.key, this.patientIdd});
  final String? patientIdd;

  @override
  State<Showappointment> createState() => _ShowappointmentState();
}

class _ShowappointmentState extends State<Showappointment> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  String? currentUser;

  String? currentEmail;

  @override
  void initState() {
    super.initState();
    if (widget.patientIdd != null) {
      currentUser = widget.patientIdd;
    } else {
      currentUser = currentUserId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواعيدي'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.move_down, color: Colors.blueAccent, size: 50),

              SizedBox(width: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Queue")
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      "0",
                      style: TextStyle(fontSize: 22, color: Colors.black),
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
              SizedBox(width: 20),
              Text(
                "الطابور الان ",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                        minLeadingWidth: 50,
                        leading: Icon(
                          Icons.schedule_sharp,
                          color: Colors.amber,
                          size: 40,
                        ),
                        title: Text("الطبيب: ${doc['doctorName']}"),
                        subtitle: Text(
                          "التاريخ: ${doc['date']} - الوقت: ${doc['time']} \nالنوع: ${doc['appointmentType']} - التكلفة: \$${doc['cost']}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.confirmation_num,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "الدور : ${doc['LineNumber']}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('Appointments')
                                    .doc(doc.id)
                                    .delete();
                              },
                            ),
                            IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('Appointments')
                                    .doc(doc.id)
                                    .update({'status': 'WaitingToCheckIn'});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("في تأكيد الوصول. ")),
                                );
                              },

                              icon: Icon(
                                Icons.check,
                                color: Colors.purpleAccent,
                              ),
                            ),
                            if (doc['appointmentType'] == 'إستشارة')
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Teleconsultationpage(
                                            otherUserEmail: doc['doctorEmail'],
                                            otherUserName: doc['doctorName'],
                                          ),
                                    ),
                                  );
                                },
                                icon: Text("Start Session"),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
