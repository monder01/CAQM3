//queues.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QueueL {
  DateTime? checkInTime;
  String? queueId;
  String? status; // e.g., "pending", "completed", "canceled"
  String? token;
  int? lineNumber = 0;

  /// تسجيل وصول المريض
  Future<void> checkInPatient(BuildContext context, String queueId) async {
    final queueRef = FirebaseFirestore.instance
        .collection('Queues')
        .doc(queueId);
  }
}
