import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalHistoryFormPage extends StatefulWidget {
  const MedicalHistoryFormPage({super.key});

  @override
  State<MedicalHistoryFormPage> createState() => _MedicalHistoryFormPageState();
}

class _MedicalHistoryFormPageState extends State<MedicalHistoryFormPage> {
  final _formKey = GlobalKey<FormState>();

  final conditions = TextEditingController();
  final medications = TextEditingController();
  final allergies = TextEditingController();
  final surgeries = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical History"),
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInput("Chronic Conditions", conditions),
              buildInput("Medications", medications),
              buildInput("Allergies", allergies),
              buildInput("Surgeries", surgeries),

              SizedBox(height: 20),

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

  Widget buildInput(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> saveMedicalHistory() async {
    await FirebaseFirestore.instance.collection("MedicalHistoryForms").add({
      "conditions": conditions.text,
      "medications": medications.text,
      "allergies": allergies.text,
      "surgeries": surgeries.text,
      "createdAt": Timestamp.now(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Medical history submitted")));

    Navigator.pop(context);
  }
}
