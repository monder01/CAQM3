// lib/oop/users.dart
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر لبناء الواجهات
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة المصادقة من Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة التعامل مع Cloud Firestore
import 'package:prototype1/UserManagementComponent/adminsPage.dart'; // استيراد صفحة الأدمن
import 'package:prototype1/UserManagementComponent/doctorPage.dart';
import 'package:prototype1/UserManagementComponent/patientPage.dart'; // استيراد صفحة المريض

class UserC {
  String? fullname; // اسم المستخدم الكامل
  String? email; // البريد الإلكتروني للمستخدم
  String? phoneNumber; // رقم هاتف المستخدم
  String? role; // دور المستخدم في النظام (Admin / Patient / Doctor ...)
  String? userId; // معرف المستخدم (عادة يكون UID من FirebaseAuth)
  String? password; // كلمة مرور المستخدم

  UserC({
    this.fullname,
    this.email,
    this.phoneNumber,
    this.role,
    this.userId,
    this.password,
  }); // باني الكلاس يسمح بإنشاء كائن مستخدم مع إعطاء قيم مبدئية اختيارية

  // تسجيل الدخول للمستخدم باستخدام البريد الإلكتروني وكلمة المرور
  Future<void> signin(
    String emailcontroller,
    String passwordcontroller,
    BuildContext context,
  ) async {
    email = emailcontroller; // تخزين البريد المرسل في خاصية الكلاس
    password = passwordcontroller; // تخزين كلمة المرور المرسلة في خاصية الكلاس
    if (email == null || password == null) {
      // التحقق من أن البريد وكلمة المرور غير فارغين
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("يرجى إدخال البريد الإلكتروني وكلمة المرور")),
      );
      return; // إنهاء الدالة إذا كانت القيم غير صالحة
    }
    try {
      // محاولة تسجيل الدخول عبر FirebaseAuth باستخدام البريد وكلمة المرور
      UserCredential userAuth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      print(
        "verified : ${userAuth.user!.email} ",
      ); // طباعة حالة التحقق من البريد (للاختبار/التتبع)

      // جلب بيانات المستخدم من مجموعة 'users' في Firestore باستخدام الـ UID
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth.user!.uid)
          .get();
      if (!userInfo.exists) {
        DocumentSnapshot doctorInfo = await FirebaseFirestore.instance
            .collection('Doctors')
            .doc(userAuth.user!.uid)
            .get();

        if (!doctorInfo.exists) {
          throw Exception("Doctor record not found in Firestore");
        }

        role = doctorInfo['Role'];
        fullname = doctorInfo['FullName'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Doctorpage()),
        );

        return;
      }
      fullname = userInfo['FullName']; // قراءة الاسم الكامل من المستند
      role = userInfo['Role']; // قراءة الدور (Role) من المستند

      // التوجيه حسب الدور:
      if (role == "Admin") {
        // في حالة كان المستخدم أدمن، الانتقال لصفحة الأدمن
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Adminspage()),
        );
      } else if (role == "Patient") {
        // في حالة كان المستخدم مريض، الانتقال لصفحة المريض
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Patientpage()),
        );
      } else if (role == "Doctor") {
        // في حالة كان المستخدم طبيب، الانتقال لصفحة الطبيب
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Doctorpage()),
        );
      }
      // إظهار رسالة ترحيبية بعد تسجيل الدخول بنجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("مرحبا بك في عيادتنا 😝 $fullname"),
          showCloseIcon: true, // إظهار أيقونة إغلاق في الـ SnackBar
        ),
      );
    } on FirebaseAuthException catch (e) {
      // معالجة الأخطاء الخاصة بـ FirebaseAuth أثناء تسجيل الدخول
      String message = "";
      if (e.code == "user-not-found") {
        message =
            "المستخدم غير موجود"; // في حالة عدم العثور على مستخدم بهذا البريد
      } else if (e.code == "wrong-password") {
        message = "كلمة المرور غير صحيحة"; // في حالة كلمة المرور خطأ
      } else if (e.code == "invalid-email") {
        message = "البريد الإلكتروني غير صالح"; // في حالة البريد غير صالح
      } else {
        message = e.message ?? "حدث خطأ أثناء تسجيل الدخول"; // أي خطأ آخر
      }
      // إظهار رسالة الخطأ للمستخدم في واجهة التطبيق
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ $message")));
      print("Error: $e"); // طباعة الخطأ في الـ console للتتبع
    }
  }

  //-----------------------------------
  // تسجيل مستخدم جديد باستخدام البريد الإلكتروني وكلمة المرور
  Future<void> signup(
    String emailController,
    String passwordController,
    String fullnameController,
    String phoneNumberController,
    String roleController,
    BuildContext context,
  ) async {
    // تخزين القيم القادمة من الحقول في خصائص الكائن
    email = emailController;
    password = passwordController;
    fullname = fullnameController;
    phoneNumber = phoneNumberController;
    role = roleController;
    try {
      // إنشاء مستخدم جديد في FirebaseAuth باستخدام البريد وكلمة المرور
      UserCredential userinfo = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      // حفظ بيانات المستخدم في مجموعة 'users' في Cloud Firestore، والوثيقة باسم UID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userinfo.user!.uid)
          .set({
            'FullName': fullname, // الاسم الكامل
            'Email': email, // البريد الإلكتروني
            'PhoneNumber': phoneNumber, // رقم الهاتف
            'Role': role, // الدور في النظام
            'UserID': userinfo.user!.uid, // معرف المستخدم (UID)
          });

      // الانتقال لصفحة المريض بعد إنشاء الحساب بنجاح
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Patientpage()),
      );

      // إظهار رسالة نجاح عند إنشاء الحساب
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("تم إنشاء الحساب بنجاح ✅ $email")));

      print(
        "✅ patient created successfully: $email",
      ); // طباعة رسالة نجاح في الـ console
    } on FirebaseAuthException catch (e) {
      // معالجة أخطاء إنشاء الحساب في FirebaseAuth
      String message = "";
      if (e.code == "email-already-in-use") {
        message = "هذا البريد مسجل بالفعل"; // البريد مستخدم مسبقًا
      } else if (e.code == "weak-password") {
        message = "كلمة المرور ضعيفة جدًا"; // كلمة المرور ضعيفة
      } else if (e.code == "invalid-email") {
        message = "البريد الإلكتروني غير صالح"; // البريد غير صحيح الصيغة
      } else {
        message = e.message ?? "حدث خطأ أثناء إنشاء الحساب"; // أي خطأ آخر
      }

      // إظهار رسالة الخطأ في واجهة التطبيق
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ $message")));

      print("❌ Error: $message"); // طباعة نص الخطأ في الـ console
    } catch (e) {
      // معالجة أي أخطاء أخرى غير متعلقة بـ FirebaseAuth
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ غير متوقع")));
      print("❌ Error: $e"); // طباعة الخطأ العام في الـ console
    }
  }
}
