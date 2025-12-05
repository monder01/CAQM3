import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prototype1/FormManagementComponent/forms.dart';
import 'package:prototype1/NotificationSystemComponent/notifications.dart';

class MedicalHistoryPage extends StatefulWidget {
  const MedicalHistoryPage({
    super.key,
  }); // صفحة إدخال التاريخ المرضي للمريض، من نوع StatefulWidget لأنها تحتوي على حقول قابلة للتغيير

  @override
  State<MedicalHistoryPage> createState() => _MedicalHistoryPageState(); // إنشاء الحالة (State) الخاصة بالصفحة
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  Forms medicalHistoryForm =
      Forms(); // كائن عام للنماذج (غير مستخدم مباشرة هنا ولكن يمكن استخدامه لاحقاً لتوسعة الوظائف)
  Notifications notify =
      Notifications(); // كائن مسؤول عن عرض مربعات حوار التأكيد للمستخدم

  // الكنترولرز لحقول التاريخ المرضي
  TextEditingController chronicDiseasesController =
      TextEditingController(); // متحكم لحقل إدخال الأمراض المزمنة
  TextEditingController previousSurgeriesController =
      TextEditingController(); // متحكم لحقل إدخال العمليات الجراحية السابقة
  TextEditingController allergiesController =
      TextEditingController(); // متحكم لحقل إدخال الحساسية من الأدوية/الأطعمة
  TextEditingController currentMedicationsController =
      TextEditingController(); // متحكم لحقل إدخال الأدوية الحالية
  TextEditingController familyHistoryController =
      TextEditingController(); // متحكم لحقل إدخال التاريخ المرضي في العائلة
  TextEditingController socialHabitsController =
      TextEditingController(); // متحكم لحقل إدخال العادات (تدخين، كحول، نمط حياة..)
  TextEditingController otherNotesController =
      TextEditingController(); // متحكم لحقل إدخال الملاحظات الأخرى

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "النموذج الطبي / التاريخ المرضي",
        ), // عنوان شريط التطبيق في أعلى الصفحة
        backgroundColor: Colors.amberAccent[200], // لون خلفية الـ AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12), // مسافة داخلية حول محتوى الصفحة
        child: Column(
          children: [
            const SizedBox(height: 20), // مسافة علوية بسيطة قبل أول حقل

            TextField(
              controller:
                  chronicDiseasesController, // ربط حقل النص بمتحكم الأمراض المزمنة
              maxLines: 2, // السماح بسطرين في الحقل
              decoration: const InputDecoration(
                labelText: "الأمراض المزمنة (إن وجدت)", // عنوان الحقل
                border: OutlineInputBorder(), // إطار حول الحقل
              ),
            ),
            const SizedBox(height: 12), // مسافة بين الحقول

            TextField(
              controller: previousSurgeriesController, // متحكم العمليات السابقة
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "العمليات الجراحية السابقة",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: allergiesController, // متحكم الحساسية
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "الحساسية من الأدوية أو الأطعمة",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: currentMedicationsController, // متحكم الأدوية الحالية
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "الأدوية الحالية التي يتناولها المريض",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller:
                  familyHistoryController, // متحكم التاريخ المرضي العائلي
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "التاريخ المرضي في العائلة",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller:
                  socialHabitsController, // متحكم العادات الاجتماعية/الصحية
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "العادات (تدخين، كحول، نمط حياة...)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: otherNotesController, // متحكم الملاحظات الأخرى
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "ملاحظات أخرى",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20), // مسافة قبل زر الحفظ

            ElevatedButton(
              onPressed: () async {
                // عند الضغط على زر "حفظ التاريخ المرضي"
                final confirmed = await notify.showConfirmationDialog(
                  context,
                  'هل أنت متأكد من حفظ هذا التاريخ المرضي؟', // رسالة التأكيد قبل الحفظ
                );
                if (!confirmed)
                  return; // إذا لم يؤكد المستخدم، يتم إلغاء العملية

                // قراءة القيم من الحقول المختلفة بعد إزالة الفراغات الزائدة
                String chronicDiseases = chronicDiseasesController.text.trim();
                String previousSurgeries = previousSurgeriesController.text
                    .trim();
                String allergies = allergiesController.text.trim();
                String currentMedications = currentMedicationsController.text
                    .trim();
                String familyHistory = familyHistoryController.text.trim();
                String socialHabits = socialHabitsController.text.trim();
                String otherNotes = otherNotesController.text.trim();

                // معرف المستخدم الحالي (المريض) من FirebaseAuth
                String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

                try {
                  // حفظ بيانات التاريخ المرضي في مجموعة "MedicalHistory" في Firestore
                  await FirebaseFirestore.instance
                      .collection('MedicalHistory')
                      .add({
                        'ChronicDiseases': chronicDiseases, // الأمراض المزمنة
                        'PreviousSurgeries':
                            previousSurgeries, // العمليات السابقة
                        'Allergies': allergies, // الحساسية
                        'CurrentMedications':
                            currentMedications, // الأدوية الحالية
                        'FamilyHistory':
                            familyHistory, // التاريخ المرضي العائلي
                        'SocialHabits':
                            socialHabits, // العادات الصحية/الاجتماعية
                        'OtherNotes': otherNotes, // أي ملاحظات إضافية
                        'PatientId': currentUserId, // ربط السجل بالمريض الحالي
                        'CreatedAt':
                            FieldValue.serverTimestamp(), // تسجيل وقت إنشاء السجل في السيرفر
                      });

                  // إظهار رسالة نجاح عند الحفظ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم حفظ التاريخ المرضي بنجاح ✅"),
                    ),
                  );
                } catch (e) {
                  // في حال حدوث خطأ أثناء الحفظ، تتم طباعته وإظهار رسالة خطأ للمستخدم
                  print("خطأ في حفظ بيانات التاريخ المرضي: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e")),
                  );
                }
              },
              child: const Text("حفظ التاريخ المرضي"), // نص الزر
            ),
          ],
        ),
      ),
    );
  }
}
