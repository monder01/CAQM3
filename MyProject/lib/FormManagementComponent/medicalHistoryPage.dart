import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototype1/FormManagementComponent/forms.dart';
import 'package:prototype1/NotificationSystemComponent/notifications.dart';

class MedicalHistoryPage extends StatefulWidget {
  const MedicalHistoryPage({super.key});

  @override
  State<MedicalHistoryPage> createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  Forms medicalHistoryForm = Forms();
  Notifications notify = Notifications();
  // الكنترولرز لحقول التاريخ المرضي
  TextEditingController chronicDiseasesController =
      TextEditingController(); // الأمراض المزمنة
  TextEditingController previousSurgeriesController =
      TextEditingController(); // العمليات السابقة
  TextEditingController allergiesController =
      TextEditingController(); // الحساسية من الأدوية/الأطعمة
  TextEditingController currentMedicationsController =
      TextEditingController(); // الأدوية الحالية
  TextEditingController familyHistoryController =
      TextEditingController(); // التاريخ العائلي
  TextEditingController socialHabitsController =
      TextEditingController(); // العادات (تدخين، كحول ..)
  TextEditingController otherNotesController =
      TextEditingController(); // ملاحظات أخرى

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("النموذج الطبي / التاريخ المرضي"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 20),

            TextField(
              controller: chronicDiseasesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "الأمراض المزمنة (إن وجدت)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: previousSurgeriesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "العمليات الجراحية السابقة",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: allergiesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "الحساسية من الأدوية أو الأطعمة",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: currentMedicationsController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "الأدوية الحالية التي يتناولها المريض",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: familyHistoryController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "التاريخ المرضي في العائلة",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: socialHabitsController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "العادات (تدخين، كحول، نمط حياة...)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: otherNotesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "ملاحظات أخرى",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final confirmed = await notify.showConfirmationDialog(
                  context,
                  'هل أنت متأكد من حفظ هذا التاريخ المرضي؟',
                );
                if (!confirmed) return;
                // قراءة القيم
                String chronicDiseases = chronicDiseasesController.text.trim();
                String previousSurgeries = previousSurgeriesController.text
                    .trim();
                String allergies = allergiesController.text.trim();
                String currentMedications = currentMedicationsController.text
                    .trim();
                String familyHistory = familyHistoryController.text.trim();
                String socialHabits = socialHabitsController.text.trim();
                String otherNotes = otherNotesController.text.trim();

                // معرف المستخدم الحالي
                String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

                try {
                  await FirebaseFirestore.instance
                      .collection('MedicalHistory')
                      .add({
                        'ChronicDiseases': chronicDiseases,
                        'PreviousSurgeries': previousSurgeries,
                        'Allergies': allergies,
                        'CurrentMedications': currentMedications,
                        'FamilyHistory': familyHistory,
                        'SocialHabits': socialHabits,
                        'OtherNotes': otherNotes,
                        'PatientId': currentUserId,
                        'CreatedAt': FieldValue.serverTimestamp(),
                      });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم حفظ التاريخ المرضي بنجاح ✅"),
                    ),
                  );
                } catch (e) {
                  print("خطأ في حفظ بيانات التاريخ المرضي: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e")),
                  );
                }
              },
              child: const Text("حفظ التاريخ المرضي"),
            ),
          ],
        ),
      ),
    );
  }
}
