import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Checkinpatient extends StatefulWidget {
  const Checkinpatient({super.key});

  @override
  State<Checkinpatient> createState() => _CheckinpatientState();
}

class _CheckinpatientState extends State<Checkinpatient> {
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
