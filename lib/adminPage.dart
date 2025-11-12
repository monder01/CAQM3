//adminPage.dart
import 'package:flutter/material.dart';
import 'addDoctorPage.dart';
import 'doctors.dart';
import 'users.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Users user = Users();
  Doctors doctor = Doctors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Page"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Adddoctorpage()),
            );
          },
          tooltip: "Add Doctor",
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
