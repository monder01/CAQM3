// adminFormsPage.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminFormsPage extends StatelessWidget {
  const AdminFormsPage({super.key});

  Future<void> openFile(String url) async {
    final Uri fileUrl = Uri.parse(url);
    if (!await launchUrl(fileUrl, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not open file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Uploaded Forms"),
        backgroundColor: Colors.amberAccent[200],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Forms')
            .orderBy('uploadedAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var forms = snapshot.data!.docs;

          if (forms.isEmpty) {
            return Center(child: Text("No forms uploaded yet."));
          }

          return ListView.builder(
            itemCount: forms.length,
            itemBuilder: (context, index) {
              var form = forms[index];

              return Card(
                margin: EdgeInsets.all(12),
                child: ListTile(
                  title: Text(form['fileName']),
                  subtitle: Text("User ID: ${form['userId']}"),

                  trailing: IconButton(
                    icon: Icon(Icons.open_in_new, color: Colors.blue),
                    onPressed: () {
                      openFile(form['fileUrl']);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
