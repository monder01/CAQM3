import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adminPage.dart';
import '../AppointmentManage/appointmentsListPage.dart';
import 'users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  Users user =
      Users(); // إنشاء كائن من فئة المستخدم لتخزين البيانات والسيطرة على المدخلات

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"), // عنوان صفحة تسجيل الدخول
        backgroundColor: Colors.amberAccent[200], // تغيير لون شريط العنوان
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // هامش داخلي حول محتوى الصفحة
          child: Column(
            children: [
              TextField(
                controller: user
                    .emailController, // حقل إدخال البريد الإلكتروني المرتبط بالمتحكم
                decoration: InputDecoration(
                  labelText: "Email", // نص يظهر فوق الحقل للدلالة على نوعه
                  border: OutlineInputBorder(), // إطار حول الحقل
                ),
              ),
              SizedBox(height: 20), // مساحة فارغة للفصل بين العناصر
              TextField(
                controller: user.passwordController, // حقل إدخال كلمة المرور
                obscureText: true, // إخفاء النص المدخل لزيادة الأمان
                decoration: InputDecoration(
                  labelText: "Password", // نص يدل على الحقل
                  border: OutlineInputBorder(), // إطار الحقل
                ),
              ),
              SizedBox(height: 20), // مساحة فارغة قبل زر تسجيل الدخول
              ElevatedButton(
                onPressed: () async {
                  user.email = user
                      .emailController
                      .text; // حفظ البريد من الحقل في الكائن
                  user.password =
                      user.passwordController.text; // حفظ كلمة المرور من الحقل

                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: user.email!,
                          password: user.password!,
                        );
                    // محاولة تسجيل الدخول باستخدام فايربيز مصادقة

                    var doc = await FirebaseFirestore.instance
                        .collection(
                          'users',
                        ) // الوصول إلى مجموعة المستخدمين في قاعدة البيانات
                        .doc(
                          userCredential.user!.uid,
                        ) // تحديد وثيقة المستخدم بواسطة معرّفه
                        .get(); // جلب بيانات الوثيقة

                    String role =
                        doc['Role']; // استخراج دور المستخدم المخزّن في قاعدة البيانات

                    if (role == 'Admin') {
                      // إذا كان المستخدم مديراً يتم نقله إلى صفحة المدير
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Admin()),
                      );
                    } else {
                      // إذا لم يكن مديراً يتم نقله إلى صفحة قائمة المواعيد
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentsListPage(),
                        ),
                      );
                    }

                    print(
                      "✅ Login successful! Role: $role",
                    ); // طباعة تأكيد نجاح تسجيل الدخول
                  } catch (e) {
                    print(
                      "❌ Error: $e",
                    ); // طباعة الخطأ إن وُجدت مشكلة أثناء تسجيل الدخول
                  }
                },
                child: Text("login"), // نص زر تسجيل الدخول
              ),
            ],
          ),
        ),
      ),
    );
  }
}
