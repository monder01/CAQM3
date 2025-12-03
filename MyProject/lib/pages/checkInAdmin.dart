import 'package:flutter/material.dart';

class Checkinadmin extends StatefulWidget {
  const Checkinadmin({super.key});

  @override
  State<Checkinadmin> createState() => _CheckinadminState();
}

class _CheckinadminState extends State<Checkinadmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل وصول المريض'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Center(child: Text('صفحة تسجيل وصول المريض قيد التطوير')),
    );
  }
}
