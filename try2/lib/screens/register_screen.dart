import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/patients.dart';
import '../models/doctors.dart';
import '../models/admins.dart';
import 'patient_home.dart';
import 'doctor_home.dart';
import 'admin_home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();

  final TextEditingController firstNameC = TextEditingController();
  final TextEditingController secondNameC = TextEditingController();
  final TextEditingController lastNameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController specialtyC =
      TextEditingController(); // للطبيب فقط

  String role = 'patient';
  String? error;
  bool loading = false;

  void register() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final user = await _auth.signUp(
        firstName: firstNameC.text.trim(),
        secondName: secondNameC.text.trim(),
        lastName: lastNameC.text.trim(),
        email: emailC.text.trim(),
        password: passwordC.text.trim(),
        role: role,
        phoneNumber: phoneC.text.trim(),
        specialty: role == 'doctor' ? specialtyC.text.trim() : null,
      );

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
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: firstNameC,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: secondNameC,
              decoration: InputDecoration(labelText: 'Second Name'),
            ),
            TextField(
              controller: lastNameC,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailC,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordC,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: phoneC,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            if (role == 'doctor')
              TextField(
                controller: specialtyC,
                decoration: InputDecoration(labelText: 'Specialty'),
              ),
            DropdownButton<String>(
              value: role,
              items: [
                DropdownMenuItem(value: 'patient', child: Text('Patient')),
                DropdownMenuItem(value: 'doctor', child: Text('Doctor')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (v) => setState(() => role = v!),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(error!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : register,
              child: loading ? CircularProgressIndicator() : Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
