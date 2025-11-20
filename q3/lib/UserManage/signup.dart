//signup.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../homePage.dart';
import 'users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Users users = Users(); // إنشاء كائن مستخدم لتخزين البيانات المدخلة وإدارتها
  final TextEditingController fullNamecon =
      TextEditingController(); // متحكم لحقل الاسم الكامل
  final TextEditingController emailcon =
      TextEditingController(); // متحكم لحقل البريد الإلكتروني
  final TextEditingController passwordcon =
      TextEditingController(); // متحكم لحقل كلمة المرور
  final TextEditingController phoneNumcon =
      TextEditingController(); // متحكم لحقل رقم الهاتف

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"), // عنوان صفحة إنشاء الحساب
        backgroundColor: Colors.amberAccent[200], // تعيين لون شريط العنوان
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ), // إضافة مسافة داخلية حول عناصر الصفحة
          child: Column(
            children: [
              TextField(
                controller: fullNamecon, // ربط الحقل بمتحكم الاسم الكامل
                decoration: InputDecoration(
                  labelText: "Full name", // تسمية الحقل
                  border: OutlineInputBorder(), // إطار الحقل
                ),
              ),
              SizedBox(height: 10), // مسافة فاصلة بين الحقول
              TextField(
                controller: emailcon, // ربط الحقل بمتحكم البريد الإلكتروني
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller:
                    passwordcon, // ربط حقل كلمة المرور بالمتحكم الخاص به
                obscureText: true, // إخفاء النص المدخل حفاظاً على الخصوصية
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneNumcon, // ربط الحقل بمتحكم رقم الهاتف
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  users.fullname =
                      fullNamecon.text; // تخزين الاسم في كائن المستخدم
                  users.email = emailcon.text; // تخزين البريد الإلكتروني
                  users.password = passwordcon.text; // تخزين كلمة المرور
                  users.phoneNumber = phoneNumcon.text; // تخزين رقم الهاتف
                  users.role =
                      "Patient"; // تحديد الدور الافتراضي للمستخدم الجديد

                  try {
                    UserCredential userinfo = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: users.email!,
                          password: users.password!,
                        );
                    // إنشاء حساب جديد باستخدام فايربيز مصادقة

                    await FirebaseFirestore.instance
                        .collection('users') // اختيار مجموعة المستخدمين
                        .doc(
                          userinfo.user!.uid,
                        ) // إنشاء وثيقة للمستخدم بمعرّف uid
                        .set({
                          'Full Name': users.fullname,
                          'Email': users.email,
                          'Phone Number': users.phoneNumber,
                          'Role': users.role,
                        });
                    // تخزين بيانات المستخدم في فايرستور

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                    // الانتقال إلى الصفحة الرئيسية بعد نجاح إنشاء الحساب

                    print(
                      "✅ Account created successfully for ${users.fullname}", // طباعة رسالة نجاح
                    );
                  } catch (e) {
                    print(
                      "❌ Error: $e",
                    ); // طباعة الخطأ إن حدثت مشكلة أثناء إنشاء الحساب
                  }
                },
                child: Text("Sign Up"), // نص زر إنشاء الحساب
              ),
            ],
          ),
        ),
      ),
    );
  }
}
