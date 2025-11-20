import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:q3/AdminFindPatientPage.dart';
import 'package:q3/adminQueuePage.dart';
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
      body: Center(
        child: Text(
          "Welcome, Admin!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),

      // ✅ SpeedDial Floating Button
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.amberAccent[200],
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 10,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Add Doctor",
            backgroundColor: Colors.blueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Adddoctorpage()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.manage_history),
            label: "Manage Appointments",
            backgroundColor: Colors.amberAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminFindPatientPage()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.queue),
            label: "Manage Queue",
            backgroundColor: Colors.redAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QueuePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
