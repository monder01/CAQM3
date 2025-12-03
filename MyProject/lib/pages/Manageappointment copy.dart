import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Manageappointment extends StatefulWidget {
  const Manageappointment({super.key});

  @override
  State<Manageappointment> createState() => _ManageappointmentState();
}

class _ManageappointmentState extends State<Manageappointment> {
  final FirebaseFirestore FirestoreObj = FirebaseFirestore.instance;
  String? selectedDoctorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirestoreObj.collection('Doctors').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("لا يوجد أطباء حتى الآن"));
            }

            final doctors = snapshot.data!.docs;

            return Column(
              children: [
                SizedBox(height: 10),

                // Dropdown Button
                DropdownButton<String>(
                  hint: Text("إختر الطبيب"),
                  value: selectedDoctorId,
                  items: doctors.map((document) {
                    return DropdownMenuItem<String>(
                      value: document['DoctorID'],
                      child: Text("د. ${document['FullName']}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDoctorId = value;
                      print("Selected Doctor ID: $selectedDoctorId");
                    });
                  },
                ),

                SizedBox(height: 10),

                // Expanded List View
                Expanded(
                  child: ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      var doctor = doctors[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: ListTile(
                          title: Text("د. ${doctor['FullName']}"),
                          subtitle: Text("التخصص: ${doctor['Specialization']}"),
                          trailing: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 30,
                          ),
                          onTap: () {
                            setState(() {
                              selectedDoctorId = doctor['DoctorID'];
                              print('Selected Doctor ID: $selectedDoctorId');
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
