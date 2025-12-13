import 'package:MyCAQM/NotificationSystemComponent/notifications.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class Notifiable {
  Notifications notify = Notifications();
  final player = AudioPlayer();
  late Timer timer;
  //-------------------------------------------------------------
  void showNotification(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      TimeOfDay timeNow = TimeOfDay.now();
      DateTime dateNow = DateTime.now();
      String formattedTime = timeNow.format(context);
      String formattedDate = dateNow.toIso8601String().substring(0, 10);
      String tryDate = '2025-12-14';
      String tryTime = '12:30 AM';
      if (formattedTime == tryTime && formattedDate == tryDate) {
        print('Time: $formattedTime Date: $formattedDate');
        notify.showConfirmationDialog(context, 'Date Matched!');
      }
    });
  }

  Future<void> playMusic() async {
    await player.play(
      UrlSource('https://luan.xyz/files/audio/ambient_c_motion.mp3'),
    );
  }
}
