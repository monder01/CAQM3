// users.dart
import 'package:flutter/material.dart'; // استيراد مكتبة فلاتر لبناء الواجهات
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة المصادقة من Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة التعامل مع Cloud Firestore
import '/UserManagementComponent/adminsPage.dart'; // استيراد صفحة الأدمن
import '/UserManagementComponent/doctorPage.dart';
import '/UserManagementComponent/patientPage.dart'; // استيراد صفحة المريض

class UserC {
  String? fullname;
  String? email;
  String? phoneNumber;
  String? role;
  String? userId;
  String? password;

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  UserC({
    this.fullname,
    this.email,
    this.phoneNumber,
    this.role,
    this.userId,
    this.password,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : auth = auth ?? FirebaseAuth.instance,
       firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> signin(
    String emailcontroller,
    String passwordcontroller,
    BuildContext context,
  ) async {
    email = emailcontroller;
    password = passwordcontroller;

    if (email == null || password == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى إدخال البريد الإلكتروني وكلمة المرور"),
        ),
      );
      return;
    }

    try {
      final userAuth = await auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      final userInfo = await firestore
          .collection('users')
          .doc(userAuth.user!.uid)
          .get();

      if (!userInfo.exists) {
        final doctorInfo = await firestore
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
          MaterialPageRoute(builder: (_) => Doctorpage()),
        );
        return;
      }

      fullname = userInfo['FullName'];
      role = userInfo['Role'];

      if (role == "Admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Adminspage()),
        );
      } else if (role == "Patient") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Patientpage()),
        );
      } else if (role == "Doctor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Doctorpage()),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("مرحبا بك في عيادتنا  $fullname"),
          showCloseIcon: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == "user-not-found") {
        message = "المستخدم غير موجود";
      } else if (e.code == "wrong-password") {
        message = "كلمة المرور غير صحيحة";
      } else if (e.code == "invalid-email") {
        message = "البريد الإلكتروني غير صالح";
      } else {
        message = e.message ?? "حدث خطأ أثناء تسجيل الدخول";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ $message")));
    }
  }

  Future<void> signup(
    String emailController,
    String passwordController,
    String fullnameController,
    String phoneNumberController,
    String roleController,
    BuildContext context,
  ) async {
    email = emailController;
    password = passwordController;
    fullname = fullnameController;
    phoneNumber = phoneNumberController;
    role = roleController;

    try {
      final userinfo = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      await firestore.collection('users').doc(userinfo.user!.uid).set({
        'FullName': fullname,
        'Email': email,
        'PhoneNumber': phoneNumber,
        'Role': role,
        'UserID': userinfo.user!.uid,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Patientpage()),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("تم إنشاء الحساب بنجاح ✅ $email")));
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == "email-already-in-use") {
        message = "هذا البريد مسجل بالفعل";
      } else if (e.code == "weak-password") {
        message = "كلمة المرور ضعيفة جدًا";
      } else if (e.code == "invalid-email") {
        message = "البريد الإلكتروني غير صالح";
      } else {
        message = e.message ?? "حدث خطأ أثناء إنشاء الحساب";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ $message")));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("حدث خطأ غير متوقع")));
    }
  }
}
