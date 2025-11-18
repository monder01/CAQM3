//signup.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:st1/homePage.dart';
import 'users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Users users = Users();
  final TextEditingController fullNamecon = TextEditingController();
  final TextEditingController emailcon = TextEditingController();
  final TextEditingController passwordcon = TextEditingController();
  final TextEditingController phoneNumcon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: fullNamecon,
                decoration: InputDecoration(
                  labelText: "Full name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailcon,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordcon,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneNumcon,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  users.fullname = fullNamecon.text;
                  users.email = emailcon.text;
                  users.password = passwordcon.text;
                  users.phoneNumber = phoneNumcon.text;
                  users.role = "Patient";
                  try {
                    UserCredential userinfo = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: users.email!,
                          password: users.password!,
                        );
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userinfo.user!.uid)
                        .set({
                          'Full Name': users.fullname,
                          'Email': users.email,
                          'Phone Number': users.phoneNumber,
                          'Role': users.role,
                        });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                    print(
                      "✅ Account created successfully for ${users.fullname}",
                    );
                  } catch (e) {
                    print("❌ Error: $e");
                  }
                },
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
