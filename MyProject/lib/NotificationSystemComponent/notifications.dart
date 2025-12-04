import 'package:flutter/material.dart';

class Notifications {
  Future<bool> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('تأكيد'),
              content: Text('هل أنت متأكد؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('لا'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('نعم'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
