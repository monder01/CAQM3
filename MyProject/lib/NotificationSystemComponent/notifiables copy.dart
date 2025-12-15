import 'package:MyCAQM/NotificationSystemComponent/notifications.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class Notifiables {
  String message = '';
  Notifications notify = Notifications();
  final player = AudioPlayer();
  late Timer timer;
  //-------------------------------------------------------------
  Future<void> playMusic() async {
    await player.play(
      UrlSource('https://luan.xyz/files/audio/ambient_c_motion.mp3'),
    );
  }

  Future<void> stopMusic() async {
    print("Attempting to stop reminder music");
    await player.stop();
  }

  //--------------------------------------------------------------------------
  Future<bool> playReminder(
    BuildContext context, // السياق المطلوب لعرض مربع الحوار
    String message, // الرسالة التي ستظهر داخل مربع التأكيد
  ) async {
    this.message =
        message; // تخزين الرسالة داخل الكائن لاستخدامها مستقبلاً إن لزم ذلك

    // فتح مربع حوار من نوع AlertDialog وإرجاع قيمة منطقية حسب اختيار المستخدم
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible:
          true, // السماح بإغلاق مربع الحوار عند الضغط خارجَه أو بالرجوع
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'بقي على موعدك أقل من 5 دقايق ⌛', // عنوان مربع الحوار
            textAlign: TextAlign.right, // جعل النص بمحاذاة اليمين (العربية)
            style: TextStyle(fontWeight: FontWeight.bold), // جعل الخط عريضًا
          ),
          content: Text(
            message, // عرض الرسالة المرسلة للتابع
            textAlign: TextAlign.right, // محاذاة النص لليمين
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ), // لون مميز للرسالة
          ),
          actions: [
            TextButton(
              // زر الإلغاء
              onPressed: () {
                stopMusic();
                Navigator.of(context).pop(true);
              },
              // إرجاع true عند الإلغاء
              child: const Text(
                'تخطي',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    // إذا أغلق المستخدم مربع الحوار بدون اختيار، اعتبر القيمة false
    return result ?? false;
  }

  void showNotification(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      TimeOfDay timeNow = TimeOfDay.now();
      DateTime dateNow = DateTime.now();
      String formattedTime = timeNow.format(context);
      String formattedDate = dateNow.toIso8601String().substring(0, 10);
      String tryDate = '2025-12-15';
      String tryTime = '7:08 PM';
      if (formattedTime == tryTime && formattedDate == tryDate) {
        print('Time: $formattedTime Date: $formattedDate');
        playReminder(context, 'الرجاء تجهيز نفسك ⏱️ ');
        playMusic();
      }
    });
  }
}
