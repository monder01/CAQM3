// addAppointmentPage.dart
import 'package:flutter/material.dart'; // استيراد أدوات الواجهة الرسومية من فلاتر
import 'package:prototype1/AppointmentManagementComponent/appointments.dart'; // استيراد كلاس إدارة المواعيد
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة المصادقة من Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Cloud Firestore للتعامل مع قاعدة البيانات
import 'package:prototype1/NotificationSystemComponent/notifications.dart'; // استيراد كلاس الإشعارات/رسائل التأكيد

class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({super.key, this.patientIdd});

  final String?
  patientIdd; // معرّف المريض (يُمرَّر من صفحة الأدمن في حالة حجز موعد لمريض معيّن)

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState(); // إنشاء الحالة الخاصة بهذه الصفحة
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  Notifications notify = Notifications(); // كائن لإظهار رسائل التأكيد للمستخدم
  Appointment appointment =
      Appointment(); // كائن من كلاس Appointment للتعامل مع حفظ المواعيد واختيار الأطباء
  String? selectedDoctorId; // حفظ معرّف الطبيب الذي تم اختياره
  String? selectedDoctorName; // حفظ اسم الطبيب الذي تم اختياره
  String? selectedDoctorEmail; // حفظ بريد الطبيب الإلكتروني
  String? selectedTime; // حفظ الوقت الذي تم اختياره للموعد
  String? selectedAppointmentType; // نوع الموعد (استشارة، متابعة، فحص دوري...)
  double? appointmentCost; // تكلفة الموعد حسب نوعه
  TextEditingController dateController =
      TextEditingController(); // متحكم لحقل عرض تاريخ الموعد
  final thisUser = FirebaseAuth
      .instance
      .currentUser; // الحصول على المستخدم الحالي (المريض المسجّل دخول)

  bool whosTheUser() {
    // دالة لتحديد مصدر المريض: هل هو مريض تم اختياره من الأدمن أم المستخدم الحالي
    return widget.patientIdd !=
        null; // إذا كان patientIdd ليس null فهذا يعني أن الأدمن هو من يحجز لمريض معيّن
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة موعد جديد'), // عنوان الصفحة في الشريط العلوي
        backgroundColor: Colors.amberAccent[200], // لون الخلفية للـ AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // مسافة padding حول محتوى الصفحة
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              // زر لاختيار الطبيب والوقت
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 100), // تحديد حجم أدنى للزر
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    15,
                  ), // جعل حواف الزر دائرية
                ),
              ),
              onPressed: () async {
                // عند الضغط يتم فتح حوار لاختيار طبيب ووقت
                final result = await appointment.showDoctorsDialog(
                  context,
                ); // استدعاء دالة تعرض حوار اختيار الطبيب والوقت
                if (result != null) {
                  // إذا رجعت نتيجة (لم يُغلق الحوار بدون اختيار)
                  setState(() {
                    selectedDoctorId = result['doctorId']; // حفظ معرّف الطبيب
                    selectedDoctorName = result['doctorName']; // حفظ اسم الطبيب
                    selectedDoctorEmail =
                        result['doctorEmail']; // حفظ بريد الطبيب
                    selectedTime = result['time']; // حفظ الوقت المختار
                    dateController.text =
                        result['date']; // ✅ الآن التاريخ يصل بشكل صحيح ويتم عرضه في حقل التاريخ
                  });
                }
              },
              child: Text('اختر طبيب ووقت'), // نص الزر
            ),
            SizedBox(height: 20),
            TextField(
              // حقل لعرض تاريخ الموعد
              controller: dateController, // ربط الحقل بمتحكم التاريخ
              decoration: InputDecoration(
                labelText: 'تاريخ الموعد', // نص إرشادي للحقل
                border: OutlineInputBorder(), // إطار الحقل
              ),
              readOnly: true, // لمنع الكتابة أو الضغط
              enabled: false, // حقل للعرض فقط (غير قابل للتفاعل)
            ),
            SizedBox(height: 20),
            Text(
              'الطبيب المختار: ${selectedDoctorName ?? "لم يتم الاختيار"}',
            ), // عرض اسم الطبيب المختار أو رسالة في حال لم يُختَر
            SizedBox(height: 10),
            Text(
              'الوقت المختار: ${selectedTime ?? "لم يتم الاختيار"}',
            ), // عرض الوقت المختار أو رسالة في حال لم يُختَر
            Divider(), // خط فاصل بين جزء اختيار الطبيب وجزء الحجز
            ElevatedButton(
              // زر تأكيد حجز الموعد
              onPressed: () async {
                // قبل الحجز، طلب تأكيد من المستخدم
                final confirmed = await notify.showConfirmationDialog(
                  context,
                  'هل أنت متأكد من حجز هذا الموعد؟', // رسالة التأكيد قبل الحجز
                );
                if (!confirmed)
                  return; // إذا لم يؤكد المستخدم، لا يتم تنفيذ شيء

                String?
                currentUser; // متغير لتحديد المريض الذي سيُسجَّل له الموعد
                if (whosTheUser()) {
                  // إذا كان الحجز للأدمن (مريض مختار من FindPatient)
                  currentUser = widget
                      .patientIdd; // استخدام معرّف المريض القادم من الصفحة السابقة
                } else {
                  // إذا كان الحجز لمستخدم مسجّل الدخول (المريض نفسه)
                  currentUser = thisUser?.uid; // استخدام معرّف المستخدم الحالي
                }

                // جلب بيانات المريض من مجموعة users في Firestore
                DocumentSnapshot userInfo = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser)
                    .get();

                // التحقق من أن كل البيانات الأساسية للحجز موجودة
                if (selectedDoctorId != null &&
                    selectedDoctorName != null &&
                    selectedTime != null &&
                    dateController.text.isNotEmpty) {
                  // إذا كل شيء جاهز، استدعاء دالة حفظ الموعد في كلاس Appointment
                  await appointment.saveAppointment(
                    doctorId: selectedDoctorId!, // معرّف الطبيب
                    doctorName: selectedDoctorName!, // اسم الطبيب
                    time: selectedTime!, // الوقت
                    appointmentType:
                        selectedAppointmentType, // نوع الموعد (قد تكون null إن لم يُختَر)
                    cost: appointmentCost, // تكلفة الموعد
                    patientId: currentUser, // معرّف المريض
                    date: dateController.text, // تاريخ الموعد
                    patientName:
                        userInfo['FullName'], // اسم المريض من Firestore
                    patientEmail: userInfo['Email'], // بريد المريض من Firestore
                    doctorEmail: selectedDoctorEmail, // بريد الطبيب
                  );
                  Navigator.of(
                    context,
                  ).pop(); // العودة للصفحة السابقة بعد حفظ الموعد
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم حجز الموعد بنجاح ✔️', // رسالة نجاح بعد الحجز
                        style: TextStyle(
                          color: Colors.amberAccent[200],
                          fontSize: 34,
                        ),
                      ),
                    ),
                  );

                  setState(() {
                    // إعادة تعيين بعض المتغيرات بعد الحجز (في حال البقاء في نفس الصفحة)
                    selectedDoctorId = null;
                    selectedDoctorName = null;
                    selectedTime = null;
                  });
                } else {
                  // في حال لم يختَر المستخدم طبيبًا أو وقتًا
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('يرجى اختيار طبيب ووقت قبل الحجز')),
                  );
                }
              },
              child: Text('حجز'), // نص زر حجز الموعد
            ),
            SizedBox(height: 20),
            DropdownButton(
              // قائمة منسدلة لاختيار نوع الموعد
              hint: Text('اختر نوع الموعد'), // نص يظهر قبل اختيار النوع
              value: selectedAppointmentType, // القيمة الحالية المختارة
              items: const [
                DropdownMenuItem(
                  value: 'إستشارة',
                  child: Text('إستشارة (السعر 30د.ل)'), // نوع الموعد + السعر
                ),
                DropdownMenuItem(
                  value: 'متابعة',
                  child: Text('متابعة (السعر 70د.ل)'),
                ),
                DropdownMenuItem(
                  value: 'فحص دوري',
                  child: Text('فحص دوري (السعر 50د.ل)'),
                ),
              ],
              onChanged: (value) {
                // عند تغيير نوع الموعد من القائمة المنسدلة
                setState(() {
                  selectedAppointmentType =
                      value as String?; // تخزين النوع المختار
                  // تحديد تكلفة الموعد حسب النوع
                  if (selectedAppointmentType == "إستشارة") {
                    appointmentCost = 30.0;
                  } else if (selectedAppointmentType == "متابعة") {
                    appointmentCost = 70.0;
                  } else if (selectedAppointmentType == "فحص دوري") {
                    appointmentCost = 50.0;
                  } else {
                    appointmentCost = null; // في حال لم يتم اختيار أي نوع
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
