import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Formpage extends StatefulWidget {
  const Formpage({super.key});

  @override
  State<Formpage> createState() => _FormpageState();
}

class _FormpageState extends State<Formpage> {
  PlatformFile? selectedFile;
  String? downloadUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Form")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(selectedFile?.name ?? "No file selected"),
            SizedBox(height: 20),
            ElevatedButton(onPressed: pickFile, child: Text("Select File")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedFile == null ? null : uploadFile,
              child: Text("Upload to Firebase"),
            ),
            if (downloadUrl != null) ...[
              SizedBox(height: 20),
              Text("Uploaded!"),
              SelectableText(downloadUrl!),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  Future<void> uploadFile() async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
        "Forms/${DateTime.now().millisecondsSinceEpoch}-${selectedFile!.name}",
      );

      // رفع الملفات على الويب باستخدام bytes
      UploadTask task = ref.putData(selectedFile!.bytes!);

      TaskSnapshot snap = await task;
      downloadUrl = await snap.ref.getDownloadURL();

      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Uploaded Successfully")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload Failed")));
    }
  }
}
