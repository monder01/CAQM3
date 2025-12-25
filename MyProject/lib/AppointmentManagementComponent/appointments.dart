/// appointments.dart
library; // تعريف مكتبة Dart بدون اسم (استخدام بسيط لمفهوم المكتبات في Dart)

import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Cloud Firestore للتعامل مع قاعدة البيانات
import 'package:flutter/material.dart'; // استيراد أدوات الواجهة الرسومية من فلاتر

class Appointment {
  String? appointmentId; // معرّف الموعد في قاعدة البيانات
  DateTime?
  appointmentDate; // تاريخ ووقت الموعد (في شكل DateTime إن استُخدم لاحقًا)
  String? time; // وقت الموعد كنص (مثل 9:00 - 9:30)
  String? reason; // سبب الموعد أو ملاحظات عنه
  String? status; // حالة الموعد: booked, completed, canceled وغيرها
  int? lineNumber = 0; // رقم الدور المرتبط بالموعد في الطابور
  String? appointmentType; // نوع الموعد (استشارة، متابعة، فحص دوري...)
  double? cost; // تكلفة الموعد
  Appointment({
    this.appointmentType = 'عادي',
    this.cost = 0.0,
    this.appointmentId,
    this.appointmentDate,
    this.time,
    this.reason,
    this.status,
    this.lineNumber,
  });

