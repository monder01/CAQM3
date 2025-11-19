//adminPage.dart
import 'package:flutter/material.dart';
import 'package:q3/appointmentManage.dart';
import 'AdminFormsPage.dart';
import 'addDoctorPage.dart';
import 'oobclass/doctors.dart';
import 'oobclass/users.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Adddoctorpage()),
              );
            },
            label: Text("Add Doctor"),
            icon: Icon(Icons.add),
          ),

          SizedBox(height: 20),

          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminFormsPage()),
              );
            },
            label: Text("View Patient Forms"),
            icon: Icon(Icons.file_present),
            backgroundColor: Colors.blue,
          ),

          SizedBox(height: 20),

          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPatientAppointmentsPage(),
                ),
              );
            },
            label: Text("Manage appointments"),
            icon: Icon(Icons.manage_history),
            backgroundColor: Colors.amberAccent,
          ),
        ],
      ),
    );
  }
}
