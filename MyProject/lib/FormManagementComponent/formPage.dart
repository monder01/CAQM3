import 'package:flutter/material.dart'; // استيراد مكتبة بناء واجهات فلاتر
import '/FormManagementComponent/insurancePage.dart'; // استيراد صفحة نموذج التأمين
import '/FormManagementComponent/medicalHistoryPage.dart'; // استيراد صفحة التاريخ الطبي

class Formpage extends StatefulWidget {
  const Formpage({super.key}); // الصفحة الرئيسية للنماذج، من نوع StatefulWidget

  @override
  State<Formpage> createState() => _FormpageState(); // إنشاء الحالة المرتبطة بالصفحة
}

class _FormpageState extends State<Formpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // وضع المحتوى في الوسط
        child: Padding(
          padding: const EdgeInsets.all(8.0), // إضافة مسافة حول المحتوى
          child: GridView.count(
            crossAxisCount: 2, // عدد الأعمدة في الشبكة = 2
            crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
            mainAxisSpacing: 10, // المسافة العمودية بين العناصر
            children: [
              // زر الانتقال إلى صفحة نموذج التأمين
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // زوايا ناعمة للزر
                  ),
                ),
                onPressed: () {
                  // الانتقال لصفحة التأمين
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Insurancepage()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // محاذاة المحتوى عمودياً في الوسط
                  children: [
                    Icon(
                      Icons.credit_card, // أيقونة بطاقة تأمين
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "تعبئة بيانات التأمين", // وصف الزر
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),

              // زر الانتقال إلى صفحة التاريخ الطبي
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // زوايا ناعمة
                  ),
                ),
                onPressed: () {
                  // الانتقال لصفحة التاريخ الطبي
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicalHistoryPage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // محاذاة المحتوى في الوسط
                  children: [
                    Icon(
                      Icons.history_edu, // أيقونة كتاب للمعلومات الطبية
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "تعبئة بيانات التاريخ الطبي", // وصف الزر
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
