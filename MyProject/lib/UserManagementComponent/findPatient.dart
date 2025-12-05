import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prototype1/AppointmentManagementComponent/addAppointmentPage.dart';
import 'package:prototype1/AppointmentManagementComponent/showAppointment.dart';

class FindPatient extends StatefulWidget {
  const FindPatient({
    super.key,
  }); // ويدجت رئيسية للبحث عن المرضى، من نوع Stateful لأنها تعتمد على حالة متغيرة (نص البحث)

  @override
  State<FindPatient> createState() => _FindPatientState(); // إنشاء حالة مرتبطة بالويدجت
}

class _FindPatientState extends State<FindPatient> {
  final TextEditingController searchController =
      TextEditingController(); // متحكم لحقل إدخال رقم الهاتف للبحث
  String searchQuery = ""; // متغير لتخزين نص البحث الحالي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40), // مسافة علوية
          Text(
            "ابحث عن مواعيد المرضى", // عنوان أعلى الصفحة
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent[200],
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: searchController, // ربط حقل النص بالمتحكم
            decoration: InputDecoration(
              labelText:
                  "ابحث عن المريض برقم الهاتف", // نص إرشادي داخل حقل الإدخال
              prefixIcon: Icon(Icons.search), // أيقونة عدسة بحث داخل الحقل
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // عند الضغط على زر "بحث" يتم تحديث قيمة searchQuery وإعادة بناء الواجهة
              setState(() {
                searchQuery = searchController.text
                    .trim(); // قراءة قيمة البحث بدون فراغات في البداية والنهاية
              });
            },
            child: Text("بحث"), // نص الزر
          ),
          SizedBox(height: 20),
          Expanded(
            // عنصر يأخذ المساحة المتبقية لعرض النتائج
            child: StreamBuilder<QuerySnapshot>(
              // استخدام StreamBuilder للاستماع للتغييرات في Firestore بشكل لحظي
              stream: (searchQuery.isEmpty)
                  // في حالة عدم وجود نص بحث يتم إظهار جميع المستخدمين الذين دورهم "Patient"
                  ? FirebaseFirestore.instance
                        .collection('users')
                        .where('Role', isEqualTo: "Patient")
                        .snapshots()
                  // في حالة وجود نص بحث يتم تصفية النتائج حسب رقم الهاتف
                  : FirebaseFirestore.instance
                        .collection('users')
                        .where('PhoneNumber', isEqualTo: searchQuery)
                        .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // في حالة عدم وصول البيانات بعد، يتم عرض مؤشر تحميل
                  return Center(child: CircularProgressIndicator());
                }

                final documents = snapshot
                    .data!
                    .docs; // قائمة المستندات (المرضى) المتطابقة مع البحث

                if (documents.isEmpty) {
                  // لو لم يتم إيجاد أي نتائج
                  return Center(child: Text("لا توجد نتائج"));
                }

                // عرض النتائج في ListView
                return ListView.builder(
                  itemCount: documents.length, // عدد العناصر حسب عدد الوثائق
                  itemBuilder: (context, index) {
                    final doc =
                        documents[index]; // المستند الحالي (بيانات مريض واحد)

                    return Card(
                      // كرت لكل مريض
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.amber,
                        ), // أيقونة مريض على اليسار
                        title: Text(
                          "الاسم: ${doc['FullName']}",
                        ), // عرض اسم المريض
                        subtitle: Text(
                          "رقم الهاتف: ${doc['PhoneNumber']}",
                        ), // عرض رقم الهاتف
                        trailing: Row(
                          mainAxisSize: MainAxisSize
                              .min, // يجعل الـ Row يأخذ أقل مساحة ممكنة
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.blue,
                              ), // زر لعمل موعد جديد
                              onPressed: () {
                                String? patientId =
                                    doc.id; // أخذ معرف المريض (ID الوثيقة)
                                String patientEmail =
                                    doc['Email']; // قراءة البريد الإلكتروني للمريض (محفوظ للتوسع مستقبلاً)
                                print(
                                  'patientId : $patientId',
                                ); // طباعة المعرف في الـ console لأغراض التتبع
                                Navigator.push(
                                  // الانتقال لصفحة إضافة موعد جديد لهذا المريض
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddAppointmentPage(
                                      //
                                      patientIdd:
                                          patientId, // تمرير معرف المريض لصفحة الموعد
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ), // زر لعرض/تعديل مواعيد المريض
                              onPressed: () {
                                String? patientId = doc.id; // أخذ معرف المريض
                                print(
                                  'patientId : $patientId',
                                ); // طباعة المعرف في الـ console
                                Navigator.push(
                                  // الانتقال إلى صفحة عرض المواعيد الخاصة بالمريض
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Showappointment(
                                      patientIdd: patientId,
                                    ), // تمرير معرف المريض
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
