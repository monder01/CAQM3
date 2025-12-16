//notifiables.dart
import 'package:flutter/material.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';

class Notifiables {
  String message = '';
  final player = AudioPlayer();
  late Timer timer;
  //-------------------------------------------------------------
  Future<void> playNotification(String fileName) async {
    try {
      await player.setAsset('sounds/$fileName');
      await player.play();
    } catch (e) {
      print("Cannot play audio: $e");
    }
  }

  Future<void> stopMusic() async {
    print("Attempting to stop reminder music");
    await player.stop();
  }

  //--------------------------------------------------------------------------
  Future<bool> playReminder(BuildContext context, String message) async {
    if (!context.mounted) return false;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text(
          'حان الأن موعد الرجاء تجهيز نفسك في أسرع وقت',
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              stopMusic();
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text(
              'تخطي',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  //----------------------------------------------------------------------
  void receiveReminder(
    BuildContext context,
    String currentUser,
    int? currentLineNumber,
    int? userLineNumber,
  ) async {
    if (currentUser.isEmpty) {
      return;
    }
    if (currentLineNumber == userLineNumber) {
      playNotification('mixkit.wav');
      if (!context.mounted) {
        return;
      }
      await playReminder(
        context,
        "حان دورك الآن في العيادة. يرجى التوجه إلى الاستقبال.",
      );
      if (!context.mounted) {
        return;
      }
    }
  }
}
