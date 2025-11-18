import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adminPage.dart';
import 'appointmentsListPage.dart';
import 'users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  Users user = Users();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: user.emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: user.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  user.email = user.emailController.text;
                  user.password = user.passwordController.text;
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: user.email!,
                          password: user.password!,
                        );

                    // 🔹 جلب بيانات المستخدم من Firestore
                    var doc = await FirebaseFirestore.instance
                        .collection('users') // أو 'Admin' حسب قاعدة بياناتك
                        .doc(userCredential.user!.uid)
                        .get();

                    String role = doc['Role']; // "Patient" أو "Admin"

                    // 🔹 الانتقال حسب الدور
                    if (role == 'Admin') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Admin()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAppointmentsPage(),
                        ),
                      );
                    }

                    print("✅ Login successful! Role: $role");
                  } catch (e) {
                    print("❌ Error: $e");
                  }
                },
                child: Text("login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
