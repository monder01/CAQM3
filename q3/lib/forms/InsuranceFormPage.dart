import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsuranceFormPage extends StatefulWidget {
  const InsuranceFormPage({super.key});

  @override
  State<InsuranceFormPage> createState() => _InsuranceFormPageState();
}

class _InsuranceFormPageState extends State<InsuranceFormPage> {
  // مفتاح النموذج للتحقق من صحة المدخلات
  final _formKey = GlobalKey<FormState>();

  // متحكمات الحقول للحصول على النص المكتوب في كل خانة
  final insuranceCompany = TextEditingController();
  final policyNumber = TextEditingController();
  final cardNumber = TextEditingController();
  final expiryDate = TextEditingController();
  final insuranceType = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // شريط العنوان في أعلى الصفحة
      appBar: AppBar(
        title: Text("Insurance Details"),
        backgroundColor: Colors.amberAccent,
      ),

      // يسمح بالتمرير عند امتلاء الشاشة
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey, // ربط النموذج بمفتاح التحقق
          child: Column(
            children: [
              // حقول الإدخال الخاصة بنموذج التأمين
              buildInput("Insurance Company", insuranceCompany),
              buildInput("Policy Number", policyNumber),
              buildInput("Card Number", cardNumber),
              buildInput("Expiry Date", expiryDate),
              buildInput("Insurance Type", insuranceType),

              SizedBox(height: 20),

              // زر حفظ البيانات
              ElevatedButton(
                onPressed: saveInsuranceForm,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة إنشاء حقل إدخال نصي واحد
  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12), // مسافة بين الحقول
      child: TextFormField(
        controller: controller, // ربط المتحكم بالحقل
        decoration: InputDecoration(
          labelText: label, // عنوان الحقل
          border: OutlineInputBorder(), // إطار الحقل
        ),
      ),
    );
  }

  // دالة حفظ بيانات نموذج التأمين في Firestore
  Future<void> saveInsuranceForm() async {
    await FirebaseFirestore.instance.collection("InsuranceForms").add({
      "insuranceCompany": insuranceCompany.text,
      "policyNumber": policyNumber.text,
      "cardNumber": cardNumber.text,
      "expiryDate": expiryDate.text,
      "insuranceType": insuranceType.text,
      "createdAt": Timestamp.now(), // وقت إدخال البيانات
    });

    // إظهار رسالة نجاح بعد الحفظ
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Insurance form submitted")));

    // العودة إلى الصفحة السابقة بعد الإرسال
    Navigator.pop(context);
  }
}
