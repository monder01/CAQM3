import 'package:flutter/material.dart';
import '../models/Doctors.dart';
import '../services/auth_service.dart';

class DoctorHome extends StatelessWidget {
  final Doctor user; // تأكد أننا نستقبل Doctor مباشرة
  const DoctorHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Dr. ${user.fullName}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Specialty: ${user.specialty}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Role: ${user.role}'),
          ],
        ),
      ),
    );
  }
}
