import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPdfPage extends StatefulWidget {
  const UploadPdfPage({super.key});

  @override
  State<UploadPdfPage> createState() => _UploadPdfPageState();
}

class _UploadPdfPageState extends State<UploadPdfPage> {
  bool isUploading = false;
  String? uploadedUrl;

  Future<void> pickAndUploadPdf() async {
    // Pick a PDF file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // IMPORTANT so we don't use File()
    );

    if (result == null) return; // User canceled file picker

    final bytes = result.files.single.bytes;
    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: file bytes are empty")),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      // Generate unique file name
      final fileName = "pdf_${DateTime.now().millisecondsSinceEpoch}.pdf";

      // Create reference in Firebase Storage
      final ref = FirebaseStorage.instance.ref().child("pdfs/$fileName");

      // Upload using bytes (SAFE FOR ANDROID 11+)
      UploadTask uploadTask = ref.putData(
        bytes,
        SettableMetadata(contentType: "application/pdf"),
      );

      // Wait until upload finishes
      final snapshot = await uploadTask;

      // Get download URL
      final url = await snapshot.ref.getDownloadURL();

      setState(() => uploadedUrl = url);

      // Firestore will CREATE the collection automatically if it doesn't exist
      await FirebaseFirestore.instance.collection("pdf_files").add({
        "url": url,
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF Uploaded Successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload error: $e")));
    }

    setState(() => isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload PDF")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isUploading ? null : pickAndUploadPdf,
              child: const Text("Pick & Upload PDF"),
            ),

            if (isUploading) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],

            if (uploadedUrl != null) ...[
              const SizedBox(height: 20),
              const Text("Uploaded PDF URL:"),
              SelectableText(uploadedUrl!),
            ],
          ],
        ),
      ),
    );
  }
}
