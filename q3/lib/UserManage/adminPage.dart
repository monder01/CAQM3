import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:q3/AppointmentManage/AdminFindPatientPage.dart';
import 'package:q3/Queue/adminQueuePage.dart';
import 'addDoctorPage.dart';
import 'doctors.dart';
import 'users.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  // كائن يمثل بيانات المستخدم العام (قد يُستخدم للوصول إلى معلومات أو وظائف خاصة بالمستخدمين)
  Users user = Users();

  // كائن يمثل بيانات الأطباء (يُستخدم للتعامل مع عمليات إضافة أو إدارة الأطباء)
  Doctors doctor = Doctors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // شريط التطبيق العلوي ويحتوي على عنوان الصفحة
      appBar: AppBar(
        title: Text("Admin Page"),
        backgroundColor: Colors.amberAccent[200],
      ),

      // جسم الصفحة ويعرض رسالة ترحيبية للمسؤول
      body: Center(
        child: Text(
          "Welcome, Admin!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),

      // زر عائم من نوع SpeedDial يتيح عرض عدة خيارات عند الضغط عليه
      floatingActionButton: SpeedDial(
        icon: Icons.menu, // أيقونة الزر في حالته العادية
        activeIcon: Icons.close, // الأيقونة عند فتح القائمة
        backgroundColor: Colors.amberAccent[200], // لون خلفية الزر
        overlayColor: Colors.black, // لون الخلفية الشفافة أثناء فتح القائمة
        overlayOpacity: 0.5, // درجة شفافية الغطاء عند الفتح
        spacing: 10, // المسافة بين عناصر القائمة
        spaceBetweenChildren: 10, // المسافة العمودية بين خيارات سبيد دايل
        children: [
          // خيار لإضافة طبيب جديد
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Add Doctor",
            backgroundColor: Colors.blueAccent,
            onTap: () {
              // الانتقال إلى صفحة إضافة طبيب
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Adddoctorpage()),
              );
            },
          ),

          // خيار لإدارة مواعيد المرضى
          SpeedDialChild(
            child: Icon(Icons.manage_history),
            label: "Manage Appointments",
            backgroundColor: Colors.amberAccent,
            onTap: () {
              // الانتقال إلى صفحة البحث عن مريض لإدارة مواعيده
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminFindPatientPage()),
              );
            },
          ),

          // خيار لإدارة الطابور العام في النظام
          SpeedDialChild(
            child: Icon(Icons.queue),
            label: "Manage Queue",
            backgroundColor: Colors.redAccent,
            onTap: () {
              // الانتقال إلى صفحة الطابور
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QueuePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
