import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patients.dart';
import '../models/doctors.dart';
import '../models/admins.dart';

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String usersCollection = 'users';

  // تسجيل مستخدم جديد
  Future<dynamic> signUp({
    required String firstName,
    required String secondName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
    String? specialty,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final String userId = cred.user!.uid;

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

    // إرجاع النوع الصحيح
    if (role == 'patient') {
      return Patient(
        userId: userId,
        firstName: firstName,
        secondName: secondName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      );
    } else if (role == 'doctor') {
      return Doctor(
        userId: userId,
        firstName: firstName,
        secondName: secondName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        specialty: specialty ?? '',
      );
    } else if (role == 'admin') {
      return Admin(
        userId: userId,
        firstName: firstName,
        secondName: secondName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      );
    } else {
      throw Exception('Unknown role');
    }
  }

  // تسجيل الدخول
  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _firestore.collection(usersCollection).doc(cred.user!.uid).get();

    if (!doc.exists) return null;
    final data = doc.data()!;
    final role = data['role'] ?? 'patient';

    if (role == 'patient') {
      return Patient(
        userId: cred.user!.uid,
        firstName: data['firstName'] ?? '',
        secondName: data['secondName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
      );
    } else if (role == 'doctor') {
      return Doctor(
        userId: cred.user!.uid,
        firstName: data['firstName'] ?? '',
        secondName: data['secondName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        specialty: data['specialty'] ?? '',
      );
    } else if (role == 'admin') {
      return Admin(
        userId: cred.user!.uid,
        firstName: data['firstName'] ?? '',
        secondName: data['secondName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
      );
    } else {
      throw Exception('Unknown role');
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
