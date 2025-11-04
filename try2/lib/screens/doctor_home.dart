import 'package:flutter/material.dart';
import '../models/Users.dart';
import '../services/auth_service.dart';

class DoctorHome extends StatelessWidget {
  final User user;
  const DoctorHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Dr. ${user.fullName}'),
            Text('Role: ${user.role}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pop(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
