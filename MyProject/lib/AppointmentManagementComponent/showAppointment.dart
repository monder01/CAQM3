import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype1/NotificationSystemComponent/notifications.dart';
import 'teleconsultationPage.dart';

class Showappointment extends StatefulWidget {
  const Showappointment({super.key, this.patientIdd});
  final String?
  patientIdd; // معرف المريض (اختياري) يُمرر من صفحة الأدمن عند إدارة مواعيد مريض معين

  @override
  State<Showappointment> createState() => _ShowappointmentState(); // إنشاء الحالة المرتبطة بهذه الصفحة
}

class _ShowappointmentState extends State<Showappointment> {
  Notifications notify = Notifications(); // كائن لإظهار مربعات حوار التأكيد
  final currentUserId = FirebaseAuth
      .instance
      .currentUser!
      .uid; // معرف المستخدم الحالي المسجل دخول
  final currentUserEmail = FirebaseAuth
      .instance
      .currentUser!
      .email; // بريد المستخدم الحالي (غير مستخدم هنا مباشرة)
  String?
  currentUser; // لتحديد المريض الذي سيتم عرض مواعيده (إما من الأدمن أو من المستخدم الحالي)

  String? currentEmail; // متغير يمكن استخدامه لاحقاً للبريد (غير مستخدم حاليًا)

  @override
  void initState() {
    super.initState();
    // تحديد هوية المريض: إذا تم تمرير patientIdd من الأدمن يتم استخدامه، وإلا يتم استخدام المستخدم الحالي
    if (widget.patientIdd != null) {
      currentUser = widget.patientIdd;
    } else {
      currentUser = currentUserId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مواعيدي'), // عنوان الصفحة في شريط التطبيق
        backgroundColor: Colors.amberAccent[200], // لون خلفية شريط التطبيق
      ),
      body: Column(
        children: [
          // شريط علوي بسيط لعرض رقم الطابور الحالي
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // محاذاة العناصر في منتصف الصف
            children: [
              Icon(
                Icons.move_down,
                color: Colors.blueAccent,
                size: 50,
              ), // أيقونة للإشارة للحركة في الطابور

              SizedBox(width: 20),
              // عرض رقم الطابور الحالي من مجموعة Queue
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Queue")
                    .limit(1)
                    .snapshots(), // الاستماع لأول مستند في مجموعة Queue بشكل لحظي
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    // في حالة عدم وصول بيانات بعد
                    return Text(
                      "0",
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    );
                  }

                  final document =
                      snapshot.data!.docs.first; // جلب أول وثيقة من المجموعة
                  int todayLine =
                      document["MovingLineNumber"]; // قراءة رقم الدور الحالي من الحقل MovingLineNumber

                  return Text(
                    todayLine.toString(), // عرض رقم الطابور الحالي كنص
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              SizedBox(width: 20),
              Text(
                "الطابور الان ", // وصف نصي لرقم الطابور
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // الجزء الأساسي لعرض قائمة المواعيد
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // الاستماع لمجموعة Appointments وعرض المواعيد الخاصة بالمريض الحالي
              stream: FirebaseFirestore.instance
                  .collection('Appointments')
                  .where('patientId', isEqualTo: currentUser)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // في حالة تحميل البيانات
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs; // قائمة المواعيد

                if (docs.isEmpty) {
                  // في حال لم توجد مواعيد للمريض
                  return Center(child: Text("لا توجد مواعيد"));
                }

                // بناء قائمة المواعيد في ListView
                return ListView.builder(
                  itemCount: docs.length, // عدد المواعيد
                  itemBuilder: (context, index) {
                    final doc = docs[index]; // الموعد الحالي

                    return Card(
                      // كرت لكل موعد
                      child: ListTile(
                        minLeadingWidth: 50, // أقل عرض للمساحة أمام الـ leading
                        leading: Icon(
                          Icons.schedule_sharp, // أيقونة تمثل موعد/جدول
                          color: Colors.amber,
                          size: 40,
                        ),
                        title: Text(
                          "الطبيب: ${doc['doctorName']}",
                        ), // عرض اسم الطبيب
                        subtitle: Text(
                          // عرض تفاصيل التاريخ، الوقت، نوع الموعد والتكلفة
                          "التاريخ: ${doc['date']} - الوقت: ${doc['time']} \nالنوع: ${doc['appointmentType']} - التكلفة: \$${doc['cost']}",
                        ),
                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min, // جعل الصف يأخذ أقل مساحة ممكنة
                          children: [
                            // عرض رقم الدور الخاص بهذا الموعد
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.confirmation_num,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "الدور : ${doc['LineNumber']}", // رقم دور المريض في الطابور
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            // زر لحذف الموعد (إلغاء الحجز)
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // تأكيد إلغاء الموعد
                                final confirmed = await notify
                                    .showConfirmationDialog(
                                      context,
                                      'هل أنت متأكد من إلغاء هذا الموعد؟',
                                    );
                                if (!confirmed)
                                  return; // في حال عدم التأكيد لا يتم تنفيذ شيء
                                await FirebaseFirestore.instance
                                    .collection('Appointments')
                                    .doc(doc.id)
                                    .delete(); // حذف الموعد من قاعدة البيانات
                              },
                            ),
                            // زر لتأكيد الوصول (تغيير حالة الموعد إلى WaitingToCheckIn)
                            IconButton(
                              onPressed: () async {
                                final confirmed = await notify
                                    .showConfirmationDialog(
                                      context,
                                      'هل أنت متأكد من تأكيد وصولك؟',
                                    );
                                if (!confirmed) return;
                                await FirebaseFirestore.instance
                                    .collection('Appointments')
                                    .doc(doc.id)
                                    .update({'status': 'WaitingToCheckIn'});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("في تأكيد الوصول. ")),
                                );
                              },

                              icon: Icon(
                                Icons.check,
                                color: Colors.purpleAccent,
                              ),
                            ),
                            // زر بدء جلسة استشارة عن بعد (Teleconsultation) إذا كان نوع الموعد "إستشارة"
                            if (doc['appointmentType'] == 'إستشارة')
                              IconButton(
                                onPressed: () {
                                  // الانتقال لصفحة الاستشارة عن بعد مع تمرير بريد واسم الطبيب
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Teleconsultationpage(
                                            otherUserEmail: doc['doctorEmail'],
                                            otherUserName: doc['doctorName'],
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
