import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Forms extends StatefulWidget {
  const Forms({super.key});

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  String? selectedFileName;
  String? uploadedFileUrl;
  bool isUploading = false;

  Future<void> pickAndUploadFile() async {
    // اختر ملف
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null) return; // المستخدم لغى

    PlatformFile file = result.files.first;

    setState(() {
      selectedFileName = file.name;
      isUploading = true;
    });

    // ارفع الملف إلى Firebase Storage
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("forms/${DateTime.now().millisecondsSinceEpoch}_${file.name}")
        .putData(file.bytes!);

    TaskSnapshot snapshot = await uploadTask;
    uploadedFileUrl = await snapshot.ref.getDownloadURL();

    // احفظ البيانات في Firestore
    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('Forms').add({
      'userId': user?.uid,
      'fileName': file.name,
      'fileUrl': uploadedFileUrl,
      'uploadedAt': DateTime.now(),
    });

    setState(() {
      isUploading = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("📄 Form uploaded successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Form"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Medical Form (PDF, Word, Image...)",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // اسم الملف المختار
            if (selectedFileName != null) Text("Selected: $selectedFileName"),

            SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: isUploading ? null : pickAndUploadFile,
                icon: Icon(Icons.upload),
                label: Text(
                  isUploading ? "Uploading..." : "Select & Upload File",
                ),
              ),
            ),

            if (isUploading)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
