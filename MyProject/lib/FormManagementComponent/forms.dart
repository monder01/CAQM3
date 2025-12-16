//forms.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forms {
  String? formId;
  List<String> illnessList = [
    'السكري',
    'ضغط الدم',
    'القلب',
    'الربو',
    'الصرع',
    'السرطان',
    'الكلى',
    'الكبد',
    'الرئة',
    'فقر الدم',
  ];
  List<String> medicineList = [
    'الإنسولين',
    'الميتفورمين',
    'الأسبرين',
    'باراسيتامول',
    'أدوية الصرع',
    'مضادات حيوية',
    'أملوديبين',
    'أتينولول',
    'الكورتيزون',
  ];
  List<String> allergiesList = [
    'حساسية الأدوية',
    'حساسية الأطعمة',
    'حساسية الحيوانات',
    'حساسية أخرى',
  ];
  List<String> addictionsList = [
    'التدخين',
    'الكحول',
    'الكافين',
    'المخدرات',
    'الأدوية المهدئة',
    'المسكنات القوية',
  ];
  List<String> geneticdiseasesList = [
    'السكري',
    'ضغط الدم',
    'القلب',
    'الربو',
    'الصرع',
    'السرطان',
    'الكلى',
    'الكبد',
    'الرئة',
    'فقر الدم',
  ];
  List<String> previousSurgeriesList = [
    'استئصال الزائدة الدودية',
    'استئصال المرارة',
    'عمليات الفتق',
    'العمليات القيصرية',
    'جراحات العظام',
    'جراحات القلب',
    'جراحات العيون',
    'جراحات الأنف والأذن والحنجرة',
    'استئصال اللوزتين',
    'عمليات المسالك البولية',
  ];
  List<String> selectedIllnesses = []; // لتخزين الأمراض المختارة
  List<String> selectedMedicines = []; // لتخزين الأدوية المختارة
  List<String> selectedAllergies = []; // لتخزين الحساسيات المختارة
  List<String> selectedAddictions = []; // لتخزين الادمان المختار
  List<String> selectedGeneticDiseases = []; // لتخزين المرض الورائي المختارة
  List<String> selectedPreviousSurgeries = []; // لتخزين الحساسيات المختارة

  void reset() {
    selectedIllnesses.clear();
    selectedMedicines.clear();
    selectedAllergies.clear();
    selectedAddictions.clear();
    selectedGeneticDiseases.clear();
    selectedPreviousSurgeries.clear();
  }

  // دالة الحفظ
  Future<void> saveToFirebase({
    required String mainComplaint,
    required String illnessFree,
    required String medicineFree,
    required String allergiesFree,
    required String addictionsFree,
    required String geneticDiseasesFree,
    required String previousSurgeriesFree,
    required String otherNotes,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user signed in!");
      return;
    }
    TimeOfDay timeNow = TimeOfDay.now();
    DateTime dateNow = DateTime.now();
    String formattedTime = timeNow.format(context);
    String formattedDate = dateNow.toIso8601String().substring(0, 10);
    String userID = user.uid;

    Map<String, dynamic> formData = {
      'userID': userID,
      'mainComplaint': mainComplaint,
      'illnesses': [...selectedIllnesses, illnessFree],
      'medicines': [...selectedMedicines, medicineFree],
      'allergies': [...selectedAllergies, allergiesFree],
      'addictions': [...selectedAddictions, addictionsFree],
      'geneticDiseases': [...selectedGeneticDiseases, geneticDiseasesFree],
      'previousSurgeries': [
        ...selectedPreviousSurgeries,
        previousSurgeriesFree,
      ],
      'otherNotes': otherNotes,
      'time': formattedTime,
      'date': formattedDate,
    };

    try {
      await FirebaseFirestore.instance
          .collection('Medical History Forms')
          .add(formData);
      print("Form data saved successfully for user $userID!");
    } catch (e) {
      print("Error saving form data: $e");
    }
  }
}
