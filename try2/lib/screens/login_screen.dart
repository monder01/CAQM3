import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/patients.dart';
import '../models/Doctors.dart';
import '../models/Admins.dart';
import 'patient_home.dart';
import 'doctor_home.dart';
import 'admin_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  String? error;
  bool loading = false;

  void login() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final user = await _auth.signIn(
        email: emailC.text.trim(),
        password: passwordC.text.trim(),
      );

      if (user == null) {
        setState(() => error = 'User not found');
        return;
      }

      // التوجيه حسب الدور بدون شرط النوع
      if (user.role == 'patient') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PatientHome(user: user as Patient)),
        );
      } else if (user.role == 'doctor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DoctorHome(user: user as Doctor)),
        );
      } else if (user.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminHome(user: user as Admin)),
        );
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordC,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(error!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: loading ? CircularProgressIndicator() : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
