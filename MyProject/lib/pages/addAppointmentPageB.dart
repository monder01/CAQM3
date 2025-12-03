import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAppointmentPageB extends StatefulWidget {
  const AddAppointmentPageB({super.key});

  @override
  State<AddAppointmentPageB> createState() => _AddAppointmentPageBState();
}

class _AddAppointmentPageBState extends State<AddAppointmentPageB> {
  final FirebaseFirestore firestoreObj = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreObj.collection('Doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("لا يوجد طبيب حتى الآن"));
          }
          final doctors = snapshot.data!.docs;
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              var doctor = doctors[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  title: Text("د. ${doctor['FullName']}"),
                  subtitle: Text("التخصص: ${doctor['Specialization']}"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
