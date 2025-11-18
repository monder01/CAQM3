import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAvailabilityPage extends StatefulWidget {
  final String doctorId; // نرسل ID الدكتور من الصفحة السابقة

  const AddAvailabilityPage({super.key, required this.doctorId});

  @override
  State<AddAvailabilityPage> createState() => _AddAvailabilityPageState();
}

class _AddAvailabilityPageState extends State<AddAvailabilityPage> {
  final List<String> days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];

  final List<String> timeSlots = [
    "08:00-08:30",
    "08:30-09:00",
    "09:00-09:30",
    "09:30-10:00",
    "10:00-10:30",
    "10:30-11:00",
    "11:00-11:30",
    "11:30-12:00",
    "12:00-12:30",
    "12:30-13:00",
    "13:00-13:30",
    "13:30-14:00",
    "14:00-14:30",
    "14:30-15:00",
    "15:00-15:30",
    "15:30-16:00",
  ];

  List<String> selectedDays = [];
  List<String> selectedTimes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Availability"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "Select Available Days:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Wrap(
              spacing: 8,
              children: days.map((day) {
                final isSelected = selectedDays.contains(day);
                return FilterChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedDays.add(day);
                      } else {
                        selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              "Select Available Times:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: ListView(
                children: timeSlots.map((slot) {
                  return CheckboxListTile(
                    title: Text(slot),
                    value: selectedTimes.contains(slot),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedTimes.add(slot);
                        } else {
                          selectedTimes.remove(slot);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDays.isEmpty || selectedTimes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please select at least one day and one time.",
                      ),
                    ),
                  );
                  return;
                }

                await FirebaseFirestore.instance
                    .collection("Doctors")
                    .doc(widget.doctorId)
                    .update({
                      "availableDays": selectedDays,
                      "availableTimes": selectedTimes,
                    });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Availability added successfully ✅")),
                );

                Navigator.pop(context);
              },
              child: Text("Save Availability"),
            ),
          ],
        ),
      ),
    );
  }
}
