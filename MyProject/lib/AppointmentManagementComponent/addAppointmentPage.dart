// addAppointmentPage.dart
import 'package:flutter/material.dart'; // استيراد أدوات الواجهة الرسومية من فلاتر
import '/AppointmentManagementComponent/appointments.dart'; // استيراد كلاس إدارة المواعيد
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة المصادقة من Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Cloud Firestore للتعامل مع قاعدة البيانات
import '/NotificationSystemComponent/notifications.dart'; // استيراد كلاس الإشعارات/رسائل التأكيد
import 'appointment_factory.dart';

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
  String? selectedDate; // حفظ التاريخ الذي تم اختياره للموعد
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
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline, // أيقونة معلومات بجانب النص التوضيحي
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'يرجى اختيار الطبيب والوقت المناسبين للموعد،\n ثم تحديد نوع الموعد قبل الحجز.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 40),
                    ElevatedButton(
                      // زر لاختيار الطبيب والوقت
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
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
                            selectedDoctorId =
                                result['doctorId']; // حفظ معرّف الطبيب
                            selectedDoctorName =
                                result['doctorName']; // حفظ اسم الطبيب
                            selectedDoctorEmail =
                                result['doctorEmail']; // حفظ بريد الطبيب
                            selectedTime = result['time']; // حفظ الوقت المختار
                            selectedDate =
                                result['date']; // ✅ الآن التاريخ يصل بشكل صحيح ويتم عرضه في حقل التاريخ
                          });
                        }
                      },
                      child: Text(
                        'اختر طبيب ووقت',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // نص الزر
                    ),
                    SizedBox(width: 30),
                    DropdownButton(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      // قائمة منسدلة لاختيار نوع الموعد
                      hint: Text('اختر نوع الموعد'), // نص يظهر قبل اختيار النوع
                      value: selectedAppointmentType, // القيمة الحالية المختارة
                      items: const [
                        DropdownMenuItem(
                          value: 'إستشارة',
                          child: Text(
                            'إستشارة (السعر 30د.ل)',
                          ), // نوع الموعد + السعر
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
                        selectedAppointmentType = value;
                        // عند تغيير نوع الموعد من القائمة المنسدلة
                        setState(() {
                          // تحديد النوع المختار
                          print(selectedAppointmentType);
                          appointmentCost = (selectedAppointmentType == null)
                              ? null
                              : AppointmentFactory.getCost(
                                  selectedAppointmentType!,
                                );
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // موضع الظل
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'الطبيب المختار: ${selectedDoctorName ?? "لم يتم الاختيار"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ), // عرض اسم الطبيب المختار أو رسالة في حال لم يُختَر
                      SizedBox(height: 10),
                      Text(
                        'الوقت المختار: ${selectedTime ?? "لم يتم الاختيار"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ), // عرض الوقت المختار أو رسالة في حال لم يُختَر
                      SizedBox(height: 10),
                      Text(
                        'التاريخ المختار: ${selectedDate ?? "لم يتم الاختيار"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ), // عرض التاريخ المختار أو رسالة في حال لم يُختَر
                      SizedBox(height: 10),
                      Text(
                        'نوع الموعد المختار: ${selectedAppointmentType ?? "لم يتم الاختيار"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ), // عرض نوع الموعد إذا تم اختياره
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(), // خط فاصل بين جزء اختيار الطبيب وجزء الحجز
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // جعل حواف الزر دائرية
                    ),
                  ),
                  // زر تأكيد حجز الموعد
                  onPressed: () async {
                    // قبل الحجز، طلب تأكيد من المستخدم
                    final confirmed = await notify.showConfirmationDialog(
                      context,
                      'هل أنت متأكد من حجز هذا الموعد؟', // رسالة التأكيد قبل الحجز
                    );
                    if (!confirmed) {
                      return; // إذا لم يؤكد المستخدم، لا يتم تنفيذ شيء
                    }

                    String?
                    currentUser; // متغير لتحديد المريض الذي سيُسجَّل له الموعد
                    if (whosTheUser()) {
                      // إذا كان الحجز للأدمن (مريض مختار من FindPatient)
                      currentUser = widget
                          .patientIdd; // استخدام معرّف المريض القادم من الصفحة السابقة
                    } else {
                      // إذا كان الحجز لمستخدم مسجّل الدخول (المريض نفسه)
                      currentUser =
                          thisUser?.uid; // استخدام معرّف المستخدم الحالي
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
                        selectedDate != null) {
                      // إذا كل شيء جاهز، استدعاء دالة حفظ الموعد في كلاس Appointment
                      await appointment.saveAppointment(
                        doctorId: selectedDoctorId!, // معرّف الطبيب
                        doctorName: selectedDoctorName!, // اسم الطبيب
                        time: selectedTime!, // الوقت
                        appointmentType:
                            selectedAppointmentType, // نوع الموعد (قد تكون null إن لم يُختَر)
                        cost: appointmentCost, // تكلفة الموعد
                        patientId: currentUser, // معرّف المريض
                        date: selectedDate!, // تاريخ الموعد
                        patientName:
                            userInfo['FullName'], // اسم المريض من Firestore
                        patientEmail:
                            userInfo['Email'], // بريد المريض من Firestore
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
                        SnackBar(
                          content: Text('يرجى اختيار طبيب ووقت قبل الحجز'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'حجز الموعد',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // نص زر حجز الموعد
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
