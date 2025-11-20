import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalHistoryFormPage extends StatefulWidget {
  const MedicalHistoryFormPage({super.key});

  @override
  State<MedicalHistoryFormPage> createState() => _MedicalHistoryFormPageState();
}

class _MedicalHistoryFormPageState extends State<MedicalHistoryFormPage> {
  // مفتاح النموذج للتحقق من صحة المدخلات
  final _formKey = GlobalKey<FormState>();

  // متحكمات الحقول لجمع البيانات من المستخدم
  final conditions = TextEditingController();
  final medications = TextEditingController();
  final allergies = TextEditingController();
  final surgeries = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // شريط التطبيق العلوي
      appBar: AppBar(
        title: Text("Medical History"),
        backgroundColor: Colors.amberAccent,
      ),

      // السماح بالتمرير في حالة امتلاء الشاشة
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey, // ربط النموذج بمفتاح التحقق
          child: Column(
            children: [
              // حقول الإدخال الخاصة بالتاريخ الطبي
              buildInput("Chronic Conditions", conditions),
              buildInput("Medications", medications),
              buildInput("Allergies", allergies),
              buildInput("Surgeries", surgeries),

              SizedBox(height: 20),

              // زر لحفظ البيانات
              ElevatedButton(
                onPressed: saveMedicalHistory,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة تبني حقل إدخال متعدد الأسطر
  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12), // مسافة بين الحقول
      child: TextFormField(
        controller: controller, // ربط المتحكم بالحقل
        maxLines: 3, // جعل الحقل متعدد الأسطر
        decoration: InputDecoration(
          labelText: label, // عنوان الحقل
          border: OutlineInputBorder(), // إطار الحقل
        ),
      ),
    );
  }

  // دالة لحفظ البيانات داخل Firestore
  Future<void> saveMedicalHistory() async {
    await FirebaseFirestore.instance.collection("MedicalHistoryForms").add({
      "conditions": conditions.text,
      "medications": medications.text,
      "allergies": allergies.text,
      "surgeries": surgeries.text,
      "createdAt": Timestamp.now(), // وقت الحفظ
    });

    // إظهار رسالة نجاح بعد الحفظ
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Medical history submitted")));

    // العودة للصفحة السابقة
    Navigator.pop(context);
  }
}
