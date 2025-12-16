import 'package:MyCAQM/UserManagementComponent/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin(); // إنشاء مثيل لإدارة الإشعارات المحلية
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // التأكد من تهيئة ربط فلاتر قبل تنفيذ أي عمليات غير متزامنة
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // تهيئة خدمات فايربيز باستخدام الإعدادات الخاصة بالمنصة الحالية
  // تهيئة الإشعارات
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );
  await notificationsPlugin.initialize(settings);

  runApp(MyApp()); // تشغيل التطبيق وإرسال الواجهة الأساسية إليه
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Clinc", // تعيين عنوان التطبيق
      home:
          Signin(), // تحديد الصفحة الرئيسية التي يتم عرضها عند بدء تشغيل التطبيق
    );
  }
}
