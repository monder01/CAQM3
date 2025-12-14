// lib/pages/signup.dart
import 'package:flutter/material.dart'; // استيراد مكتبة واجهة المستخدم في فلاتر
import '/NotificationSystemComponent/notifications.dart'; // استيراد نظام الإشعارات/الحوارات المخصصة
import '/UserManagementComponent/patients.dart'; // استيراد كلاس Patient الذي يمثل المريض
import '/UserManagementComponent/users.dart'; // استيراد الكلاس الأساسي UserC المستخدم كأساس لأنواع المستخدمين

class Signup extends StatefulWidget {
  final Patient? patient;
  final Notifications? notify;
  const Signup({
    super.key,
    this.patient,
    this.notify,
  }); // ويدجت صفحة التسجيل، من نوع Stateful لأنها تعتمد على مدخلات (حالة) قابلة للتغيير

  @override
  State<Signup> createState() => _SignupState(); // ربط الويدجت بحالة _SignupState
}

class _SignupState extends State<Signup> {
  late final Notifications notify; // كائن للتعامل مع رسائل التأكيد/الإشعارات
  UserC user =
      UserC(); // كائن مستخدم عام (قد يُستخدم لوظائف مشتركة بين المستخدمين)
  late final Patient patient; // كائن يمثل المريض الجديد الذي سيتم إنشاء حساب له
  TextEditingController emailController =
      TextEditingController(); // متحكم لحقل البريد الإلكتروني
  TextEditingController passwordController =
      TextEditingController(); // متحكم لحقل كلمة المرور
  TextEditingController phoneController =
      TextEditingController(); // متحكم لحقل رقم الهاتف
  TextEditingController nameController =
      TextEditingController(); // متحكم لحقل الاسم الكامل

  @override
  void initState() {
    super.initState();
    notify = widget.notify ?? Notifications();
    patient = widget.patient ?? Patient();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // لضمان عدم تداخل المحتوى مع أماكن آمنة مثل شِق الشاشة أو شريط الإشعارات
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"), // عنوان الشريط العلوي للصفحة
          backgroundColor: Colors.amberAccent[200], // لون خلفية الـ AppBar
        ),
        body: SingleChildScrollView(
          // يسمح بالتمرير في حالة صغر الشاشة أو كثرة العناصر
          child: Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // محاذاة العناصر من الأعلى

              children: [
                SizedBox(height: 50), // مسافة علوية قبل العنوان
                Text(
                  "إنشاء حساب جديد", // العنوان الرئيسي للصفحة
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent[200], // لون العنوان
                  ),
                ),
                SizedBox(height: 50), // مسافة بين العنوان وبداية حقول الإدخال
                // حقل إدخال الاسم الكامل
                TextField(
                  controller: nameController, // ربط الحقل بمتحكم الاسم
                  decoration: InputDecoration(
                    labelText:
                        "أدخل اسمك الكامل الثلاثي", // النص الإرشادي داخل الحقل
                    border: OutlineInputBorder(), // إطار حول الحقل
                  ),
                ),
                SizedBox(height: 10),

                // حقل إدخال البريد الإلكتروني
                TextField(
                  controller: emailController, // ربط الحقل بمتحكم البريد
                  decoration: InputDecoration(
                    labelText: "أدخل بريدك الإلكتروني الشخصي", // النص الإرشادي
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // حقل إدخال كلمة المرور
                TextField(
                  obscureText: true, // إخفاء محتوى الحقل (كلمة المرور)
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "أدخل الرقم السري الشخصي", // النص الإرشادي
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // حقل إدخال رقم الهاتف
                TextField(
                  controller: phoneController, // ربط الحقل بمتحكم رقم الهاتف
                  decoration: InputDecoration(
                    labelText: "أدخل رقم هاتفك الشخصي", // النص الإرشادي
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),

                // زر إنشاء الحساب
                ElevatedButton(
                  onPressed: () async {
                    // عند الضغط على الزر، يتم عرض مربع حوار تأكيد قبل تنفيذ عملية التسجيل
                    final confirmed = await notify.showConfirmationDialog(
                      context,
                      'سيتم تقدم أرقام الدور لليوم الحالي.', // رسالة التأكيد المعروضة للمستخدم
                    );
                    if (!confirmed) {
                      return; // في حال لم يؤكد المستخدم، يتم إلغاء العملية
                    }

                    // تعبئة بيانات المريض من الحقول النصية
                    patient.email = emailController.text
                        .trim(); // حفظ البريد بعد إزالة الفراغات
                    patient.password = passwordController.text
                        .trim(); // حفظ كلمة المرور
                    patient.fullname = nameController.text
                        .trim(); // حفظ الاسم الكامل
                    patient.phoneNumber = phoneController.text
                        .trim(); // حفظ رقم الهاتف
                    patient.role = "Patient"; // تحديد دور المستخدم كـ "مريض"

                    // استدعاء دالة التسجيل الخاصة بالمريض، والتي تتولى إنشاء الحساب وحفظ البيانات
                    await patient.signup(
                      patient.email!, // البريد الإلكتروني للمريض
                      patient.password!, // كلمة مرور المريض
                      patient.fullname!, // الاسم الكامل للمريض
                      patient.phoneNumber!, // رقم هاتف المريض
                      patient.role!, // دور المريض في النظام
                      context, // تمرير السياق لاستخدامه في التنقل أو عرض الرسائل
                    );
                  },

                  child: Text("إنشاء حساب"), // نص الزر
                ),
              ],
            ), // محتوى الصفحة
          ),
        ),
      ),
    );
  }
}
