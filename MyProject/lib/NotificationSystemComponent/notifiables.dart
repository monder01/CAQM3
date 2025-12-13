import 'package:MyCAQM/NotificationSystemComponent/notifiables%20copy.dart';
import 'package:MyCAQM/NotificationSystemComponent/notifications.dart';
import 'package:flutter/material.dart';

class Notifiable extends StatefulWidget {
  const Notifiable({super.key});

  @override
  State<Notifiable> createState() => _NotifiableState();
}

class _NotifiableState extends State<Notifiable> {
  Notifiables notes = Notifiables();
  Notifications notify = Notifications();
  @override
  void initState() {
    super.initState();
    notes.showNotification(context);
    //notifiable.playMusic();
  }

  @override
  /*void dispose() {
    timer.cancel();
    super.dispose();
  }*/
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
              },
              child: Text('Play music'),
            ),
          ],
        ),
      ),
    );
  }
}
