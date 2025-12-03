import 'package:flutter/material.dart';
import 'package:prototype1/pages/addAppointmentPage.dart';
import 'package:prototype1/pages/showAppointment.dart';

class Appointmentpage extends StatefulWidget {
  const Appointmentpage({super.key});

  @override
  State<Appointmentpage> createState() => _AppointmentpageState();
}

class _AppointmentpageState extends State<Appointmentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAppointmentPage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "إضافة موعد جديد",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Showappointment()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "عرض المواعيد السابقة",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
