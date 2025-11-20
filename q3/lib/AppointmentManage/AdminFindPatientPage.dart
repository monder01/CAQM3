import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AdminPatientAppointmentsPage.dart';

class AdminFindPatientPage extends StatefulWidget {
  const AdminFindPatientPage({super.key});

  @override
  State<AdminFindPatientPage> createState() => _AdminFindPatientPageState();
}

class _AdminFindPatientPageState extends State<AdminFindPatientPage> {
  final TextEditingController phoneController = TextEditingController();
  // متحكم لحقل إدخال رقم الهاتف للبحث عن المريض
  bool loading = false;
  // حالة التحميل أثناء تنفيذ عملية البحث
  DocumentSnapshot? foundPatient;
  // لتخزين بيانات المريض إذا تم العثور عليه

  // دالة البحث عن المريض باستخدام رقم الهاتف
  Future<void> searchPatient() async {
    setState(() => loading = true);
    // تفعيل مؤشر التحميل

    var result = await FirebaseFirestore.instance
        .collection('users') // الوصول إلى مجموعة المستخدمين
        .where('Phone Number', isEqualTo: phoneController.text.trim())
        // البحث عن المستخدم الذي يطابق رقم الهاتف المدخل
        .get();

    if (result.docs.isNotEmpty) {
      setState(() => foundPatient = result.docs.first);
      // إذا تم العثور على المريض، تخزين بياناته
    } else {
      setState(() => foundPatient = null);
      // إذا لم يتم العثور على المريض، إعادة تعيين المتغير
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Patient not found")),
        // عرض رسالة تنبيهية بعدم العثور على المريض
      );
    }

    setState(() => loading = false);
    // إيقاف مؤشر التحميل بعد انتهاء العملية
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Patient"),
        // عنوان صفحة البحث عن المريض
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        // مسافة داخلية حول عناصر الصفحة
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              // ربط الحقل بمتحكم رقم الهاتف
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
              // تحديد نوع لوحة المفاتيح للأرقام
            ),
            SizedBox(height: 20), // مسافة فاصلة بين الحقل والزر

            ElevatedButton(
              onPressed: searchPatient,
              // تنفيذ دالة البحث عند الضغط على الزر
              child: loading ? CircularProgressIndicator() : Text("Search"),
              // عرض مؤشر تحميل أثناء البحث
            ),
            SizedBox(height: 30), // مسافة قبل عرض نتيجة البحث

            if (foundPatient != null)
              // التحقق من وجود مريض تم العثور عليه
              Card(
                child: ListTile(
                  title: Text(foundPatient!['Full Name']),
                  // عرض اسم المريض
                  subtitle: Text(foundPatient!['Phone Number']),
                  // عرض رقم الهاتف
                  trailing: Icon(Icons.arrow_forward),
                  // أيقونة تشير إلى إمكانية الانتقال
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPatientAppointmentsPage(
                          patientId: foundPatient!.id,
                          // تمرير معرّف المريض
                          patientName: foundPatient!['Full Name'],
                          // تمرير اسم المريض
                          patientPhone: foundPatient!['Phone Number'],
                          // تمرير رقم الهاتف
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
