// lib/pages/signin.dart
import 'package:flutter/material.dart';
import 'package:prototype1/oop/users.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  UserC user = UserC();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Colors.amberAccent[200], // عنوان شريط التطبيق
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              "تسجيل الدخول",
              style: TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent[200],
              ),
            ),
            SizedBox(height: 50),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "أدخل بريدك الإلكتروني الشخصي",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "أدخل الرقم السري الشخصي",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print("Login button clicked!");
                user.email = emailController.text.trim();
                user.password = passwordController.text.trim();
                user.signin(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                  context,
                );
              },
              child: Text("تسجيل الدخول"),
            ),
          ],
        ), // محتوى الصفحة
      ),
    );
  }
}
