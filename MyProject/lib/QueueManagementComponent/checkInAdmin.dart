import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Cloud Firestore للتعامل مع قاعدة البيانات السحابية
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة Firebase Auth للحصول على المستخدم الحالي
import 'package:flutter/material.dart'; // استيراد مكتبة الواجهات في فلاتر
import '/NotificationSystemComponent/notifications.dart'; // استيراد كلاس الإشعارات/رسائل التأكيد
import '/QueueManagementComponent/queues.dart'; // استيراد كلاس إدارة الطوابير QueueL

class Checkinadmin extends StatefulWidget {
  const Checkinadmin({super.key});
  //add later uid for the patient not the user  // ملاحظة: إضافة لاحقًا uid خاص بالمريض وليس المستخدم

  @override
  State<Checkinadmin> createState() => _CheckinadminState(); // ربط الويدجت بالحالة الخاصة بها
}

class _CheckinadminState extends State<Checkinadmin> {
  FirebaseFirestore queueData =
      FirebaseFirestore.instance; // كائن للوصول إلى قاعدة بيانات Firestore
  String? currentUser = FirebaseAuth
      .instance
      .currentUser!
      .uid; // الحصول على معرف المستخدم الحالي من FirebaseAuth
  QueueL queueLine =
      QueueL(); // إنشاء كائن من QueueL لإدارة عمليات الطابور (تسجيل وصول المريض)
  late Notifications notify =
      Notifications(); // كائن للتعامل مع رسائل التأكيد/الإشعارات

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل وصول المريض'), // عنوان الصفحة في شريط التطبيق العلوي
        backgroundColor: Colors.amberAccent[200], // لون خلفية الـ AppBar
      ),
      body: Column(
        children: [
          Expanded(
            // الجزء العلوي من الشاشة لعرض قائمة المواعيد المنتظرة
            child: StreamBuilder<QuerySnapshot>(
              // الاستماع إلى تغييرات مجموعة Appointments في Firestore
              stream: queueData
                  .collection('Appointments')
                  .where(
                    'status',
                    isEqualTo: 'WaitingToCheckIn',
                  ) // فلترة المواعيد ذات الحالة "في انتظار تسجيل الوصول"
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // في حال لم تصل البيانات بعد يتم عرض مؤشر تحميل
                  return Center(child: CircularProgressIndicator());
                }

                final docs =
                    snapshot.data!.docs; // الحصول على قائمة الوثائق (المواعيد)

                if (docs.isEmpty) {
                  // في حال عدم وجود أي مواعيد بحالة انتظار
                  return Center(child: Text("لا توجد حالات انتظار"));
                }

                // بناء قائمة من البطاقات لكل موعد
                return ListView.builder(
                  itemCount: docs.length, // عدد العناصر يساوي عدد الوثائق
                  itemBuilder: (context, index) {
                    final doc = docs[index]; // المستند الحالي (موعد واحد)

                    return Card(
                      // بطاقة تحتوي على تفاصيل الموعد
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.amber,
                        ), // أيقونة مريض في بداية السطر
                        title: Text(
                          "المريض: ${doc['patientName']}",
                        ), // عرض اسم المريض
                        subtitle: Text(
                          "رقم الدور: ${doc['LineNumber']}",
                        ), // عرض رقم الدور الخاص بالمريض
                        trailing: ElevatedButton(
                          // زر لتسجيل وصول المريض
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .green, // لون الزر أخضر للدلالة على الموافقة/التسجيل
                          ),
                          child: Text('تسجيل الوصول'), // نص الزر
                          onPressed: () async {
                            // عند الضغط على الزر يتم استدعاء دالة تسجيل وصول المريض
                            await queueLine.checkInPatient(
                              doc.id, // معرف الموعد في مجموعة Appointments
                              context, // السياق الحالي لعرض الرسائل/التنقل
                              doc['patientName'], // اسم المريض لعرضه في الرسائل أو التسجيل
                            );
                            //if (!mounted) return; // تعليق: يمكن استخدامه للتحقق من بقاء الواجهة مركّبة قبل استكمال الأكشن
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // الجزء السفلي من الشاشة يحتوي على زر تهيئة الطابور
          Container(
            padding: EdgeInsets.all(16.0), // مسافة داخلية حول المحتوى
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blueAccent[200], // لون زر تهيئة الطابور
                  ),
                  child: Text(
                    'تهيئة الطابور', // نص الزر لتهيئة الطابور
                    style: TextStyle(color: Colors.white), // لون النص داخل الزر
                  ),
                  onPressed: () async {
                    // عند الضغط على الزر، يتم عرض رسالة تأكيد قبل تنفيذ عملية التهيئة
                    bool confirmed = await notify.showConfirmationDialog(
                      context,
                      notify.message =
                          'سيتم إعادة تعيين أرقام الدور لليوم الحالي.', // رسالة التنبيه للمستخدم
                    );
                    if (!confirmed) {
                      return; // إذا لم يؤكد المستخدم، يتم إلغاء العملية
                    }

                    DateTime? dateNow =
                        DateTime.now(); // الحصول على التاريخ والوقت الحالي
                    String formattedDate = dateNow.toIso8601String().substring(
                      0,
                      10,
                    ); // تحويل التاريخ إلى صيغة yyyy-MM-dd فقط

                    // جلب جميع وثائق مجموعة Queue للتحقق من وجود طابور
                    await queueData.collection('Queue').get().then((
                      querySnapshot,
                    ) {
                      if (querySnapshot.docs.isNotEmpty) {
                        // في حال وجود مستند طابور واحد أو أكثر، يتم استخدام الأول
                        var queueDoc = querySnapshot.docs.first;

                        // إعادة تعيين أرقام الدور في وثيقة الطابور الحالية
                        queueData.collection('Queue').doc(queueDoc.id).update({
                          'MovingLineNumber': 0, // إعادة عداد الحركة إلى الصفر
                          'TodayLineNumber': 0, // إعادة رقم اليوم إلى الصفر
                          'date': formattedDate, // حفظ تاريخ اليوم بعد التهيئة
                        });
                      } else {
                        // في حال عدم وجود أي مستند للطابور، يتم إنشاء واحد جديد
                        queueData.collection('Queue').add({
                          'TodayLineNumber':
                              0, // تعيين رقم اليوم الافتراضي إلى الصفر
                          'MovingLineNumber':
                              0, // تعيين رقم الحركة الافتراضي إلى الصفر
                          'date': formattedDate, // حفظ تاريخ التهيئة
                        });
                      }
                    });

                    // إظهار رسالة نجاح بعد إتمام عملية التهيئة
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("تم تهيئة الطابور بنجاح.")),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
