import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Users.dart';
import '../models/Patients.dart';
import '../models/Doctors.dart';
import '../models/Admins.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // مجموعة المستخدمين في Firestore
  final String usersCollection = 'users';

  // تسجيل مستخدم جديد
  Future<User> signUp({
    required String firstName,
    required String secondName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
    String? specialty,
  }) async {
    // إنشاء حساب Firebase
    final fb.UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final String userId = cred.user!.uid;

    // إنشاء الكائن المناسب
    User user;
    if (role == 'patient') {
      user = Patient(
        userId: userId,
        firstName: firstName,
        secondName: secondName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      );
    } else if (role == 'doctor') {
      user = Doctor(
        userId: userId,
        firstName: firstName,
        secondName: secondName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        specialty: specialty ?? '',
      );
    } else if (role == 'admin') {
      user = Admin(
        userId: userId,
        firstName: firstName,
        secondName: secondName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      );
    } else {
      throw Exception('Invalid role');
    }

    // حفظ البيانات في Firestore
    await _firestore.collection(usersCollection).doc(userId).set({
      'firstName': firstName,
      'secondName': secondName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      if (role == 'doctor') 'specialty': specialty ?? '',
    });

    return user;
  }

  // تسجيل الدخول
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final fb.UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final String userId = cred.user!.uid;
    final doc = await _firestore.collection(usersCollection).doc(userId).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    final role = data['role'] ?? 'patient';

    if (role == 'patient') {
      return Patient(
        userId: userId,
        firstName: data['firstName'] ?? '',
        secondName: data['secondName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
      );
    } else if (role == 'doctor') {
      return Doctor(
        userId: userId,
        firstName: data['firstName'] ?? '',
        secondName: data['secondName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        specialty: data['specialty'] ?? '',
      );
    } else if (role == 'admin') {
      return Admin(
        userId: userId,
        firstName: data['firstName'] ?? '',
        secondName: data['secondName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
      );
    } else {
      return null;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
