import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AdminPatientAppointmentsPage.dart';

class AdminFindPatientPage extends StatefulWidget {
  const AdminFindPatientPage({super.key});

  @override
  State<AdminFindPatientPage> createState() => _AdminFindPatientPageState();
}

class _AdminFindPatientPageState extends State<AdminFindPatientPage> {
  final TextEditingController phoneController = TextEditingController();
  bool loading = false;
  DocumentSnapshot? foundPatient;

  Future<void> searchPatient() async {
    setState(() => loading = true);

    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('Phone Number', isEqualTo: phoneController.text.trim())
        .get();

    if (result.docs.isNotEmpty) {
      setState(() => foundPatient = result.docs.first);
    } else {
      setState(() => foundPatient = null);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Patient not found")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Patient"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: searchPatient,
              child: loading ? CircularProgressIndicator() : Text("Search"),
            ),
            SizedBox(height: 30),

            if (foundPatient != null)
              Card(
                child: ListTile(
                  title: Text(foundPatient!['Full Name']),
                  subtitle: Text(foundPatient!['Phone Number']),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPatientAppointmentsPage(
                          patientId: foundPatient!.id,
                          patientName: foundPatient!['Full Name'],
                          patientPhone: foundPatient!['Phone Number'],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
