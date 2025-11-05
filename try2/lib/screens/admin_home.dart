import 'package:flutter/material.dart';
import '../models/admins.dart';
import '../services/auth_service.dart';

class AdminHome extends StatelessWidget {
  final Admin user; // تأكد أننا نستقبل Admin مباشرة
  const AdminHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
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
            Text('Welcome ${user.fullName}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text('Role: ${user.role}'),
            SizedBox(height: 16),
            // يمكن إضافة أزرار إدارة المستخدمين أو المواعيد هنا لاحقًا
          ],
        ),
      ),
    );
  }
}
