import 'package:flutter/material.dart';

class Notification {
  String? title;
  String? massage;

  Future<void> setnot(String title1, String massage1) async {
    title = title1;
    massage = massage1;
  }

  Future<void> clear() async {
    title = null;
    massage = null;
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "مرحبا بك في عيادتنا ✅ ",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
              child: Text('press me'),
            ),
          ],
        ),
      ),
    );
  }
}
