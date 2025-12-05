import 'package:flutter/material.dart'; // استيراد مكتبة واجهة المستخدم من فلاتر
import 'package:prototype1/NotificationSystemComponent/notifications.dart'; // استيراد كلاس الإشعارات/رسائل التأكيد
import 'package:prototype1/QueueManagementComponent/checkInAdmin.dart'; // استيراد صفحة/كلاس تسجيل وصول المريض (قد لا تُستخدم هنا مباشرة)
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Cloud Firestore للتعامل مع قاعدة البيانات
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Auth (غير مستخدمة حاليًا في هذه الصفحة)

class Managequeuepage extends StatefulWidget {
  const Managequeuepage({
    super.key,
  }); // ويدجت رئيسية لإدارة الطابور، من نوع Stateful لأنها تعتمد على حالة متغيرة

  @override
  State<Managequeuepage> createState() => _ManagequeuepageState(); // إنشاء الـ State المرتبط بهذه الصفحة
}

class _ManagequeuepageState extends State<Managequeuepage> {
  Notifications notify =
      Notifications(); // كائن للتعامل مع رسائل التأكيد/الإشعارات
  FirebaseFirestore queuedata = FirebaseFirestore
      .instance; // مرجع لقاعدة بيانات Firestore للتعامل مع مجموعة Queue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة الطابور للواصلين',
        ), // عنوان شريط التطبيق في أعلى الصفحة
        backgroundColor: Colors.amberAccent[200], // لون خلفية الـ AppBar
      ),
      body: SafeArea(
        // لضمان أن المحتوى لا يصطدم بمناطق آمنة في الجهاز (مثل النوتش)
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // محاذاة المحتوى في منتصف الشاشة عموديًا
          children: [
            Row(
              // صف يحتوي على ثلاثة أزرار لإدارة الطابور
              children: [
                SizedBox(width: 10), // مسافة فارغة في بداية الصف (يمين)
                ElevatedButton(
                  // الزر الأول: الرجوع بالطابور (إنقاص رقم الدور)
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // جعل حواف الزر مستديرة
                    ),
                  ),
                  onPressed: () async {
                    // عند الضغط على زر الرجوع بالطابور
                    final confirmed = await notify.showConfirmationDialog(
                      context,
                      'سيتم تقليل أرقام الدور لليوم الحالي.', // رسالة تأكيد قبل تنفيذ العملية
                    );
                    if (!confirmed) {
                      return; // إذا لم يؤكد المستخدم، لا يتم تنفيذ أي شيء
                    }

                    try {
                      // الحصول على أول مستند من مجموعة Queue
                      final snap = await queuedata
                          .collection('Queue')
                          .limit(1)
                          .get();
                      if (snap.docs.isNotEmpty) {
                        final id =
                            snap.docs.first.id; // جلب معرف الوثيقة الأولى
                        await queuedata.collection('Queue').doc(id).update({
                          'MovingLineNumber': FieldValue.increment(
                            -1,
                          ), // تقليل رقم الدور المتحرك بمقدار 1
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم الرجوع'),
                          ), // رسالة نجاح
                        );
                      }
                      /*else {
                        // في حال عدم وجود وثيقة للطابور، يمكن إنشاء واحدة جديدة (الكود معلق حاليًا)
                        await queuedata.collection('Queue').add({
                          'MovingLineNumber': 1,
                          'TodayLineNumber': 1,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم إنشاء الطابور')),
                        );
                      }*/
                    } catch (e) {
                      // في حال حدوث خطأ أثناء التعامل مع Firestore
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                    }
                  },
                  child: Column(
                    // محتوى الزر (أيقونة + نص) مرتب عموديًا
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back, // أيقونة سهم للرجوع
                        size: 100,
                        color: Colors.amberAccent[200],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "الرجوع بالطابور", // نص يصف وظيفة الزر
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ), // مسافة بين زر الرجوع وزر عرض الطابور الحالي
                ElevatedButton(
                  // الزر الثاني: عرض رقم الطابور الحالي
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // حواف دائرية للزر
                    ),
                  ),
                  onPressed: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.manage_accounts_rounded, // أيقونة لإدارة الطابور
                        size: 100,
                        color: Colors.amberAccent[200],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "الطابور الأن", // عنوان يعبر عن عرض الوضع الحالي للطابور
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),

                      // عرض الرقم الحالي للطابور من قاعدة البيانات باستخدام StreamBuilder
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Queue")
                            .limit(1) // جلب أول وثيقة فقط من مجموعة Queue
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            // في حالة عدم توفر بيانات بعد (قيد التحميل)
                            return Text(
                              "0",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                            );
                          }

                          final document = snapshot
                              .data!
                              .docs
                              .first; // جلب أول مستند (وثيقة الطابور)
                          int todayLine =
                              document["MovingLineNumber"]; // قراءة القيمة الحالية لرقم الدور المتحرك

                          return Text(
                            todayLine.toString(), // عرض رقم الدور كنص
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ), // مسافة بين زر الطابور الحالي وزر التقدم بالطابور
                ElevatedButton(
                  // الزر الثالث: التقدم بالطابور (زيادة رقم الدور)
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // حواف مستديرة
                    ),
                  ),
                  onPressed: () async {
                    // عند الضغط على زر التقدم بالطابور
                    final confirmed = await notify.showConfirmationDialog(
                      context,
                      'سيتم تقدم أرقام الدور لليوم الحالي.', // رسالة تأكيد قبل تنفيذ العملية
                    );
                    if (!confirmed) {
                      return; //اذا لم يؤكد المستخدم، لا تفعل شيئًا
                    }
                    try {
                      // جلب أول مستند من مجموعة Queue
                      final snap = await queuedata
                          .collection('Queue')
                          .limit(1)
                          .get();
                      if (snap.docs.isNotEmpty) {
                        final id = snap.docs.first.id; // معرف الوثيقة الأولى
                        await queuedata.collection('Queue').doc(id).update({
                          'MovingLineNumber': FieldValue.increment(
                            1,
                          ), // زيادة رقم الدور المتحرك بمقدار 1
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم التقدم'),
                          ), // رسالة نجاح عند التقدم
                        );
                      }
                      /*else {
                        // في حال عدم وجود وثيقة للطابور، يمكن إنشاء واحدة جديدة (الكود معلق حاليًا)
                        await queuedata.collection('Queue').add({
                          'MovingLineNumber': 1,
                          'TodayLineNumber': 1,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم إنشاء الطابور')),
                        );
                      }*/
                    } catch (e) {
                      // في حال حدوث خطأ أثناء التحديث في Firestore
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward, // أيقونة سهم للتقدم
                        size: 100,
                        color: Colors.amberAccent[200],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "التقدم بالطابور", // نص يصف وظيفة الزر
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
