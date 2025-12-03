import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prototype1/pages/homePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // التأكد من تهيئة ربط فلاتر قبل تنفيذ أي عمليات غير متزامنة
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // تهيئة خدمات فايربيز باستخدام الإعدادات الخاصة بالمنصة الحالية
  runApp(MyApp()); // تشغيل التطبيق وإرسال الواجهة الأساسية إليه
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Clinc", // تعيين عنوان التطبيق
      home:
          Homepage(), // تحديد الصفحة الرئيسية التي يتم عرضها عند بدء تشغيل التطبيق
    );
  }
}
