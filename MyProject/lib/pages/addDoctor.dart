import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototype1/oop/doctors.dart';
import 'package:prototype1/oop/users.dart';

class Adddoctor extends StatefulWidget {
  const Adddoctor({super.key});

  @override
  State<Adddoctor> createState() => _AdddoctorState();
}

class _AdddoctorState extends State<Adddoctor> {
  UserC user = UserC();
  Doctors doctor = Doctors();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController specializationController = TextEditingController();

  List<String> weekDays = [
    "السبت",
    "الأحد",
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
  ];
  List<String> dayHours = [
    "8:30 - 9:00",
    "9:00 - 9:30",
    "9:30 - 10:00",
    "10:00 - 10:30",
    "10:30 - 11:00",
    "11:00 - 11:30",
    "11:30 - 12:00",
    "12:00 - 12:30",
    "12:30 - 1:00",
    "1:00 - 1:30",
    "1:30 - 2:00",
    "2:00 - 2:30",
    "2:30 - 3:00",
    "3:00 - 3:30",
    "3:30 - 4:00",
    "4:00 - 4:30",
  ];
  Map<String, bool> selectedDays = {};
  Map<String, bool> selectedHours = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // يسمح بالتمرير إذا كانت الشاشة صغيرة
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "إضافة طبيب جديد",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent[200],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "أدخل اسم الطبيب الكامل الثلاثي",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "أدخل البريد الإلكتروني للطبيب",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "أدخل الرقم السري للطبيب",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "أدخل رقم هاتف الطبيب",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: specializationController,
              decoration: InputDecoration(
                labelText: "أدخل تخصص الطبيب",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("اختر أيام عمل الطبيب"),
                      content: SizedBox(
                        width: double.maxFinite,
                        height: 300,
                        child: StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return ListView(
                              children: weekDays.map((day) {
                                return CheckboxListTile(
                                  title: Text(day),
                                  value: selectedDays[day] ?? false,
                                  onChanged: (value) {
                                    setStateDialog(() {
                                      selectedDays[day] = value ?? false;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("تم"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("اختر أيام العمل"),
            ),

            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("اختر ساعات العمل"),
                      content: SizedBox(
                        width: double.maxFinite,
                        height: 300, // اضبط الارتفاع
                        child: StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return ListView(
                              children: dayHours.map((hour) {
                                return CheckboxListTile(
                                  title: Text(hour),
                                  value: selectedHours[hour] ?? false,
                                  onChanged: (value) {
                                    setStateDialog(() {
                                      selectedHours[hour] = value ?? false;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("تم"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("اختر ساعات العمل"),
            ),

            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                doctor.email = emailController.text.trim();
                doctor.password = passwordController.text.trim();
                doctor.fullname = nameController.text.trim();
                doctor.phoneNumber = phoneController.text.trim();
                doctor.specialization = specializationController.text.trim();
                doctor.role = "Doctor";

                doctor.workingDays = selectedDays.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();
                doctor.workingHours = selectedHours.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();
                if (doctor.fullname!.isEmpty ||
                    doctor.email!.isEmpty ||
                    doctor.password!.isEmpty ||
                    doctor.phoneNumber!.isEmpty ||
                    doctor.specialization!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ يرجى ملء جميع الحقول")),
                  );
                  return;
                }
                if (doctor.workingDays.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ يرجى اختيار أيام عمل الطبيب")),
                  );
                  return;
                }

                if (doctor.workingHours.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ يرجى اختيار ساعات عمل الطبيب")),
                  );
                  return;
                }

                try {
                  UserCredential userinfo = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: doctor.email!,
                        password: doctor.password!,
                      );
                  await FirebaseFirestore.instance
                      .collection('Doctors')
                      .doc(userinfo.user!.uid)
                      .set({
                        'FullName': doctor.fullname,
                        'Email': doctor.email,
                        'PhoneNumber': doctor.phoneNumber,
                        'Role': doctor.role,
                        'DoctorID': userinfo.user!.uid,
                        'Specialization': doctor.specialization,
                        'WorkingDays': doctor.workingDays,
                        'WorkingHours': doctor.workingHours,
                      });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تم إضافة الطبيب بنجاح ✅ ${doctor.fullname}",
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
                }
              },
              child: Text("إضافة الطبيب"),
            ),
          ],
        ),
      ),
    );
  }
}
