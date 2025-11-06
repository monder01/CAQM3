import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tdoctor.dart';
import '../tpatient.dart';
import '../tuser.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String? fullname;
  String? email;
  String? phone;
  String? password;
  String? role = 'patient';
  String? specialization;

  bool _loading = false;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _loading = true);

    try {
      // إنشاء المستخدم في Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email!, password: password!);

      String userId = userCredential.user!.uid;

      Users newUser;

      // 🔹 إذا كان طبيب
      if (role == 'doctor') {
        Doctor newDoctor = Doctor()
          ..fullname = fullname
          ..email = email
          ..phoneNumber = phone
          ..role = role
          ..userId = userId
          ..doctorId =
              userId // ✅ مهم جدًا
          ..specialization = specialization;

        newUser = newDoctor;

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'fullname': newDoctor.fullname,
          'email': newDoctor.email,
          'phoneNumber': newDoctor.phoneNumber,
          'role': newDoctor.role,
          'userId': newDoctor.userId,
          'doctorId': newDoctor.doctorId,
          'specialization': newDoctor.specialization,
        });
      }
      // 🔹 إذا كان مريض
      else {
        Patient newPatient = Patient()
          ..fullname = fullname
          ..email = email
          ..phoneNumber = phone
          ..role = role
          ..userId = userId;

        newUser = newPatient;

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'fullname': newPatient.fullname,
          'email': newPatient.email,
          'phoneNumber': newPatient.phoneNumber,
          'role': newPatient.role,
          'userId': newPatient.userId,
        });
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب بنجاح!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: ${e.message}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                  onSaved: (val) => fullname = val,
                  validator: (val) =>
                      val!.isEmpty ? 'يرجى إدخال الاسم الكامل' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                  ),
                  onSaved: (val) => email = val,
                  validator: (val) =>
                      val!.isEmpty ? 'يرجى إدخال البريد الإلكتروني' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                  onSaved: (val) => phone = val,
                  validator: (val) =>
                      val!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  obscureText: true,
                  onSaved: (val) => password = val,
                  validator: (val) =>
                      val!.length < 6 ? 'كلمة المرور قصيرة جدًا' : null,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: role,
                  items: const [
                    DropdownMenuItem(value: 'patient', child: Text('مريض')),
                    DropdownMenuItem(value: 'doctor', child: Text('طبيب')),
                  ],
                  onChanged: (val) {
                    setState(() => role = val);
                  },
                  decoration: const InputDecoration(labelText: 'الدور'),
                ),
                if (role == 'doctor')
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'التخصص الطبي',
                    ),
                    onSaved: (val) => specialization = val,
                    validator: (val) {
                      if (role == 'doctor' && (val == null || val.isEmpty)) {
                        return 'يرجى إدخال التخصص';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 25),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('تسجيل'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
