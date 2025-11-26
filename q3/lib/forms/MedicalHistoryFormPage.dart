import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Medicalhistorypage extends StatefulWidget {
  const Medicalhistorypage({super.key});

  @override
  State<Medicalhistorypage> createState() => _MedicalhistorypageState();
}

class _MedicalhistorypageState extends State<Medicalhistorypage> {
  final TextEditingController chronicDiseasesController =
      TextEditingController();
  final TextEditingController surgeriesController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();
  final TextEditingController familyHistoryController = TextEditingController();
  final TextEditingController vaccinationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("نموذج السجل المرضي"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: chronicDiseasesController,
              decoration: InputDecoration(
                labelText: "الأمراض المزمنة",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: surgeriesController,
              decoration: InputDecoration(
                labelText: "العمليات الجراحية السابقة",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: allergiesController,
              decoration: InputDecoration(
                labelText: "الحساسية",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: medicationsController,
              decoration: InputDecoration(
                labelText: "الأدوية الحالية",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: familyHistoryController,
              decoration: InputDecoration(
                labelText: "التاريخ العائلي للأمراض",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: vaccinationController,
              decoration: InputDecoration(
                labelText: "التطعيمات",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                // حفظ بيانات التأمين أو تنفيذ أي عملية أخرى
                String chronicDiseases = chronicDiseasesController.text;
                String surgeries = surgeriesController.text;
                String allergies = allergiesController.text;
                String medications = medicationsController.text;
                String familyHistory = familyHistoryController.text;
                String vaccination = vaccinationController.text;
                String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
                if (currentUserId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("يجب تسجيل الدخول أولًا")),
                  );
                  return;
                }
                try {
                  // حفظ البيانات في Firestore
                  await FirebaseFirestore.instance
                      .collection('MedicalHistory')
                      .add({
                        'ChronicDiseases': chronicDiseases,
                        'Surgeries': surgeries,
                        'Allergies': allergies,
                        'Medications': medications,
                        'FamilyHistory': familyHistory,
                        'Vaccination': vaccination,
                        'PatientId': currentUserId,
                      });
                } catch (e) {
                  print("خطأ في حفظ بيانات التأمين: $e");
                }
                // يمكنك إضافة الكود لحفظ هذه البيانات في قاعدة البيانات هنا

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("تم حفظ بيانات التأمين بنجاح ✅")),
                );
              },
              child: Text("حفظ بيانات التأمين"),
            ),
          ],
        ),
      ),
    );
  }
}
