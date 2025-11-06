import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../tuser.dart';
import '../tdoctor.dart';
import '../tpatient.dart';
import '../tadmin.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();

  String _selectedRole = 'patient';
  bool _loading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // إنشاء المستخدم في Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = result.user;
      if (user == null) throw Exception("فشل إنشاء الحساب");

      // إنشاء كائن مستخدم بناءً على الدور
      dynamic newUser;
      switch (_selectedRole) {
        case 'doctor':
          newUser = Doctor(
            fullname: _fullnameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            role: _selectedRole,
            userId: user.uid,
            specialization: _specializationController.text.trim(),
          );
          break;
        case 'admin':
          newUser = Admin(
            fullname: _fullnameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            role: _selectedRole,
            userId: user.uid,
          );
          break;
        default:
          newUser = Patient(
            fullname: _fullnameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            role: _selectedRole,
            userId: user.uid,
          );
      }

      // حفظ البيانات في Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(newUser.toMap(), SetOptions(merge: true));

      // بعد التسجيل الناجح
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
      ).showSnackBar(SnackBar(content: Text('خطأ: ${e.message}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullnameController,
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                validator: (v) =>
                    v!.isEmpty ? 'الرجاء إدخال الاسم الكامل' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                ),
                validator: (v) =>
                    v!.isEmpty ? 'الرجاء إدخال البريد الإلكتروني' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'كلمة المرور'),
                obscureText: true,
                validator: (v) => v!.length < 6
                    ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                    : null,
              ),
              const SizedBox(height: 16),

              // اختيار الدور
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(labelText: 'الدور'),
                items: const [
                  DropdownMenuItem(value: 'patient', child: Text('مريض')),
                  DropdownMenuItem(value: 'doctor', child: Text('طبيب')),
                  DropdownMenuItem(value: 'admin', child: Text('مدير')),
                ],
                onChanged: (value) {
                  setState(() => _selectedRole = value!);
                },
              ),

              // إذا كان طبيب، أضف التخصص
              if (_selectedRole == 'doctor') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(labelText: 'التخصص'),
                  validator: (v) => v!.isEmpty ? 'أدخل التخصص' : null,
                ),
              ],

              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('إنشاء الحساب'),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
                child: const Text('هل لديك حساب؟ تسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
