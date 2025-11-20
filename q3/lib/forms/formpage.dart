import 'package:flutter/material.dart';
import 'InsuranceFormPage.dart';
import 'MedicalHistoryFormPage.dart';

class FormHomePage extends StatelessWidget {
  const FormHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Forms"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InsuranceFormPage()),
                );
              },
              child: Text("Fill Insurance Form"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicalHistoryFormPage(),
                  ),
                );
              },
              child: Text("Fill Medical History"),
            ),
          ],
        ),
      ),
    );
  }
}
