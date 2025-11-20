import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointmentspage extends StatefulWidget {
  final String? patientId; // يستخدم إذا كان الإداري يضيف موعد لمريض

  const Appointmentspage({super.key, this.patientId});

  @override
  State<Appointmentspage> createState() => _AppointmentspageState();
}

class _AppointmentspageState extends State<Appointmentspage> {
  String? selectedDoctorId;
  String? selectedDay;
  String? selectedTime;

  List<String> availableDays = [];
  List<String> availableTimes = [];

  bool saving = false;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // نحدد userId الصحيح
    final String patientId =
        widget.patientId ?? FirebaseAuth.instance.currentUser?.uid ?? '';

    if (patientId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Add Appointment")),
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Appointment"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔵 اختيار الدكتور
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('Doctors').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Select Doctor"),
                  items: docs.map((doc) {
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(doc['Full Name']),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    setState(() {
                      selectedDoctorId = value;
                      selectedDay = null;
                      selectedTime = null;
                      availableDays = [];
                      availableTimes = [];
                    });

                    if (value == null) return;

                    try {
                      var d = await db.collection('Doctors').doc(value).get();
                      setState(() {
                        availableDays = List<String>.from(
                          d['availableDays'] ?? [],
                        );
                        availableTimes = List<String>.from(
                          d['availableTimes'] ?? [],
                        );
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error loading doctor data: $e"),
                        ),
                      );
                    }
                  },
                );
              },
            ),

            SizedBox(height: 20),

            // 🔵 اختيار اليوم
            if (availableDays.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Day"),
                initialValue: selectedDay,
                items: availableDays
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedDay = v),
              ),

            SizedBox(height: 20),

            // 🔵 اختيار الوقت
            if (availableTimes.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Time"),
                initialValue: selectedTime,
                items: availableTimes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedTime = v),
              ),

            SizedBox(height: 30),

            // 🔵 زر إضافة الموعد
            ElevatedButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (selectedDoctorId == null ||
                          selectedDay == null ||
                          selectedTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill all fields")),
                        );
                        return;
                      }

                      setState(() => saving = true);

                      try {
                        await db.runTransaction((tx) async {
                          final queueRef = db.collection('Queue').doc('main');

                          final queueSnap = await tx.get(queueRef);

                          int tokenCounter = queueSnap.exists
                              ? queueSnap['tokenCounter'] ?? 0
                              : 0;

                          int tokenDone = queueSnap.exists
                              ? queueSnap['tokenDone'] ?? 0
                              : 0;

                          int newToken = tokenCounter + 1;

                          // تحديث الطابور
                          tx.set(queueRef, {
                            'tokenCounter': newToken,
                            'tokenDone': tokenDone,
                          }, SetOptions(merge: true));

                          // إنشاء الموعد
                          final appRef = db.collection('Appointments').doc();

                          tx.set(appRef, {
                            'doctorId': selectedDoctorId,
                            'userId': patientId,
                            'day': selectedDay,
                            'time': selectedTime,
                            'token': newToken,
                            'status': 'pending',
                            'createdAt': DateTime.now(),
                          });
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Appointment added ✅")),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error adding appointment: $e"),
                          ),
                        );
                      } finally {
                        setState(() => saving = false);
                      }
                    },
              child: saving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Add Appointment"),
            ),
          ],
        ),
      ),
    );
  }
}