  /// التحقق من توفر الوقت
  Future<bool> isTimeAvailable(
    String doctorId, // معرف الطبيب الذي نريد الحجز لديه
    String time, // الوقت المطلوب حجزه
    String
    date, // التاريخ المطلوب الحجز فيه (بالصيغة النصية المستخدمة في التخزين)
  ) async {
    // البحث في مجموعة Appointments عن أي موعد بنفس الطبيب ونفس التاريخ ونفس الوقت
    final snapshot = await FirebaseFirestore.instance
        .collection('Appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: date)
        .where('time', isEqualTo: time)
        .get();

    return snapshot.docs.isEmpty; // لو لا توجد مستندات يعني الوقت متاح للحجز
  }

  /// عرض Dialog لاختيار الطبيب
  Future<Map<String, dynamic>?> showDoctorsDialog(BuildContext context) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.person_search,
            color: Colors.amberAccent[200],
            size: 40,
          ), // أيقونة أعلى مربع الحوار ترمز للبحث عن طبيب
          title: Text('اختر طبيب'), // عنوان مربع الحوار
          content: SizedBox(
            width: double.maxFinite, // جعل العرض يأخذ أقصى مساحة ممكنة
            child: StreamBuilder<QuerySnapshot>(
              // الاستماع لمجموعة Doctors من Firestore لجلب قائمة الأطباء
              stream: FirebaseFirestore.instance
                  .collection('Doctors')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // في حالة عدم توفر البيانات بعد، إظهار مؤشر تحميل
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs; // قائمة وثائق الأطباء

                return ListView.builder(
                  shrinkWrap:
                      true, // السماح للقائمة أن تأخذ أقل ارتفاع ممكن داخل الـ Dialog
                  itemCount: docs.length, // عدد الأطباء
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final doctorId =
                        data['DoctorID'] ??
                        docs[index]
                            .id; // رقم الطبيب (أولوية لـ DoctorID وإن لم يوجد يستخدم id الوثيقة)
                    final doctorName =
                        data['FullName'] ??
                        'No Name'; // اسم الطبيب أو نص افتراضي
                    final doctorEmail = data['Email']; // بريد الطبيب
                    final workingHours = List<String>.from(
                      data['WorkingHours'] ?? [],
                    ); // قائمة أوقات العمل للطبيب

                    return Card(
                      // كارت لكل طبيب لعرض بياناته
                      child: ListTile(
                        title: Text("د. $doctorName"), // اسم الطبيب في العنوان
                        subtitle: Text(
                          data['Specialization'] ??
                              'لا يوجد تخصص', // التخصص إن وجد
                        ),
                        onTap: () async {
                          // عند الضغط على الطبيب يتم فتح Dialog الأوقات
                          final selectedTime = await showTimesDialog(
                            context,
                            doctorName,
                            workingHours,
                            doctorId,
                            doctorEmail,
                          );
                          if (selectedTime != null) {
                            // ✅ التعديل: تمرير التاريخ مع الوقت عند العودة
                            Navigator.of(context).pop({
                              'doctorId': doctorId, // إرجاع معرف الطبيب
                              'doctorName': doctorName, // إرجاع اسم الطبيب
                              'time': selectedTime['time'], // الوقت المختار
                              'date': selectedTime['date'], // التاريخ المختار
                              'doctorEmail': doctorEmail, // بريد الطبيب
                            });
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// عرض Dialog لاختيار الوقت
  Future<Map<String, String>?> showTimesDialog(
    BuildContext context, // سياق الواجهة لعرض الـ Dialog
    String doctorName, // اسم الطبيب لعرضه في عنوان مربع الحوار
    List<String> times, // قائمة الأوقات المتاحة للطبيب
    String doctorId, // معرف الطبيب للتحقق من الحجز
    String doctorEmail, // بريد الطبيب (يمكن استخدامه لاحقاً)
  ) async {
    return await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(
            Icons.access_time,
            color: Colors.amberAccent[200],
            size: 40,
          ), // أيقونة ساعة للدلالة على اختيار الوقت
          title: Text(
            'الأوقات المتاحة لـ د. $doctorName',
          ), // عنوان مربع الحوار مع اسم الطبيب
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // تحديد ارتفاع لمحتوى قائمة الأوقات
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: times.length, // عدد الأوقات المتاحة
              itemBuilder: (context, index) {
                return Card(
                  // كارت لكل وقت متاح
                  child: ListTile(
                    title: Text(times[index]), // عرض الوقت
                    onTap: () async {
                      // عند الضغط على وقت معين، يتم أولاً اختيار التاريخ
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), // التاريخ الافتراضي اليوم
                        firstDate: DateTime.now(), // لا يسمح بتاريخ قبل اليوم
                        lastDate: DateTime(2030), // أقصى تاريخ للاختيار
                      );

                      if (selectedDate == null) {
                        return; // لو لم يتم اختيار تاريخ، خروج بدون فعل شيء
                      }

                      String formattedDate = selectedDate
                          .toIso8601String()
                          .substring(
                            0,
                            10,
                          ); // تحويل التاريخ إلى صيغة yyyy-MM-dd

                      // التحقق من أن الوقت مع هذا التاريخ غير محجوز مسبقاً
                      bool available = await isTimeAvailable(
                        doctorId,
                        times[index],
                        formattedDate,
                      );

                      if (!available) {
                        // في حال الوقت محجوز بالفعل، إظهار رسالة خطأ للمستخدم
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('هذا الوقت محجوز بالفعل')),
                        );
                        return;
                      }

                      // ✅ التعديل: إرجاع الوقت + التاريخ
                      Navigator.of(context).pop({
                        'time': times[index],
                        'date': formattedDate,
                      }); // إرجاع الوقت والتاريخ للـ Dialog السابق
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// حفظ الموعد
  Future<void> saveAppointment({
    required String doctorId, // معرف الطبيب
    required String doctorName, // اسم الطبيب
    required String time, // الوقت المحجوز
    String? appointmentType, // نوع الموعد (اختياري)
    double? cost, // تكلفة الموعد (اختيارية)
    String? patientId, // معرف المريض
    String? date, // تاريخ الموعد
    String? patientName, // اسم المريض
    String? patientEmail, // بريد المريض
    String? doctorEmail, // بريد الطبيب
  }) async {
    if (patientId == null) return; // إذا لم يكن هناك معرف للمريض، لا يتم الحفظ

    // إضافة مستند جديد لمجموعة Appointments في Firestore يحتوي على بيانات الموعد
    await FirebaseFirestore.instance.collection('Appointments').add({
      'doctorId': doctorId, // معرف الطبيب
      'doctorName': doctorName, // اسم الطبيب
      'patientId': patientId, // معرف المريض
      'patientName': patientName, // اسم المريض
      'time': time, // وقت الموعد
      'date': date, // تاريخ الموعد
      'appointmentType': appointmentType, // نوع الموعد
      'cost': cost, // تكلفة الموعد
      'LineNumber': lineNumber, // رقم الدور (في الطابور) المرتبط بالموعد
      'status': 'Booked', // حالة الموعد عند الإنشاء (محجوز)
      'email': patientEmail, // بريد المريض
      'doctorEmail': doctorEmail, // بريد الطبيب
    });
  }
}
