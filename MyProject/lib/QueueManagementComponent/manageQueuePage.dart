//manageQueuePage.dart
import 'package:flutter/material.dart'; // استيراد مكتبة واجهة المستخدم من فلاتر
import '/NotificationSystemComponent/notifications.dart'; // استيراد كلاس الإشعارات/رسائل التأكيد
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Cloud Firestore للتعامل مع قاعدة البيانات

class Managequeuepage extends StatefulWidget {
  const Managequeuepage({super.key}); // ويدجت رئيسية لإدارة الطابور

  @override
  State<Managequeuepage> createState() => _ManagequeuepageState();
}

class _ManagequeuepageState extends State<Managequeuepage> {
  Notifications notify =
      Notifications(); // كائن للتعامل مع رسائل التأكيد/الإشعارات
  FirebaseFirestore queuedata =
      FirebaseFirestore.instance; // مرجع لقاعدة بيانات Firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطابور للواصلين'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // محاذاة المحتوى في منتصف الشاشة عموديًا
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // محاذاة العناصر في منتصف الصف
              children: [
                const SizedBox(width: 10),

                // زر الرجوع بالطابور
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      final confirmed = await notify.showConfirmationDialog(
                        context,
                        'سيتم تقليل أرقام الدور لليوم الحالي.',
                      );
                      if (!confirmed) return;

                      try {
                        final snap = await queuedata
                            .collection('Queue')
                            .limit(1)
                            .get();

                        if (snap.docs.isNotEmpty) {
                          final doc = snap.docs.first;
                          final id = doc.id;
                          final current = (doc['MovingLineNumber'] ?? 0) as int;

                          if (current > 0) {
                            await queuedata.collection('Queue').doc(id).update({
                              'MovingLineNumber': FieldValue.increment(
                                -1,
                              ), // إنقاص الدور
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم الرجوع')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'لا يمكن الرجوع أكثر، رقم الدور الآن 0',
                                ),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          size: 100,
                          color: Colors.amberAccent,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "الرجوع بالطابور",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // زر عرض الطابور الحالي
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.manage_accounts_rounded,
                          size: 100,
                          color: Colors.amberAccent,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "الطابور الأن",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Queue")
                              .limit(1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              );
                            }
                            final document = snapshot.data!.docs.first;
                            int movingLine = document["MovingLineNumber"] ?? 0;
                            return Text(
                              movingLine.toString(),
                              style: const TextStyle(
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
                ),

                const SizedBox(width: 10),

                // زر التقدم بالطابور
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      final confirmed = await notify.showConfirmationDialog(
                        context,
                        'سيتم تقدم أرقام الدور لليوم الحالي.',
                      );
                      if (!confirmed) return;

                      try {
                        final snap = await queuedata
                            .collection('Queue')
                            .limit(1)
                            .get();
                        if (snap.docs.isNotEmpty) {
                          final id = snap.docs.first.id;
                          await queuedata.collection('Queue').doc(id).update({
                            'MovingLineNumber': FieldValue.increment(
                              1,
                            ), // زيادة الدور
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم التقدم')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.arrow_forward,
                          size: 100,
                          color: Colors.amberAccent,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "التقدم بالطابور",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
