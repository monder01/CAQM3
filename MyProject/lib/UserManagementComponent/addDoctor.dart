import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/NotificationSystemComponent/notifications.dart';
import '/UserManagementComponent/doctors.dart';
import '/UserManagementComponent/users.dart';

class Adddoctor extends StatefulWidget {
  const Adddoctor({super.key});

  @override
  State<Adddoctor> createState() => _AdddoctorState();
}

class _AdddoctorState extends State<Adddoctor> {
  Notifications notify =
      Notifications(); // إنشاء كائن للتعامل مع نظام الإشعارات / رسائل التأكيد
  UserC user =
      UserC(); // كائن يمثل المستخدم (قد يُستخدم لاحقًا لإدارة بيانات المستخدمين)
  Doctors doctor = Doctors(); // كائن يمثل الطبيب لتخزين بياناته قبل الحفظ
  TextEditingController nameController =
      TextEditingController(); // متحكم لحقل اسم الطبيب
  TextEditingController emailController =
      TextEditingController(); // متحكم لحقل البريد الإلكتروني
  TextEditingController passwordController =
      TextEditingController(); // متحكم لحقل كلمة المرور
  TextEditingController phoneController =
      TextEditingController(); // متحكم لحقل رقم الهاتف
  TextEditingController specializationController =
      TextEditingController(); // متحكم لحقل التخصص

