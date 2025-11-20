//addAvailabilityPage.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAvailabilityPage extends StatefulWidget {
  final String doctorId; // نرسل معرّف الدكتور من الصفحة السابقة لتحديد السجلات

  const AddAvailabilityPage({super.key, required this.doctorId});

  @override
  State<AddAvailabilityPage> createState() => _AddAvailabilityPageState();
}

class _AddAvailabilityPageState extends State<AddAvailabilityPage> {
  // قائمة أيام الأسبوع المتاحة للاختيار
  final List<String> days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];

  // قائمة الفترات الزمنية المتاحة لكل يوم
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

  List<String> selectedDays = []; // لتخزين الأيام التي يحددها الطبيب
  List<String> selectedTimes = []; // لتخزين الفترات الزمنية المختارة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Availability"), // عنوان الصفحة
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0), // مسافة حول عناصر الصفحة
        child: Column(
          children: [
            Text(
              "Select Available Days:", // عنوان قسم اختيار الأيام
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Wrap(
              spacing: 8, // المسافة بين عناصر FilterChip
              children: days.map((day) {
                final isSelected = selectedDays.contains(day);
                // التحقق مما إذا كان اليوم محدد مسبقاً
                return FilterChip(
                  label: Text(day), // عرض اسم اليوم
                  selected: isSelected, // حالة الاختيار
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedDays.add(
                          day,
                        ); // إضافة اليوم إلى القائمة عند الاختيار
                      } else {
                        selectedDays.remove(
                          day,
                        ); // إزالة اليوم عند إلغاء الاختيار
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20), // مسافة فاصلة

            Text(
              "Select Available Times:", // عنوان قسم اختيار الفترات الزمنية
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: ListView(
                children: timeSlots.map((slot) {
                  return CheckboxListTile(
                    title: Text(slot), // عرض الفترة الزمنية
                    value: selectedTimes.contains(slot), // حالة الاختيار
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedTimes.add(
                            slot,
                          ); // إضافة الفترة إلى القائمة عند الاختيار
                        } else {
                          selectedTimes.remove(
                            slot,
                          ); // إزالة الفترة عند إلغاء الاختيار
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                // التحقق من اختيار يوم واحد على الأقل وفترة واحدة على الأقل
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

                // تحديث بيانات الطبيب في Firestore بحقل الأيام والفترات الزمنية المتاحة
                await FirebaseFirestore.instance
                    .collection("Doctors")
                    .doc(widget.doctorId)
                    .update({
                      "availableDays": selectedDays,
                      "availableTimes": selectedTimes,
                    });

                // عرض رسالة نجاح العملية
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Availability added successfully ✅")),
                );

                Navigator.pop(context); // العودة إلى الصفحة السابقة بعد الحفظ
              },
              child: Text("Save Availability"), // نص الزر
            ),
          ],
        ),
      ),
    );
  }
}
