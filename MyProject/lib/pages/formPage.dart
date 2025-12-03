import 'package:flutter/material.dart';
import 'package:prototype1/pages/insurancePage.dart';
import 'package:prototype1/pages/medicalHistoryPage.dart';

class Formpage extends StatefulWidget {
  const Formpage({super.key});

  @override
  State<Formpage> createState() => _FormpageState();
}

class _FormpageState extends State<Formpage> {
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
                    MaterialPageRoute(builder: (context) => Insurancepage()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "تعبئة بيانات التأمين",
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
                    MaterialPageRoute(
                      builder: (context) => Medicalhistorypage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_edu,
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "تعبئة بيانات التاريخ الطبي",
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
