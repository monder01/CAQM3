import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:st1/homePage.dart';
import 'appointmentsPages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "My Clinc", home: Homepage());
  }
}
