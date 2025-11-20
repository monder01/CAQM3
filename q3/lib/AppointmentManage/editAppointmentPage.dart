import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// صفحة تعديل موعد موجود مسبقًا
class EditAppointmentPage extends StatefulWidget {
  final String appointmentId; // رقم الموعد في قاعدة البيانات
  final String currentDay; // اليوم الحالي للموعد قبل التعديل
  final String currentTime; // الوقت الحالي للموعد قبل التعديل

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
  // المتغيرات التي سيختارها المستخدم للتعديل
  String? selectedDay;
  String? selectedTime;

  // الأيام المتاحة والأوقات المتاحة للدكتور
  List<String> availableDays = [];
  List<String> availableTimes = [];

  bool loading = true; // لمعرفة هل البيانات مازالت تُحمّل

  @override
  void initState() {
    super.initState();
    loadDoctorData(); // تحميل بيانات الدكتور عند فتح الصفحة
  }

  // 🟦 تحميل بيانات الدكتور بناءً على الموعد
  Future<void> loadDoctorData() async {
    final db = FirebaseFirestore.instance;

    // ⬅ جلب بيانات الموعد من قاعدة البيانات
    var appointment = await db
        .collection('Appointments')
        .doc(widget.appointmentId)
        .get();

    String doctorId = appointment['doctorId']; // استخراج رقم الدكتور

    // ⬅ جلب بيانات الدكتور مثل الأيام والأوقات المتاحة
    var doctor = await db.collection('Doctors').doc(doctorId).get();

    availableDays = List<String>.from(doctor['availableDays'] ?? []);
    availableTimes = List<String>.from(doctor['availableTimes'] ?? []);

    // تعيين اليوم المختار إذا كان موجودًا في القائمة
    selectedDay = availableDays.contains(widget.currentDay)
        ? widget.currentDay
        : null;

    // تعيين الوقت المختار إذا كان موجودًا في القائمة
    selectedTime = availableTimes.contains(widget.currentTime)
        ? widget.currentTime
        : null;

    setState(() => loading = false); // إيقاف شاشة التحميل
  }

  @override
  Widget build(BuildContext context) {
    // أثناء تحميل البيانات
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Edit Appointment")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // بعد تحميل البيانات
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Appointment"),
        backgroundColor: Colors.amberAccent[200],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔵 اختيار اليوم الجديد
            DropdownButtonFormField<String>(
              initialValue: selectedDay,
              decoration: const InputDecoration(labelText: "Select Day"),
              items: availableDays
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedDay = v),
            ),

            SizedBox(height: 20),

            // 🔵 اختيار الوقت الجديد
            DropdownButtonFormField<String>(
              initialValue: selectedTime,
              decoration: const InputDecoration(labelText: "Select Time"),
              items: availableTimes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedTime = v),
            ),

            SizedBox(height: 30),

            // 🔵 حفظ التعديل في قاعدة البيانات
            ElevatedButton(
              onPressed: () async {
                // التحقق من أن المستخدم اختار يوم ووقت
                if (selectedDay == null || selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select day and time")),
                  );
                  return;
                }

                // تحديث الموعد داخل Firestore
                await FirebaseFirestore.instance
                    .collection('Appointments')
                    .doc(widget.appointmentId)
                    .update({'day': selectedDay, 'time': selectedTime});

                // رسالة نجاح
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Updated successfully")));

                // العودة إلى الصفحة السابقة
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
