import 'package:flutter/material.dart';

class Notifications {
  String message = '';

  Future<bool> showConfirmationDialog(
    BuildContext context,
    String message,
  ) async {
    this.message = message;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true, // يقدر يقفله من برا أو بالـ back
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'هل أنت متأكد؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message, textAlign: TextAlign.right),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            SizedBox(width: 100),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );

    // لو تسكر الديالوج بدون اختيار، اعتبره false
    return result ?? false;
  }
}
