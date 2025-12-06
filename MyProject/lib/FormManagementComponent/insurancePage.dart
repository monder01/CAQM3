import 'package:flutter/material.dart'; // استيراد مكتبة الواجهات في فلاتر
import 'package:firebase_auth/firebase_auth.dart'; // استيراد مكتبة إدارة المستخدمين من Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // استيراد مكتبة Firestore للتعامل مع قاعدة البيانات السحابية
import '/FormManagementComponent/forms.dart'; // استيراد الكلاس Forms (نموذج عام لإدارة النماذج)
import '/NotificationSystemComponent/notifications.dart'; // استيراد كلاس Notifications لعرض رسائل التأكيد

class Insurancepage extends StatefulWidget {
  const Insurancepage({
    super.key,
  }); // ويدجت صفحة نموذج التأمين، من نوع Stateful لأنها تحتوي على حقول إدخال تتغير

  @override
  State<Insurancepage> createState() => _InsurancepageState(); // ربط الويدجت بالحالة الخاصة بها
}

class _InsurancepageState extends State<Insurancepage> {
  Notifications notify = Notifications(); // كائن للتعامل مع رسائل التأكيد
  Forms insuranceForm =
      Forms(); // كائن من Forms يمكن استخدامه كواجهة عامة للنماذج (غير مستخدم مباشرة هنا)
  TextEditingController companyNameController =
      TextEditingController(); // متحكم لحقل اسم شركة التأمين
  TextEditingController policyNumberController =
      TextEditingController(); // متحكم لحقل رقم الوثيقة
  TextEditingController insuredTypeController =
      TextEditingController(); // متحكم لحقل نوع المؤمن عليه
  TextEditingController insuredStartDateController =
      TextEditingController(); // متحكم لحقل تاريخ بدء التأمين
  TextEditingController insuredEndDateController =
      TextEditingController(); // متحكم لحقل تاريخ انتهاء التأمين
  TextEditingController insuredPersonNameController =
      TextEditingController(); // متحكم لحقل اسم الشخص المؤمن عليه
  TextEditingController insuredPersonIDController =
      TextEditingController(); // متحكم لحقل رقم هوية الشخص المؤمن عليه
  TextEditingController insuredNotesController =
      TextEditingController(); // متحكم لحقل الملاحظات الإضافية

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("نموذج التأمين"), // عنوان الصفحة في شريط التطبيق العلوي
        backgroundColor: Colors.amberAccent[200], // لون خلفية الـ AppBar
      ),
      body: SingleChildScrollView(
        // يسمح بالتمرير في حال كانت الشاشة صغيرة أو الحقول كثيرة
        padding: const EdgeInsets.all(12), // مسافة خارجية حول المحتوى
        child: Column(
          children: [
            SizedBox(height: 20), // مسافة علوية بسيطة
            TextField(
              controller:
                  companyNameController, // ربط حقل الإدخال بمتحكم اسم الشركة
              decoration: InputDecoration(
                labelText: "اسم شركة التأمين", // نص إرشادي داخل الحقل
                border: OutlineInputBorder(), // إطار حول الحقل
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: policyNumberController, // متحكم رقم الوثيقة
              decoration: InputDecoration(
                labelText: "رقم الوثيقة",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: insuredTypeController, // متحكم نوع المؤمن عليه
              decoration: InputDecoration(
                labelText: "نوع المؤمن عليه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller:
                  insuredStartDateController, // متحكم تاريخ بداية التأمين
              decoration: InputDecoration(
                labelText: "تاريخ بدء التأمين",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller:
                  insuredEndDateController, // متحكم تاريخ انتهاء التأمين
              decoration: InputDecoration(
                labelText: "تاريخ انتهاء التأمين",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller:
                  insuredPersonNameController, // متحكم اسم الشخص المؤمن عليه
              decoration: InputDecoration(
                labelText: "اسم الشخص المؤمن عليه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller:
                  insuredPersonIDController, // متحكم رقم هوية الشخص المؤمن عليه
              decoration: InputDecoration(
                labelText: "رقم هوية الشخص المؤمن عليه",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: insuredNotesController, // متحكم الملاحظات الإضافية
              decoration: InputDecoration(
                labelText: "ملاحظات إضافية",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                // عند الضغط على زر حفظ بيانات التأمين
                // قراءة النصوص المدخلة من الحقول المختلفة بعد إزالة الفراغات الزائدة
                String companyName = companyNameController.text.trim();
                String policyNumber = policyNumberController.text.trim();
                String insuredType = insuredTypeController.text.trim();
                String insuredStartDate = insuredStartDateController.text
                    .trim();
                String insuredEndDate = insuredEndDateController.text.trim();
                String insuredPersonName = insuredPersonNameController.text
                    .trim();
                String insuredPersonID = insuredPersonIDController.text.trim();
                String insuredNotes = insuredNotesController.text.trim();

                // الحصول على معرف المستخدم الحالي (المريض) من FirebaseAuth
                String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

                // عرض مربع حوار للتأكيد قبل حفظ بيانات التأمين
                final confirmed = await notify.showConfirmationDialog(
                  context,
                  'هل أنت متأكد من حفظ بيانات التأمين؟', // رسالة التأكيد
                );
                if (!confirmed) return; //اذا لم يؤكد المستخدم، لا تفعل شيئًا

                try {
                  // حفظ البيانات في Firestore ضمن مجموعة "Insurance"
                  await FirebaseFirestore.instance.collection('Insurance').add({
                    'CompanyName': companyName, // اسم شركة التأمين
                    'PolicyNumber': policyNumber, // رقم وثيقة التأمين
                    'InsuredType': insuredType, // نوع المؤمن عليه
                    'InsuredStartDate': insuredStartDate, // تاريخ بدء التأمين
                    'InsuredEndDate': insuredEndDate, // تاريخ انتهاء التأمين
                    'InsuredPersonName':
                        insuredPersonName, // اسم الشخص المؤمن عليه
                    'InsuredPersonID':
                        insuredPersonID, // رقم هوية الشخص المؤمن عليه
                    'InsuredNotes': insuredNotes, // ملاحظات إضافية حول التأمين
                    'PatientId':
                        currentUserId, // ربط بيانات التأمين بالمريض (معرف المستخدم في النظام)
                  });
                } catch (e) {
                  // في حال حدوث خطأ أثناء عملية الحفظ في Firestore
                  print("خطأ في حفظ بيانات التأمين: $e");
                }
                // يمكن هنا إضافة أي منطق إضافي بعد الحفظ (مثل التنقل لصفحة أخرى)

                // إظهار رسالة نجاح للمستخدم بعد حفظ البيانات
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("تم حفظ بيانات التأمين بنجاح ✅")),
                );
              },
              child: Text("حفظ بيانات التأمين"), // نص الزر الظاهر للمستخدم
            ),
          ],
        ),
      ),
    );
  }
}
