//queues.dart
import 'package:flutter/material.dart';

class QueueL {
  DateTime? checkInTime;
  String? queueId;
  String? status; // e.g., "pending", "completed", "canceled"
  String? token;
  int? lineNumber = 0;

  void queueCalc(BuildContext context) {}
}
