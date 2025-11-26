import 'package:flutter/material.dart';
import 'package:q3/forms/InsuranceFormPage.dart';
import 'package:q3/forms/MedicalHistoryFormPage.dart';

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
          child: Column(
            children: [
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Insurancepage()),
                  );
                },
                child: Text("تعبئة النموذج التأمين"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Medicalhistorypage(),
                    ),
                  );
                },
                child: Text("تعبئة نموذج السجل المرضي"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
