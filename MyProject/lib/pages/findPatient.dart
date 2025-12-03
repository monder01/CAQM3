import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prototype1/pages/addAppointmentPage.dart';
import 'package:prototype1/pages/showAppointment.dart';

class FindPatient extends StatefulWidget {
  const FindPatient({super.key});

  @override
  State<FindPatient> createState() => _FindPatientState();
}

class _FindPatientState extends State<FindPatient> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
            "ابحث عن مواعيد المرضى",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent[200],
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: "ابحث عن المريض برقم الهاتف",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                searchQuery = searchController.text.trim();
              });
            },
            child: Text("بحث"),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchQuery.isEmpty)
                  ? FirebaseFirestore.instance
                        .collection('users')
                        .where('Role', isEqualTo: "Patient")
                        .snapshots()
                  : FirebaseFirestore.instance
                        .collection('users')
                        .where('PhoneNumber', isEqualTo: searchQuery)
                        .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final documents = snapshot.data!.docs;

                if (documents.isEmpty) {
                  return Center(child: Text("لا توجد نتائج"));
                }

                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];

                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.amber),
                        title: Text("الاسم: ${doc['FullName']}"),
                        subtitle: Text("رقم الهاتف: ${doc['PhoneNumber']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.blue),
                              onPressed: () {
                                String? patientId = doc.id;
                                print('patientId : $patientId');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddAppointmentPage(
                                      patientIdd: patientId,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                String? patientId = doc.id;
                                print('patientId : $patientId');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Showappointment(patientIdd: patientId),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
