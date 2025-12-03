// lib/pages/signup.dart
import 'package:flutter/material.dart';
import 'package:prototype1/oop/patients.dart';
import 'package:prototype1/oop/users.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  UserC user = UserC();
  Patient patient = Patient();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
          backgroundColor: Colors.amberAccent[200], // عنوان شريط التطبيق
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "إنشاء حساب جديد",
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent[200],
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "أدخل اسمك الكامل الثلاثي",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "أدخل بريدك الإلكتروني الشخصي",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "أدخل الرقم السري الشخصي",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "أدخل رقم هاتفك الشخصي",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  patient.email = emailController.text.trim();
                  patient.password = passwordController.text.trim();
                  patient.fullname = nameController.text.trim();
                  patient.phoneNumber = phoneController.text.trim();
                  patient.role = "Patient";
                  await patient.signup(
                    patient.email!,
                    patient.password!,
                    patient.fullname!,
                    patient.phoneNumber!,
                    patient.role!,
                    context,
                  );
                },

                child: Text("إنشاء حساب"),
              ),
            ],
          ), // محتوى الصفحة
        ),
      ),
    );
  }
}
