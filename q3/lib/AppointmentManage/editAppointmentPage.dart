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
  String? selectedDay;
  String? selectedTime;

  List<String> availableDays = [];
  List<String> availableTimes = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDoctorData();
  }

  Future<void> loadDoctorData() async {
    final db = FirebaseFirestore.instance;

    // ⬅ أحضر الموعد
    var appointment = await db
        .collection('Appointments')
        .doc(widget.appointmentId)
        .get();

    String doctorId = appointment['doctorId'];

    // ⬅ أحضر بيانات الدكتور
    var doctor = await db.collection('Doctors').doc(doctorId).get();

    availableDays = List<String>.from(doctor['availableDays'] ?? []);
    availableTimes = List<String>.from(doctor['availableTimes'] ?? []);

    selectedDay = availableDays.contains(widget.currentDay)
        ? widget.currentDay
        : null;

    selectedTime = availableTimes.contains(widget.currentTime)
        ? widget.currentTime
        : null;

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Edit Appointment")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Appointment"),
        backgroundColor: Colors.amberAccent[200],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔵 اختيار اليوم
            DropdownButtonFormField<String>(
              initialValue: selectedDay,
              decoration: const InputDecoration(labelText: "Select Day"),
              items: availableDays
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedDay = v),
            ),

            SizedBox(height: 20),

            // 🔵 اختيار الوقت
            DropdownButtonFormField<String>(
              initialValue: selectedTime,
              decoration: const InputDecoration(labelText: "Select Time"),
              items: availableTimes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedTime = v),
            ),

            SizedBox(height: 30),

            // 🔵 حفظ التعديل
            ElevatedButton(
              onPressed: () async {
                if (selectedDay == null || selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select day and time")),
                  );
                  return;
                }

                await FirebaseFirestore.instance
                    .collection('Appointments')
                    .doc(widget.appointmentId)
                    .update({'day': selectedDay, 'time': selectedTime});

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Updated successfully")));

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
