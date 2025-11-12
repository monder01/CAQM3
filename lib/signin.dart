import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:st1/appointmentsListPage.dart';
import 'package:st1/appointmentsPages.dart';
import 'package:st1/homePage.dart';
import 'users.dart';

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
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: user.email!,
                      password: user.password!,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAppointmentsPage(),
                      ),
                    );
                    print("✅ Login successful!");
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
