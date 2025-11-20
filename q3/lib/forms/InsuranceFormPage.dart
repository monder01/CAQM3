import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsuranceFormPage extends StatefulWidget {
  const InsuranceFormPage({super.key});

  @override
  State<InsuranceFormPage> createState() => _InsuranceFormPageState();
}

class _InsuranceFormPageState extends State<InsuranceFormPage> {
  final _formKey = GlobalKey<FormState>();

  final insuranceCompany = TextEditingController();
  final policyNumber = TextEditingController();
  final cardNumber = TextEditingController();
  final expiryDate = TextEditingController();
  final insuranceType = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insurance Details"),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInput("Insurance Company", insuranceCompany),
              buildInput("Policy Number", policyNumber),
              buildInput("Card Number", cardNumber),
              buildInput("Expiry Date", expiryDate),
              buildInput("Insurance Type", insuranceType),

              SizedBox(height: 20),
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

  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> saveInsuranceForm() async {
    await FirebaseFirestore.instance.collection("InsuranceForms").add({
      "insuranceCompany": insuranceCompany.text,
      "policyNumber": policyNumber.text,
      "cardNumber": cardNumber.text,
      "expiryDate": expiryDate.text,
      "insuranceType": insuranceType.text,
      "createdAt": Timestamp.now(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Insurance form submitted")));

    Navigator.pop(context);
  }
}
