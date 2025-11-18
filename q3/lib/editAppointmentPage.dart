import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAppointmentPage extends StatefulWidget {
  final String appointmentId;
  final String currentDay;
  final String currentTime;

  const EditAppointmentPage({
    super.key,
    required this.appointmentId,
    required this.currentDay,
    required this.currentTime,
  });

  @override
  State<EditAppointmentPage> createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  final List<String> availableDays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
  ];

  final List<String> availableTimes = [
    "08:00-08:30",
    "09:00-09:30",
    "10:00-10:30",
    "11:00-11:30",
    "12:00-12:30",
    "13:00-13:30",
    "14:00-14:30",
    "15:00-15:30",
  ];

  String? selectedDay;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.currentDay;
    selectedTime = widget.currentTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Appointment"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Select Day"),
              initialValue: selectedDay,
              items: availableDays.map((day) {
                return DropdownMenuItem(value: day, child: Text(day));
              }).toList(),
              onChanged: (value) => setState(() => selectedDay = value),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Select Time"),
              initialValue: selectedTime,
              items: availableTimes.map((time) {
                return DropdownMenuItem(value: time, child: Text(time));
              }).toList(),
              onChanged: (value) => setState(() => selectedTime = value),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (selectedDay == null || selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("⚠️ Please select both fields")),
                  );
                  return;
                }

                await FirebaseFirestore.instance
                    .collection('Appointments')
                    .doc(widget.appointmentId)
                    .update({
                      'day': selectedDay,
                      'time': selectedTime,
                      'updatedAt': DateTime.now(),
                    });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ Appointment updated")),
                );

                Navigator.pop(context);
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
