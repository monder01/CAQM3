import 'dart:async';

import 'package:MyCAQM/NotificationSystemComponent/notifiables.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/NotificationSystemComponent/notifications.dart';
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
  late Timer reminderTimer; // مؤقت لتكرار التحقق من التذكير
  int? currentLineNumber;
  int? userLineNumber;
  Notifiables notifiable = Notifiables();

  @override
  void initState() {
    super.initState();
    // تحديد هوية المريض: إذا تم تمرير patientIdd من الأدمن يتم استخدامه، وإلا يتم استخدام المستخدم الحالي
    if (widget.patientIdd != null) {
      currentUser = widget.patientIdd;
    } else {
      currentUser = currentUserId;
    }
    // بدء مؤقت للتحقق من التذكير كل دقيقة
    reminderTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      print("currentline: $currentLineNumber , userline: $userLineNumber");
      notifiable.receiveReminder(
        context,
        currentUser!,
        currentLineNumber,
        userLineNumber,
      );
    });
  }

  @override
  void dispose() {
    // إيقاف المؤقت فوراً عند مغادرة الصفحة لمنع استدعاء context لاحقاً
    reminderTimer.cancel();
    super.dispose();
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
            mainAxisSize: MainAxisSize.min,
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
                  currentLineNumber = todayLine;

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
                    userLineNumber = doc['LineNumber'];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // الصف الأول: الأيقونة + نصوص الموعد
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.schedule_sharp,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "الطبيب: ${doc['doctorName']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "التاريخ: ${doc['date']} - الوقت: ${doc['time']}\n"
                                        "النوع: ${doc['appointmentType']} - التكلفة: \$${doc['cost']}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // الصف الثاني: الأزرار (الدور + حذف + تأكيد + Start Session)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // رقم الدور
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.confirmation_num,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "الدور : ${doc['LineNumber']}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),

                                // زر حذف الموعد
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirmed = await notify
                                        .showConfirmationDialog(
                                          context,
                                          'هل أنت متأكد من إلغاء هذا الموعد؟',
                                        );
                                    if (!confirmed) return;
                                    await FirebaseFirestore.instance
                                        .collection('Appointments')
                                        .doc(doc.id)
                                        .delete();
                                  },
                                ),

                                // زر تأكيد الوصول
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.purpleAccent,
                                  ),
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
                                      const SnackBar(
                                        content: Text(
                                          "تم إرسال طلب تأكيد الوصول.",
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // زر Start Session لو الموعد استشارة
                                if (doc['appointmentType'] == 'إستشارة')
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Teleconsultationpage(
                                                otherUserEmail:
                                                    doc['doctorEmail'],
                                                otherUserName:
                                                    doc['doctorName'],
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Text("Start Session"),
                                  ),
                              ],
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
