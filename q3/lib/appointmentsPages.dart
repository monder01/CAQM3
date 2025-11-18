//appointmentsPages.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Appointmentspage extends StatefulWidget {
  const Appointmentspage({super.key});

  @override
  State<Appointmentspage> createState() => _AppointmentspageState();
}

class _AppointmentspageState extends State<Appointmentspage> {
  String? selectedDoctorId;
  String? selectedDay;
  String? selectedTime;
  List<String> availableDays = [];
  List<String> availableTimes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Appointment"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔸 اختيار الدكتور
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Doctors')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
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

                    // بعد اختيار الدكتور، نجيب أيامه وأوقاته
                    var doctorDoc = await FirebaseFirestore.instance
                        .collection('Doctors')
                        .doc(value)
                        .get();

                    setState(() {
                      availableDays = List<String>.from(
                        doctorDoc['availableDays'] ?? [],
                      );
                      availableTimes = List<String>.from(
                        doctorDoc['availableTimes'] ?? [],
                      );
                    });
                  },
                );
              },
            ),

            SizedBox(height: 20),

            // 🔸 اختيار اليوم
            if (availableDays.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Day"),
                items: availableDays.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day));
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedDay = value);
                },
                initialValue: selectedDay,
              ),
              
            SizedBox(height: 20),

            // 🔸 اختيار الوقت
            if (availableTimes.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Time"),
                items: availableTimes.map((time) {
                  return DropdownMenuItem(value: time, child: Text(time));
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedTime = value);
                },
                initialValue: selectedTime,
              ),

            SizedBox(height: 30),

            // 🔸 زر الحجز
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedDoctorId == null ||
                      selectedDay == null ||
                      selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select all fields")),
                    );
                    return;
                  }

                  // 🔸 الحصول على user الحالي
                  User? currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User not logged in")),
                    );
                    return;
                  }

                  // 🔸 حفظ الموعد في قاعدة البيانات مع userId
                  await FirebaseFirestore.instance
                      .collection('Appointments')
                      .add({
                        'doctorId': selectedDoctorId,
                        'userId': currentUser.uid, // ✅ هنا الإضافة المهمة
                        'day': selectedDay,
                        'time': selectedTime,
                        'status': 'pending',
                        'createdAt': DateTime.now(),
                      });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("✅ Appointment booked successfully"),
                    ),
                  );

                  setState(() {
                    selectedDoctorId = null;
                    selectedDay = null;
                    selectedTime = null;
                  });
                },
                child: Text("Book Appointment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