  List<String> weekDays = [
    "السبت",
    "الأحد",
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
  ]; // قائمة بأيام الأسبوع لاختيار أيام عمل الطبيب
  List<String> dayHours = [
    "8:30 - 9:00",
    "9:00 - 9:30",
    "9:30 - 10:00",
    "10:00 - 10:30",
    "10:30 - 11:00",
    "11:00 - 11:30",
    "11:30 - 12:00",
    "12:00 - 12:30",
    "12:30 - 1:00",
    "1:00 - 1:30",
    "1:30 - 2:00",
    "2:00 - 2:30",
    "2:30 - 3:00",
    "3:00 - 3:30",
    "3:30 - 4:00",
    "4:00 - 4:30",
  ]; // قائمة بالأوقات المتاحة في اليوم لاختيار ساعات العمل
  Map<String, bool> selectedDays =
      {}; // خريطة لتخزين حالة اختيار أيام العمل لكل يوم
  Map<String, bool> selectedHours =
      {}; // خريطة لتخزين حالة اختيار ساعات العمل لكل فترة زمنية
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // يسمح بالتمرير إذا كانت الشاشة صغيرة
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12), // مسافة داخلية حول المحتوى
        child: Column(
          children: [
            SizedBox(height: 20), // مسافة علوية
            Text(
              "إضافة طبيب جديد", // عنوان الصفحة
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent[200],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController, // ربط الحقل بمتحكم الاسم
              decoration: InputDecoration(
                labelText: "أدخل اسم الطبيب الكامل الثلاثي", // نص توضيحي
                border: OutlineInputBorder(), // إطار حول الحقل
                isDense: true, // جعل الحقل أقل ارتفاعًا
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: emailController, // ربط الحقل بمتحكم البريد
              decoration: InputDecoration(
                labelText: "أدخل البريد الإلكتروني للطبيب",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true, // إخفاء النص (كلمة مرور)
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "أدخل الرقم السري للطبيب",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "أدخل رقم هاتف الطبيب",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: specializationController,
              decoration: InputDecoration(
                labelText: "أدخل تخصص الطبيب",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // عند الضغط يتم فتح Dialog لاختيار أيام العمل
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("اختر أيام عمل الطبيب"), // عنوان مربع الحوار
                      content: SizedBox(
                        width: double.maxFinite,
                        height: 300, // تحديد ارتفاع المحتوى
                        child: StatefulBuilder(
                          // استخدام StatefulBuilder لتحديث حالة الـ Dialog داخليًا
                          builder: (context, setStateDialog) {
                            return ListView(
                              children: weekDays.map((day) {
                                // إنشاء قائمة من CheckBox لكل يوم من أيام الأسبوع
                                return CheckboxListTile(
                                  title: Text(day), // عرض اسم اليوم
                                  value:
                                      selectedDays[day] ??
                                      false, // حالة الاختيار
                                  onChanged: (value) {
                                    // تحديث حالة اليوم عند التغيير
                                    setStateDialog(() {
                                      selectedDays[day] = value ?? false;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context), // إغلاق الـ Dialog
                          child: Text("تم"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("اختر أيام العمل"), // نص الزر
            ),

            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                // عند الضغط يتم فتح Dialog لاختيار ساعات العمل
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("اختر ساعات العمل"), // عنوان مربع الحوار
                      content: SizedBox(
                        width: double.maxFinite,
                        height: 300, // ضبط ارتفاع المحتوى
                        child: StatefulBuilder(
                          // StatefulBuilder لتحديث حالة مربعات الاختيار داخل الـ Dialog
                          builder: (context, setStateDialog) {
                            return ListView(
                              children: dayHours.map((hour) {
                                // إنشاء قائمة من CheckBox لكل فترة زمنية
                                return CheckboxListTile(
                                  title: Text(hour), // عرض الوقت
                                  value:
                                      selectedHours[hour] ??
                                      false, // حالة الاختيار
                                  onChanged: (value) {
                                    // تحديث حالة الساعة عند التغيير
                                    setStateDialog(() {
                                      selectedHours[hour] = value ?? false;
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context), // إغلاق الـ Dialog
                          child: Text("تم"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("اختر ساعات العمل"), // نص الزر
            ),

            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                // زر إضافة الطبيب النهائي بعد تعبئة البيانات والاختيارات
                final confirmed = await notify.showConfirmationDialog(
                  context,
                  'سيتم تقدم أرقام الدور لليوم الحالي.', // رسالة تأكيد قبل الإضافة
                );
                if (!confirmed) return; // في حال لم يؤكد المستخدم يتم الإلغاء

                // تعبئة خصائص كائن الطبيب من الحقول
                doctor.email = emailController.text.trim();
                doctor.password = passwordController.text.trim();
                doctor.fullname = nameController.text.trim();
                doctor.phoneNumber = phoneController.text.trim();
                doctor.specialization = specializationController.text.trim();
                doctor.role = "Doctor"; // تثبيت الدور كطبيب

                // تحويل الأيام المختارة من الخريطة إلى قائمة نصوص (أيام مختارة فقط)
                doctor.workingDays = selectedDays.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();
                // تحويل الساعات المختارة من الخريطة إلى قائمة نصوص (ساعات مختارة فقط)
                doctor.workingHours = selectedHours.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();

                // التحقق من أن جميع الحقول الإلزامية غير فارغة
                if (doctor.fullname!.isEmpty ||
                    doctor.email!.isEmpty ||
                    doctor.password!.isEmpty ||
                    doctor.phoneNumber!.isEmpty ||
                    doctor.specialization!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ يرجى ملء جميع الحقول")),
                  );
                  return;
                }
                // التحقق من اختيار أيام العمل
                if (doctor.workingDays.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ يرجى اختيار أيام عمل الطبيب")),
                  );
                  return;
                }

                // التحقق من اختيار ساعات العمل
                if (doctor.workingHours.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ يرجى اختيار ساعات عمل الطبيب")),
                  );
                  return;
                }

                try {
                  // إنشاء مستخدم جديد في Firebase Authentication باستخدام بريد وكلمة مرور الطبيب
                  UserCredential userinfo = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: doctor.email!,
                        password: doctor.password!,
                      );
                  // حفظ بيانات الطبيب في Firestore داخل مجموعة Doctors
                  await FirebaseFirestore.instance
                      .collection('Doctors')
                      .doc(userinfo.user!.uid)
                      .set({
                        'FullName': doctor.fullname,
                        'Email': doctor.email,
                        'PhoneNumber': doctor.phoneNumber,
                        'Role': doctor.role,
                        'DoctorID': userinfo.user!.uid,
                        'Specialization': doctor.specialization,
                        'WorkingDays': doctor.workingDays,
                        'WorkingHours': doctor.workingHours,
                      });

                  // إظهار رسالة نجاح عند إتمام العملية
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تم إضافة الطبيب بنجاح ✅ ${doctor.fullname}",
                      ),
                    ),
                  );
                } catch (e) {
                  // في حالة حدوث أي خطأ أثناء إنشاء المستخدم أو الحفظ في Firestore
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
                }
              },
              child: Text("إضافة الطبيب"), // نص زر إضافة الطبيب
            ),
          ],
        ),
      ),
    );
  }
}
