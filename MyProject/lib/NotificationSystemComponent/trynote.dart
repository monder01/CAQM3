import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Trynote extends StatefulWidget {
  const Trynote({super.key});

  @override
  State<Trynote> createState() => _TrynoteState();
}

class _TrynoteState extends State<Trynote> {
  final player = AudioPlayer();



  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trynote Notification")),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            
          },
          child: Text("Play Notification"),
        ),
      ),
    );
  }
}
