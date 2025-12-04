//queues.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueueL {
  DateTime? checkInTime;
  String? queueId;
  String? status; // e.g., "pending", "completed", "canceled"
  String? token;
  int? lineNumber = 0;

  Future<void> checkInPatient(
    String appointmentId,
    BuildContext context,
    String patientname,
  ) async {
    DateTime? dateNow = DateTime.now();
    String formattedDate = dateNow.toIso8601String().substring(0, 10);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('Queue').get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var queueDoc = querySnapshot.docs.first;
        lineNumber = queueDoc['TodayLineNumber'] + 1;

        // Update the Today's Line Number in the Queue collection
        firestore.collection('Queue').doc(queueDoc.id).update({
          'TodayLineNumber': lineNumber,
        });
      } else {
        // If no queue document exists, create one
        lineNumber = 1;
        firestore.collection('Queue').add({
          'TodayLineNumber': lineNumber,
          'date': formattedDate,
        });
      }
    });
    // Update the appointment status and line number

    await firestore.collection('Appointments').doc(appointmentId).update({
      'status': 'CheckedIn',
      'LineNumber': lineNumber,
    });

    // Optionally, you can also log the check-in time
    checkInTime = DateTime.now();
  }
}
