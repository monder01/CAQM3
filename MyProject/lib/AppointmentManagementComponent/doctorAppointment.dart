import 'package:flutter/material.dart'; // استيراد مكونات واجهة المستخدم من فلاتر
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة التعامل مع Cloud Firestore
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة المصادقة من Firebase للحصول على المستخدم الحالي
import '/AppointmentManagementComponent/teleconsultationPage.dart'; // استيراد صفحة الاستشارة عن بعد

class Doctorappointment extends StatefulWidget {
  const Doctorappointment({super.key}); // ويدجت تمثل صفحة "مواعيدي كطبيب"

  @override
  State<Doctorappointment> createState() => _DoctorappointmentState(); // ربط الودجت بحالتها
}

class _DoctorappointmentState extends State<Doctorappointment> {
  final String currentDoctorId = FirebaseAuth
      .instance
      .currentUser!
      .uid; // جلب معرف الطبيب الحالي (المسجل دخولاً)
  final String? currentDoctorEmail = FirebaseAuth
      .instance
      .currentUser!
      .email; // جلب البريد الإلكتروني للطبيب الحالي (إن وجد)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مواعيدي كطبيب"), // عنوان الصفحة في الشريط العلوي
        backgroundColor: Colors.amberAccent[200], // لون خلفية الـ AppBar
      ),

      // الجسم الرئيسي للصفحة يحتوي على StreamBuilder لعرض المواعيد من Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Appointments")
            .where("doctorId", isEqualTo: currentDoctorId)
            .snapshots(), // جلب كل المواعيد التي يكون فيها doctorId هو الطبيب الحالي

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // في حال لم تصل البيانات بعد من Firestore
            return Center(child: CircularProgressIndicator());
          }

          final docs =
              snapshot.data!.docs; // قائمة المستندات (المواعيد) التي تم جلبها

          if (docs.isEmpty) {
            // في حال لا توجد مواعيد للطبيب
            return Center(
              child: Text(
                "لا توجد مواعيد حالياً",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          // عرض المواعيد في ListView
          return ListView.builder(
            itemCount: docs.length, // عدد العناصر في القائمة يساوي عدد المواعيد
            itemBuilder: (context, index) {
              final doc = docs[index]; // الموعد الحالي

              return Card(
                // كل موعد داخل Card لعرضه بشكل منسّق
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today, // أيقونة تمثل الموعد/التقويم
                    color: Colors.amber,
                    size: 35,
                  ),

                  title: Text(
                    "المريض: ${doc['patientName']}",
                  ), // عرض اسم المريض

                  subtitle: Text(
                    // عرض تفاصيل التاريخ، الوقت، نوع الموعد والتكلفة
                    "التاريخ: ${doc['date']} - الوقت: ${doc['time']}\n"
                    "النوع: ${doc['appointmentType']} - التكلفة: \$${doc['cost']}",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize
                        .min, // جعل الـ Row يأخذ أقل مساحة ممكنة أفقيًا
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.confirmation_num,
                        color: Colors.blue,
                      ), // أيقونة تمثل رقم التذكرة/الدور
                      Text(
                        "الدور: ${doc['LineNumber']}", // عرض رقم الدور الخاص بهذا الموعد
                        style: TextStyle(fontSize: 12),
                      ),
                      // إذا كان نوع الموعد "إستشارة" نعرض زر لبدء جلسة استشارة عن بعد
                      if (doc['appointmentType'] == 'إستشارة')
                        IconButton(
                          onPressed: () {
                            // الانتقال لصفحة الاستشارة عن بعد مع تمرير بريد واسم المريض
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Teleconsultationpage(
                                  otherUserEmail:
                                      doc['email'], // بريد المريض (مستقبل الرسائل)
                                  otherUserName:
                                      doc['patientName'], // اسم المريض
                                ),
                              ),
                            );
                          },
                          icon: Text(
                            "Start Session",
                          ), // نص بسيط كزر لبدء الجلسة
                        ),
                    ],
                  ),

                  onTap: () {
                    // يمكن هنا لاحقًا إضافة التنقل لصفحة تفاصيل الموعد
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
