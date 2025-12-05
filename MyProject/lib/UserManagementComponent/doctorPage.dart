import 'package:prototype1/NotificationSystemComponent/notifications.dart';
import 'package:prototype1/UserManagementComponent/doctorAppointment.dart';
import 'package:prototype1/homePage.dart';

import 'users.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Doctorpage extends StatefulWidget {
  const Doctorpage({super.key});

  @override
  State<Doctorpage> createState() => _DoctorpageState();
}

class _DoctorpageState extends State<Doctorpage> {
  Notifications notify =
      Notifications(); // كائن للتعامل مع رسائل التأكيد/الإشعارات
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صفحة الطبيب"), // عنوان شريط التطبيق في الأعلى
        backgroundColor: Colors.amberAccent[200], // لون خلفية شريط التطبيق
        automaticallyImplyLeading:
            false, // إلغاء زر الرجوع الافتراضي من شريط التطبيق
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
            ), // مسافة أفقية حول زر تسجيل الخروج
            child: IconButton(
              onPressed: () async {
                // عند الضغط على زر تسجيل الخروج
                final confirmed = await notify.showConfirmationDialog(
                  context,
                  'سيتم تسجيل الخروج من حسابك الحالي.', // رسالة تأكيد قبل تسجيل الخروج
                );
                if (!confirmed) return; // إذا المستخدم لم يؤكد، يتم الإلغاء

                await FirebaseAuth.instance
                    .signOut(); // تسجيل خروج المستخدم من FirebaseAuth

                // الانتقال إلى صفحة الـ Homepage وحذف كل الصفحات السابقة من الـ stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                  (route) => false, // إرجاع false يعني حذف كل المسارات السابقة
                );
              },
              icon: Text("تسجيل خروج"), // نص الزر داخل الـ AppBar (بدل أيقونة)
            ),
          ),
        ],
      ), // عنوان شريط التطبيق

      body: Center(
        // وضع المحتوى في الوسط
        child: Padding(
          padding: const EdgeInsets.all(8.0), // إضافة مسافة حول المحتوى
          child: GridView.count(
            crossAxisCount: 2, // عدد الأعمدة في الشبكة = 2
            crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
            mainAxisSpacing: 10, // المسافة العمودية بين العناصر
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // زوايا ناعمة للزر
                  ),
                ),
                onPressed: () {
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Doctorappointment(),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // محاذاة المحتوى عمودياً في الوسط
                  children: [
                    Icon(
                      Icons.person_search, // أيقونة الزر
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'مشاهدة مواعيدي', // وصف الزر
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
