import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/FormManagementComponent/forms.dart';
import '/NotificationSystemComponent/notifications.dart';

class Medicalhistorypageb extends StatefulWidget {
  const Medicalhistorypageb({super.key});

  @override
  State<Medicalhistorypageb> createState() => _MedicalhistorypagebState();
}

class _MedicalhistorypagebState extends State<Medicalhistorypageb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("النموذج الطبي / التاريخ المرضي - النسخة ب"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Center(child: Text("هذه صفحة التاريخ المرضي - النسخة ب")),
    );
  }
}
