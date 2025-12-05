//queues.dart
import 'package:flutter/material.dart'; // استيراد مكتبة الواجهات في فلاتر (قد لا تُستخدم مباشرة هنا)
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Cloud Firestore للتعامل مع قاعدة البيانات

class QueueL {
  DateTime?
  checkInTime; // وقت تسجيل وصول المريض (يمكن استخدامه لتخزين وقت الدخول الفعلي)
  String? queueId; // معرف الطابور (إن لزم تخزينه مستقبلاً)
  String?
  status; // حالة العنصر في الطابور مثل: "pending", "completed", "canceled"
  String? token; // يمكن استخدامه كرَقَم أو رمز مميز للمريض في الطابور
  int? lineNumber =
      0; // رقم الدور الحالي للمريض في الطابور، يبدأ من 0 بشكل افتراضي

  Future<void> checkInPatient(
    String appointmentId, // معرف الموعد الذي سيتم تسجيل وصوله
    BuildContext
    context, // سياق الواجهة (في حال الحاجة لعرض رسائل أو استخدامه لاحقاً)
    String patientname, // اسم المريض (قد يُستخدم للتسجيل أو الرسائل لاحقاً)
  ) async {
    DateTime? dateNow = DateTime.now(); // الحصول على التاريخ والوقت الحالي
    String formattedDate = dateNow.toIso8601String().substring(
      0,
      10,
    ); // تنسيق التاريخ بصيغة yyyy-MM-dd فقط
    FirebaseFirestore firestore =
        FirebaseFirestore.instance; // مرجع لقاعدة بيانات Firestore

    // جلب مستندات مجموعة "Queue" لمعرفة حالة الطابور الحالية
    await firestore.collection('Queue').get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // إذا كان هناك مستند طابور موجود مسبقًا
        var queueDoc = querySnapshot.docs.first; // أخذ أول مستند من المجموعة
        lineNumber =
            queueDoc['TodayLineNumber'] +
            1; // زيادة رقم الدور اليومي بمقدار 1 للمريض الجديد

        // تحديث قيمة Today's Line Number في مجموعة Queue
        firestore.collection('Queue').doc(queueDoc.id).update({
          'TodayLineNumber':
              lineNumber, // حفظ رقم الدور الجديد كآخر رقم مستخدم اليوم
        });
      } else {
        // إذا لم يكن هناك أي مستند للطابور، يتم إنشاء مستند جديد
        lineNumber = 1; // أول مريض يحصل على الرقم 1
        firestore.collection('Queue').add({
          'TodayLineNumber': lineNumber, // رقم الدور الحالي لليوم
          'MovingLineNumber':
              0, // رقم الدور المتحرك (قد يستخدم لعرض من في الانتظار الآن)
          'date': formattedDate, // تاريخ اليوم الذي تم فيه إنشاء الطابور
        });
      }
    });

    // تحديث حالة الموعد في مجموعة Appointments ورقم الدور الخاص به
    await firestore.collection('Appointments').doc(appointmentId).update({
      'status': 'CheckedIn', // تغيير حالة الموعد إلى "تم تسجيل الوصول"
      'LineNumber': lineNumber, // ربط الموعد برقم الدور الذي تم تخصيصه له
    });

    // تخزين وقت تسجيل الوصول (يمكن استخدامه لاحقاً في التقارير أو السجلات)
    checkInTime = DateTime.now();
  }
}
