import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointmentsPages.dart';
import 'editAppointmentPage.dart';
import 'adminQueuePage.dart';

class AdminPatientAppointmentsPage extends StatefulWidget {
  final String
  patientId; // معرّف المريض المستخدم لجلب مواعيده من قاعدة البيانات
  final String patientName; // اسم المريض لعرضه في الواجهة
  final String patientPhone; // رقم هاتف المريض (قد يستخدم لاحقاً)

  const AdminPatientAppointmentsPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
  });

  @override
  State<AdminPatientAppointmentsPage> createState() =>
      _AdminPatientAppointmentsPageState();
}

class _AdminPatientAppointmentsPageState
    extends State<AdminPatientAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments: ${widget.patientName}"),
        // عرض اسم المريض في شريط العنوان
        backgroundColor: Colors.amberAccent[200],
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt), // زر الانتقال إلى صفحة الطابور العام
            tooltip: "Go to General Queue",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QueuePage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Appointment", // زر إضافة موعد جديد للمريض
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Appointmentspage(patientId: widget.patientId),
            ),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Appointments')
            .where('userId', isEqualTo: widget.patientId)
            .snapshots(),
        // الاستماع المباشر لمواعيد المريض من قاعدة البيانات
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
            // عرض خطأ في حال فشل جلب البيانات
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
            // إظهار مؤشر تحميل حتى وصول البيانات
          }

          var docs = snapshot.data!.docs; // قائمة المواعيد المسترجعة

          if (docs.isEmpty) {
            return Center(
              child: Text("No appointments for ${widget.patientName}"),
            );
            // رسالة في حال عدم وجود مواعيد
          }

          return ListView.builder(
            itemCount: docs.length, // عدد المواعيد
            itemBuilder: (context, index) {
              final doc = docs[index]; // وثيقة الموعد
              final data =
                  doc.data() as Map<String, dynamic>; // استخراج بياناتها

              final day = data['day'] ?? '-'; // يوم الموعد
              final time = data['time'] ?? '-'; // وقت الموعد
              final token = data['token'] ?? '-'; // رقم التوكن
              final status = data['status'] ?? '-'; // حالة الموعد
              final doctorId =
                  data['doctorId'] ?? '-'; // معرّف الطبيب المرتبط بالموعد

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                // تنسيق بطاقة عرض الموعد
                child: ListTile(
                  title: Text("Day: $day  •  Time: $time"),
                  // عرض اليوم والوقت
                  subtitle: Text("Token: $token  •  Status: $status"),
                  // عرض رقم التوكن والحالة
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        // زر تعديل الموعد
                        tooltip: "Edit Appointment",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAppointmentPage(
                                appointmentId: doc.id, // تمرير معرّف الموعد
                                currentDay: day, // تمرير اليوم الحالي للموعد
                                currentTime: time, // تمرير الوقت الحالي للموعد
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        // زر حذف الموعد
                        tooltip: "Delete Appointment",
                        onPressed: () async {
                          bool confirmed = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Confirm Delete"),
                              // تأكيد الحذف
                              content: Text(
                                "Are you sure you want to delete this appointment?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text("Cancel"), // إلغاء الحذف
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text("Delete"), // تأكيد الحذف
                                ),
                              ],
                            ),
                          );
                          if (confirmed) {
                            await FirebaseFirestore.instance
                                .collection('Appointments')
                                .doc(doc.id)
                                .delete();
                            // تنفيذ عملية الحذف

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Appointment deleted")),
                              // رسالة نجاح الحذف
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
