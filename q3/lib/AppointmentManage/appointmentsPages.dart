import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// صفحة إضافة موعد جديد
class Appointmentspage extends StatefulWidget {
  final String? patientId; // يُستخدم إذا كان الأدمن يضيف موعد لمريض آخر

  const Appointmentspage({super.key, this.patientId});

  @override
  State<Appointmentspage> createState() => _AppointmentspageState();
}

class _AppointmentspageState extends State<Appointmentspage> {
  // المتغيرات التي سيختارها المستخدم
  String? selectedDoctorId;
  String? selectedDay;
  String? selectedTime;

  // الأيام والأوقات المتاحة للدكتور
  List<String> availableDays = [];
  List<String> availableTimes = [];

  bool saving = false; // لمعرفة إذا كان الحفظ جارٍ

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // تحديد رقم المريض: إذا تم تمريره من الأدمن، نأخذه، وإلا نستخدم المستخدم الحالي
    final String patientId =
        widget.patientId ?? FirebaseAuth.instance.currentUser?.uid ?? '';

    // إذا لم يكن هناك مستخدم مسجّل دخول
    if (patientId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Add Appointment")),
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Appointment"),
        backgroundColor: Colors.amberAccent[200], // لون شريط العنوان
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //  اختيار الدكتور من قاعدة البيانات
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('Doctors').snapshots(),
              builder: (context, snapshot) {
                // أثناء تحميل بيانات الأطباء
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!.docs;

                // قائمة اختيار الدكتور
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Select Doctor"),
                  items: docs.map((doc) {
                    return DropdownMenuItem(
                      value: doc.id, // id الخاص بالدكتور
                      child: Text(doc['Full Name']),
                    );
                  }).toList(),

                  // عند اختيار الدكتور
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
                      // جلب الأيام والأوقات المتاحة للدكتور
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
                      // خطأ أثناء تحميل بيانات الدكتور
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

            //  اختيار اليوم
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

            //  اختيار الوقت
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

            //  زر حفظ الموعد داخل قاعدة البيانات
            ElevatedButton(
              onPressed: saving
                  ? null // إيقاف الضغط أثناء الحفظ
                  : () async {
                      // التحقق من إدخال جميع الحقول
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
                        // تنفيذ معاملة لحفظ الموعد وزيادة التوكن (token)
                        await db.runTransaction((tx) async {
                          final queueRef = db.collection('Queue').doc('main');

                          final queueSnap = await tx.get(queueRef);

                          // قراءة آخر توكن
                          int tokenCounter = queueSnap.exists
                              ? queueSnap['tokenCounter'] ?? 0
                              : 0;

                          int tokenDone = queueSnap.exists
                              ? queueSnap['tokenDone'] ?? 0
                              : 0;

                          int newToken = tokenCounter + 1;

                          // تحديث بيانات الطابور (Token)
                          tx.set(queueRef, {
                            'tokenCounter': newToken,
                            'tokenDone': tokenDone,
                          }, SetOptions(merge: true));

                          // إضافة موعد جديد
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

                        // رسالة نجاح
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Appointment added ✅")),
                        );

                        Navigator.pop(context); // الرجوع للصفحة السابقة
                      } catch (e) {
                        // في حال حدوث خطأ أثناء إضافة الموعد
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
