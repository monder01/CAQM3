// lib/pages/signin.dart
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
        title: Text("Sign In"), // عنوان الصفحة في شريط التطبيق
        backgroundColor: Colors.amberAccent[200], // لون خلفية الـ AppBar
      ),
      body: SingleChildScrollView(
        // يسمح بالتمرير في حال كانت العناصر كثيرة
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // محاذاة المحتوى للأعلى

            children: [
              SizedBox(height: 50), // مسافة علوية كبيرة
              Text(
                "تسجيل الدخول", // عنوان رئيسي كبير
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent[200], // اللون الذهبي المميز للتطبيق
                ),
              ),
              SizedBox(height: 50),

              // حقل إدخال البريد الإلكتروني
              TextField(
                controller: emailController, // ربط الحقل بالمتحكم
                decoration: InputDecoration(
                  labelText:
                      "أدخل بريدك الإلكتروني الشخصي", // النص الإرشادي داخل الحقل
                  border: OutlineInputBorder(), // إطار حول الحقل
                ),
              ),

              SizedBox(height: 20),

              // حقل إدخال كلمة المرور
              TextField(
                obscureText: true, // إخفاء النص عند كتابة كلمة المرور
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "أدخل الرقم السري الشخصي", // النص الإرشادي
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(height: 20),
              // زر تسجيل الدخول
              ElevatedButton(
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
                child: Text("تسجيل الدخول"), // نص الزر
              ),
              SizedBox(height: 20), // مسافة بين العناصر
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
                child: Text("ليس لديك حساب؟ سجل الآن"),
              ),
            ],
          ), // محتوى الصفحة
        ),
      ),
    );
  }
}
