import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'editAppointmentPage.dart';
import 'appointmentsPages.dart';
import '../forms/formpage.dart';

// صفحة عرض كل المواعيد الخاصة بالمستخدم
class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({super.key});

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  @override
  Widget build(BuildContext context) {
    // الحصول على المستخدم الحالي من Firebase Auth
    User? currentUser = FirebaseAuth.instance.currentUser;

    // في حالة لم يقم المستخدم بتسجيل الدخول
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text("My Appointments")),
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
        backgroundColor: Colors.amberAccent[200], // لون شريط العنوان
      ),

      // StreamBuilder للاستماع إلى التغييرات في مجموعة Appointments
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .where(
              'userId',
              isEqualTo: currentUser.uid,
            ) // إحضار مواعيد المستخدم فقط
            .snapshots(),
        builder: (context, snapshot) {
          // في حالة وجود خطأ في جلب البيانات
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // أثناء تحميل البيانات
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var appointments = snapshot.data!.docs;

          // إذا لا توجد مواعيد
          if (appointments.isEmpty) {
            return Center(child: Text("No Appointments Yet"));
          }

          // عرض قائمة المواعيد
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index];
              final data = appointment.data() as Map<String, dynamic>;

              // قراءة بيانات الموعد
              final token = data['token'] ?? '-';
              final status = data['status'] ?? '-';
              final doctorId = data['doctorId'] ?? '';

              // تحديد هل هذا هو أقرب موعد قادم (pending)
              bool isNext =
                  status == 'pending' &&
                  !appointments.take(index).any((d2) {
                    final m = d2.data() as Map<String, dynamic>;
                    return m['status'] == 'pending';
                  });

              // جلب بيانات الدكتور المرتبط بالموعد
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Doctors')
                    .doc(doctorId)
                    .get(),
                builder: (context, doctorSnapshot) {
                  // أثناء تحميل بيانات الدكتور
                  if (!doctorSnapshot.hasData) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(title: Text("Loading doctor...")),
                    );
                  }

                  var doctorData = doctorSnapshot.data!;
                  String doctorName =
                      doctorData['Full Name'] ??
                      'Unknown Doctor'; // اسم الدكتور

                  // تصميم بطاقة عرض الموعد
                  return Card(
                    color: isNext
                        ? Colors.green[50]
                        : null, // تمييز الموعد الأقرب
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('$token'),
                      ), // رقم الترتيب
                      title: Text("Doctor: $doctorName"),
                      subtitle: Text(
                        "Day: ${data['day']}\nTime: ${data['time']}\nStatus: $status",
                      ),

                      // أزرار التعديل والحذف
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // زر تعديل الموعد
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditAppointmentPage(
                                    appointmentId: appointment.id,
                                    currentDay: data['day'],
                                    currentTime: data['time'],
                                  ),
                                ),
                              );
                            },
                          ),

                          // زر حذف الموعد
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('Appointments')
                                  .doc(appointment.id)
                                  .delete(); // حذف الموعد

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("🗑️ Appointment deleted"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),

      // زر إضافة موعد جديد + الوصول لصفحة الفورم
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        children: [
          // إضافة موعد جديد
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Add Appointment",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Appointmentspage()),
            ),
          ),

          // الذهاب لصفحة الفورم
          SpeedDialChild(
            child: Icon(Icons.note_add),
            label: "Form Page",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Formpage()),
            ),
          ),
        ],
      ),
    );
  }
}
