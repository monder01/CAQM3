import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototype1/oop/forms.dart';

class Insurancepage extends StatefulWidget {
  const Insurancepage({super.key});

  @override
  State<Insurancepage> createState() => _InsurancepageState();
}

class _InsurancepageState extends State<Insurancepage> {
  Forms insuranceForm = Forms();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController policyNumberController = TextEditingController();
  TextEditingController insuredTypeController = TextEditingController();
  TextEditingController insuredStartDateController = TextEditingController();
  TextEditingController insuredEndDateController = TextEditingController();
  TextEditingController insuredPersonNameController = TextEditingController();
  TextEditingController insuredPersonIDController = TextEditingController();
  TextEditingController insuredNotesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("نموذج التأمين"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: companyNameController,
              decoration: InputDecoration(
                labelText: "اسم شركة التأمين",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: policyNumberController,
              decoration: InputDecoration(
                labelText: "رقم الوثيقة",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: insuredTypeController,
              decoration: InputDecoration(
                labelText: "نوع المؤمن عليه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: insuredStartDateController,
              decoration: InputDecoration(
                labelText: "تاريخ بدء التأمين",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: insuredEndDateController,
              decoration: InputDecoration(
                labelText: "تاريخ انتهاء التأمين",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: insuredPersonNameController,
              decoration: InputDecoration(
                labelText: "اسم الشخص المؤمن عليه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: insuredPersonIDController,
              decoration: InputDecoration(
                labelText: "رقم هوية الشخص المؤمن عليه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: insuredNotesController,
              decoration: InputDecoration(
                labelText: "ملاحظات إضافية",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                // حفظ بيانات التأمين أو تنفيذ أي عملية أخرى
                String companyName = companyNameController.text.trim();
                String policyNumber = policyNumberController.text.trim();
                String insuredType = insuredTypeController.text.trim();
                String insuredStartDate = insuredStartDateController.text
                    .trim();
                String insuredEndDate = insuredEndDateController.text.trim();
                String insuredPersonName = insuredPersonNameController.text
                    .trim();
                String insuredPersonID = insuredPersonIDController.text.trim();
                String insuredNotes = insuredNotesController.text.trim();
                // الحصول على معرف المستخدم الحالي
                String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
                try {
                  // حفظ البيانات في Firestore
                  await FirebaseFirestore.instance.collection('Insurance').add({
                    'CompanyName': companyName,
                    'PolicyNumber': policyNumber,
                    'InsuredType': insuredType,
                    'InsuredStartDate': insuredStartDate,
                    'InsuredEndDate': insuredEndDate,
                    'InsuredPersonName': insuredPersonName,
                    'InsuredPersonID': insuredPersonID,
                    'InsuredNotes': insuredNotes,
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
