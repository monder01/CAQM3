// homePage.dart
import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // شريط التطبيق العلوي
      appBar: AppBar(
        title: Text(
          "عيادتي",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.amberAccent[200],
        centerTitle: true,
      ),

      // يضمن عدم تداخل المحتوى مع حواف الجهاز
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // توسيط العناصر عمودياً
            children: [
              SizedBox(height: 100), // مسافة فارغة في الأعلى
              // نص الترحيب الرئيسي
              Text(
                "أهلاً بك في عيادتي",
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
