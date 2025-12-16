//signin.dart
import 'package:MyCAQM/UserManagementComponent/signup.dart';
import 'package:flutter/material.dart'; // استيراد مكتبة الواجهات الرسومية الخاصة بفلاتر
import '/UserManagementComponent/users.dart'; // استيراد كلاس المستخدم الأساسي UserC

class Signin extends StatefulWidget {
  final UserC? user;
  const Signin({
    super.key,
    this.user,
  }); // ويدجت تسجيل الدخول، من نوع Stateful لأنها تعتمد على مدخلات المستخدم

  @override
  State<Signin> createState() => _SigninState(); // ربط الصفحة بحالة State خاصة بها
}

class _SigninState extends State<Signin> {
  late final UserC
  user; // إنشاء كائن من UserC لتخزين بيانات تسجيل الدخول وتنفيذ وظيفة signin
  TextEditingController emailController =
      TextEditingController(); // متحكم لحقل إدخال البريد الإلكتروني
  TextEditingController passwordController =
      TextEditingController(); // متحكم لحقل إدخال كلمة المرور
  String? selectedValue; // القيمة المختارة من القائمة المنسدلة
  @override
  void initState() {
    super.initState();
    user = widget.user ?? UserC();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "عيادتي",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ), // عنوان الصفحة في شريط التطبيق
        backgroundColor: Colors.amberAccent[200], // لون خلفية الـ AppBar
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // يسمح بالتمرير في حال كانت العناصر كثيرة
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // محاذاة المحتوى للأعلى

                children: [
                  SizedBox(height: 50), // مسافة علوية كبيرة
                  Icon(
                    Icons
                        .local_hospital, // أيقونة قفل للدلالة على صفحة تسجيل الدخول
                    size: 100,
                    color: Colors.amberAccent[200],
                  ),
                  SizedBox(height: 50),

                  // حقل إدخال البريد الإلكتروني
                  TextField(
                    controller: emailController, // ربط الحقل بالمتحكم
                    decoration: InputDecoration(
                      labelText:
                          "أدخل بريدك الإلكتروني الشخصي", // النص الإرشادي داخل الحقل
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ), // إطار حول الحقل
                    ),
                  ),

                  SizedBox(height: 20),

                  // حقل إدخال كلمة المرور
                  TextField(
                    obscureText: true, // إخفاء النص عند كتابة كلمة المرور
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "أدخل الرقم السري الشخصي", // النص الإرشادي
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  SizedBox(height: 20),
                  // زر تسجيل الدخول
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: Colors.grey[350],
                    ),
                    onPressed: () async {
                      print(
                        "Login button clicked!",
                      ); // طباعة نص للتأكد من ضغط الزر أثناء التنفيذ

                      // تخزين الإدخالات في كائن user
                      user.email = emailController.text.trim();
                      user.password = passwordController.text.trim();

                      // استدعاء دالة تسجيل الدخول الموجودة داخل كلاس UserC
                      user.signin(
                        emailController.text
                            .trim(), // البريد المدخل بعد إزالة الفراغات
                        passwordController.text.trim(), // كلمة المرور
                        context, // تمرير السياق لإنشاء التنقل أو رسائل الخطأ
                      );
                    },
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ), // نص الزر
                  ),
                  SizedBox(height: 20), // مسافة بين العناصر
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: Colors.grey[350],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: Text(
                      "ليس لديك حساب؟ سجل الآن",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "عن طريق تسجيل الدخول، فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ), // محتوى الصفحة
            ),
          ),
        ),
      ),
    );
  }
}
