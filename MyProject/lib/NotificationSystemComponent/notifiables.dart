import 'dart:async';
import 'package:MyCAQM/NotificationSystemComponent/notifications.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Notifiable extends StatefulWidget {
  const Notifiable({super.key});

  @override
  State<Notifiable> createState() => _NotifiableState();
}

class _NotifiableState extends State<Notifiable> {
  Notifications notify = Notifications();
  final player = AudioPlayer();
  late Timer _timer;
  Future<void> playMusic() async {
    await player.play(
      UrlSource('https://luan.xyz/files/audio/ambient_c_motion.mp3'),
    );
  }

  @override
  void initState() {
    super.initState();

    // 2. استخدم Timer.periodic للتشغيل المتكرر
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      TimeOfDay timeNow = TimeOfDay.now();
      DateTime dateNow = DateTime.now();
      String formattedTime = timeNow.format(context);
      String formattedDate = dateNow.toIso8601String().substring(0, 10);
      String tryDate = '2025-12-13';
      String tryTime = '10:46 PM';
      if (formattedTime == tryTime && formattedDate == tryDate) {
        print('Time: $formattedTime Date: $formattedDate');
        notify.showConfirmationDialog(context, 'Date Matched!');
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحة الاشعارات'),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                print("music playing");
                playMusic();
              },
              child: Text('Play music'),
            ),
          ],
        ),
      ),
    );
  }
}
