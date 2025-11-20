// homePage.dart
import 'package:flutter/material.dart';
import 'UserManage/signin.dart';
import 'UserManage/signup.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // شريط التطبيق العلوي
      appBar: AppBar(
        title: Text("My Clinic"),
        backgroundColor: Colors.amberAccent[200],
      ),

      // يضمن عدم تداخل المحتوى مع حواف الجهاز
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // توسيط العناصر عمودياً
            children: [
              // نص الترحيب الرئيسي
              Text(
                "Welcome to My Clinic",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent[200],
                ),
              ),

              SizedBox(height: 20), // مسافة بين العناصر
              // زر تسجيل الدخول
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signin()),
                  );
                },
                child: Text("Already Have An Account"),
              ),

              SizedBox(height: 20),

              // زر إنشاء حساب جديد
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
                child: Text("Create New Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
