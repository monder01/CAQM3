import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/FormManagementComponent/forms.dart';
import '/NotificationSystemComponent/notifications.dart';

class Medicalhistorypageb extends StatefulWidget {
  const Medicalhistorypageb({super.key});

  @override
  State<Medicalhistorypageb> createState() => _MedicalhistorypagebState();
}

class _MedicalhistorypagebState extends State<Medicalhistorypageb> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("النموذج الطبي / التاريخ المرضي - النسخة ب"),
          backgroundColor: Colors.amberAccent[200],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisSpacing: 1,
            mainAxisSpacing: 2,
            crossAxisCount: 2,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // زوايا ناعمة
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          bool option1 = false;
                          bool option2 = false;
                          bool option3 = false;

                          return AlertDialog(
                            title: Text("Select Options"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min, // important!
                              children: [
                                CheckboxListTile(
                                  title: Text("Option 1"),
                                  value: option1,
                                  onChanged: (v) =>
                                      setState(() => option1 = v!),
                                ),
                                CheckboxListTile(
                                  title: Text("Option 2"),
                                  value: option2,
                                  onChanged: (v) =>
                                      setState(() => option2 = v!),
                                ),
                                CheckboxListTile(
                                  title: Text("Option 3"),
                                  value: option3,
                                  onChanged: (v) =>
                                      setState(() => option3 = v!),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  print(option1);
                                  print(option2);
                                  print(option3);
                                  Navigator.pop(context);
                                },
                                child: Text("Done"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // محاذاة المحتوى في الوسط
                  children: [
                    Icon(
                      Icons.history_edu, // أيقونة كتاب للمعلومات الطبية
                      size: 100,
                      color: Colors.blueGrey[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "الامراض المزمنة", // وصف الزر
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
