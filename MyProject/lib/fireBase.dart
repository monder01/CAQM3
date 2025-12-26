import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MyCAQM/NotificationSystemComponent/notifications.dart';

class FirebaseService {
  // Singleton بيتم استخدامه في جميع المستخدمين
  static final FirebaseService _instance = FirebaseService._internal();
  // Private constructor بيتم استخدامه في الكلاس
  FirebaseService._internal();
  static FirebaseService get instance => _instance;
  // Firebase ليتم استخدامه في جميع الصفحات
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Notifications notify = Notifications();
}
