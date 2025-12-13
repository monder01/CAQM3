import 'package:flutter/material.dart';

class Medicalhistorypageb extends StatefulWidget {
  const Medicalhistorypageb({super.key});

  @override
  State<Medicalhistorypageb> createState() => _MedicalhistorypagebState();
}

class _MedicalhistorypagebState extends State<Medicalhistorypageb> {
  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("النموذج الطبي / التاريخ المرضي - النسخة ب"),
          backgroundColor: Colors.amberAccent[200],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "النموذج الطبي / التاريخ المرضي - النسخة ب",
                  style: TextStyle(fontSize: 12),
                ),
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
                            return AlertDialog(
                              title: Text("Select Options"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min, // important!
                                children: [
                                  CheckboxListTile(
                                    title: Text("Option 1"),
                                    value: option1,
                                    onChanged: (value) =>
                                        setState(() => option1 = value!),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Option 2"),
                                    value: option2,
                                    onChanged: (value) =>
                                        setState(() => option2 = value!),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Option 3"),
                                    value: option3,
                                    onChanged: (value) =>
                                        setState(() => option3 = value!),
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
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.amberAccent[200]),
                      SizedBox(width: 5),
                      Text("تحديد", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
