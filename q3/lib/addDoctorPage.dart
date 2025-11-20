//addDoctorPage.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addAvailabilityPage.dart';
import 'UserManage/doctors.dart';
import 'UserManage/users.dart';

class Adddoctorpage extends StatefulWidget {
  const Adddoctorpage({super.key});

  @override
  State<Adddoctorpage> createState() => _AdddoctorpageState();
}

class _AdddoctorpageState extends State<Adddoctorpage> {
  Users users = Users(); // كائن لتخزين بيانات المستخدم الجديد
  Doctors doctor = Doctors(); // كائن لتخزين بيانات الطبيب الإضافي
  final TextEditingController fullNamecon =
      TextEditingController(); // متحكم لحقل الاسم الكامل
  final TextEditingController emailcon =
      TextEditingController(); // متحكم لحقل البريد الإلكتروني
  final TextEditingController passwordcon =
      TextEditingController(); // متحكم لحقل كلمة المرور
  final TextEditingController phoneNumcon =
      TextEditingController(); // متحكم لحقل رقم الهاتف
  final TextEditingController specialtyCon =
      TextEditingController(); // متحكم لحقل التخصص

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add A Doctor"), // عنوان صفحة إضافة طبيب
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Column(
        children: [
          TextField(
            controller: fullNamecon, // ربط حقل الاسم الكامل بالمتحكم
            decoration: InputDecoration(
              labelText: "Full name", // تسمية الحقل
              border: OutlineInputBorder(), // إطار الحقل
            ),
          ),
          SizedBox(height: 10), // مسافة فاصلة بين الحقول
          TextField(
            controller: emailcon, // ربط حقل البريد الإلكتروني بالمتحكم
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passwordcon, // ربط حقل كلمة المرور بالمتحكم
            obscureText: true, // إخفاء النص للحفاظ على الخصوصية
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: phoneNumcon, // ربط حقل رقم الهاتف بالمتحكم
            decoration: InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: specialtyCon, // ربط حقل التخصص بالمتحكم
            decoration: InputDecoration(
              labelText: "Specialty",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              // تخزين البيانات المدخلة في كائنات المستخدم والطبيب
              users.fullname = fullNamecon.text;
              users.email = emailcon.text;
              users.password = passwordcon.text;
              users.phoneNumber = phoneNumcon.text;
              users.role = "Doctor";
              doctor.specialization = specialtyCon.text;

              try {
                // إنشاء حساب جديد للطبيب باستخدام Firebase Auth
                UserCredential userinfo = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: users.email!,
                      password: users.password!,
                    );

                // تخزين بيانات الطبيب في مجموعة "Doctors" في Firestore
                await FirebaseFirestore.instance
                    .collection('Doctors')
                    .doc(userinfo.user!.uid)
                    .set({
                      'Full Name': users.fullname,
                      'Email': users.email,
                      'Phone Number': users.phoneNumber,
                      'Role': users.role,
                      'specialty': doctor.specialization,
                    });

                print("✅ Account created successfully for ${users.fullname}");
                // الانتقال إلى صفحة إضافة مواعيد للطبيب بعد إنشاء الحساب
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddAvailabilityPage(doctorId: userinfo.user!.uid),
                  ),
                );
              } catch (e) {
                print("❌ Error: $e");
                // طباعة رسالة خطأ في حال فشل العملية
              }
            },
            child: Text("Add Doctor"), // نص الزر لإضافة الطبيب
          ),
        ],
      ),
    );
  }
}
