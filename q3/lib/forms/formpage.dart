import 'package:flutter/material.dart';
import 'InsuranceFormPage.dart';
import 'MedicalHistoryFormPage.dart';

class FormHomePage extends StatelessWidget {
  const FormHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // واجهة التطبيق الأساسية
      appBar: AppBar(
        // عنوان الصفحة في شريط التطبيق
        title: Text("Patient Forms"),
        backgroundColor: Colors.amberAccent,
      ),

      body: Center(
        // وضع العناصر في منتصف الشاشة
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر الانتقال إلى صفحة نموذج التأمين
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  // الانتقال إلى صفحة التأمين عند الضغط على الزر
                  MaterialPageRoute(builder: (context) => InsuranceFormPage()),
                );
              },
              child: Text("Fill Insurance Form"),
            ),

            SizedBox(height: 20), // مسافة بين الأزرار
            // زر الانتقال إلى صفحة السجل الطبي
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  // الانتقال إلى صفحة السجل الطبي
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
