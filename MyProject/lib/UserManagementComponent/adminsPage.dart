import 'package:flutter/material.dart';
import '/NotificationSystemComponent/notifications.dart';
import '/UserManagementComponent/addDoctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/UserManagementComponent/findPatient.dart';
import '/homePage.dart';
import '/QueueManagementComponent/queuePage.dart';

class Adminspage extends StatefulWidget {
  const Adminspage({
    super.key,
  }); // ويدجت تمثل صفحة الأدمن، من نوع Stateful لأنها تتغير مع التنقل بين الصفحات

  @override
  State<Adminspage> createState() => _AdminspageState(); // إنشاء حالة (State) مرتبطة بهذه الصفحة
}

class _AdminspageState extends State<Adminspage> {
  int i = 0; // متغير لحفظ رقم الصفحة الحالية في الـ BottomNavigationBar
  Notifications notify =
      Notifications(); // كائن للتعامل مع رسائل التأكيد/الإشعارات

  // الصفحات البسيطة التي سيتم التنقل بينها عن طريق الـ BottomNavigationBar
  final List<Widget> _pages = [FindPatient(), Adddoctor(), Queuepage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admins Page"), // عنوان شريط التطبيق في الأعلى
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
      body:
          _pages[i], // عرض الصفحة الحالية بناءً على الـ index المختار من الـ BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: i, // تحديد أيقونة الصفحة الحالية
        onTap: (index) {
          // عند الضغط على عنصر من عناصر الـ BottomNavigationBar
          setState(() {
            i = index; // تغيير قيمة i لتغيير الصفحة المعروضة
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search), // أيقونة إدارة مواعيد المرضى
            label: 'إدارة مواعيد المرضى', // النص أسفل الأيقونة
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add), // أيقونة إضافة طبيب
            label: 'إضافة طبيب', // النص أسفل الأيقونة
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_queue), // أيقونة إدارة الطابور
            label: 'إدارة الطابور', // النص أسفل الأيقونة
          ),
        ],
      ),
    );
  }
}
