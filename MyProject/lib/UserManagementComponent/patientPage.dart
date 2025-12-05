import 'package:flutter/material.dart';
import 'package:prototype1/AppointmentManagementComponent/appointmentPage.dart';
import 'package:prototype1/FormManagementComponent/formPage.dart';
import 'package:prototype1/NotificationSystemComponent/notifications.dart';
import 'package:prototype1/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Patientpage extends StatefulWidget {
  const Patientpage({
    super.key,
  }); // ويدجت رئيسية لواجهة المريض، من نوع Stateful لأنها تعتمد على حالة تتغير (التنقل بين الصفحات)

  @override
  State<Patientpage> createState() => _PatientpageState(); // إنشاء الحالة المرتبطة بويدجت Patientpage
}

class _PatientpageState extends State<Patientpage> {
  Notifications notify =
      Notifications(); // كائن للتعامل مع رسائل التأكيد أو الإشعارات
  int i = 0; // متغير لحفظ رقم الصفحة الحالية في الـ BottomNavigationBar

  // الصفحات البسيطة التي يمكن للمريض التنقل بينها
  final List<Widget> _pages = [
    Appointmentpage(), // صفحة إدارة وعرض المواعيد الخاصة بالمريض
    Formpage(), // صفحة النماذج (مثل نماذج التأمين أو التاريخ المرضي)
    Center(
      child: Text('الملف الشخصي'),
    ), // صفحة بسيطة placeholder لملف المريض الشخصي
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إدارة المواعيد"), // عنوان شريط التطبيق في الأعلى
        backgroundColor: Colors.amberAccent[200], // لون الخلفية لشريط التطبيق
        automaticallyImplyLeading:
            false, // إلغاء زر الرجوع الافتراضي من الـ AppBar
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
            ), // مسافة أفقية حول زر تسجيل الخروج
            child: IconButton(
              onPressed: () async {
                // عند الضغط على زر "تسجيل خروج"
                final confirmed = await notify.showConfirmationDialog(
                  context,
                  'سيتم تسجيل الخروج من حسابك الحالي.', // رسالة تأكيد قبل تسجيل الخروج
                );
                if (!confirmed)
                  return; // إذا لم يؤكد المستخدم، يتم إلغاء العملية

                await FirebaseAuth.instance
                    .signOut(); // تسجيل خروج المستخدم من حساب FirebaseAuth

                // الانتقال إلى صفحة HomePage مع إزالة جميع الصفحات السابقة من الـ navigator stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                  (route) =>
                      false, // إرجاع false يعني حذف جميع المسارات السابقة
                );
              },
              icon: Text("تسجيل خروج"), // نص الزر في الـ AppBar بدل الأيقونة
            ),
          ),
        ],
      ),
      body: _pages[i], // عرض الصفحة الحالية حسب قيمة i في قائمة الصفحات
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: i, // تحديد العنصر الحالي في شريط التنقل السفلي
        onTap: (index) {
          // عند الضغط على أيقونة في الـ BottomNavigationBar
          setState(() {
            i = index; // تغيير الصفحة المعروضة عن طريق تغيير قيمة i
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), // أيقونة صفحة المواعيد
            label: 'مواعيدي', // نص يظهر أسفل الأيقونة
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment), // أيقونة صفحة النماذج
            label: 'نماذجي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // أيقونة صفحة الملف الشخصي
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
}
