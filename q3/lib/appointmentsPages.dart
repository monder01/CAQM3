import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointmentspage extends StatefulWidget {
  final String? patientId;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Appointment"),
        backgroundColor: Colors.amberAccent[200],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Doctors')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

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

                    var d = await FirebaseFirestore.instance
                        .collection('Doctors')
                        .doc(value)
                        .get();

                    setState(() {
                      availableDays = List<String>.from(d['availableDays']);
                      availableTimes = List<String>.from(d['availableTimes']);
                    });
                  },
                );
              },
            ),

            SizedBox(height: 15),

            if (availableDays.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Day"),
                items: availableDays
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedDay = v),
              ),

            SizedBox(height: 15),

            if (availableTimes.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Time"),
                items: availableTimes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedTime = v),
              ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                if (selectedDoctorId == null ||
                    selectedDay == null ||
                    selectedTime == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Fill all fields")));
                  return;
                }

                final userId =
                    widget.patientId ?? FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance
                    .collection('Appointments')
                    .add({
                      'doctorId': selectedDoctorId,
                      'userId': userId,
                      'day': selectedDay,
                      'time': selectedTime,
                      'status': 'pending',
                      'createdAt': DateTime.now(),
                    });

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Appointment added")));

                Navigator.pop(context);
              },
              child: Text("Add Appointment"),
            ),
          ],
        ),
      ),
    );
  }
}
