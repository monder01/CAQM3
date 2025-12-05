import 'package:flutter/material.dart'; // استيراد مكتبة الواجهات في فلاتر
import 'package:prototype1/AppointmentManagementComponent/addAppointmentPage.dart'; // استيراد صفحة إضافة موعد جديد
import 'package:prototype1/AppointmentManagementComponent/showAppointment.dart'; // استيراد صفحة عرض المواعيد

class Appointmentpage extends StatefulWidget {
  const Appointmentpage({
    super.key,
  }); // ويدجت تمثل صفحة إدارة المواعيد، من نوع StatefulWidget لأنها قد تتغير

  @override
  State<Appointmentpage> createState() => _AppointmentpageState(); // إنشاء الحالة المرتبطة بهذه الصفحة
}

class _AppointmentpageState extends State<Appointmentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // وضع المحتوى في منتصف الشاشة
        child: Padding(
          padding: const EdgeInsets.all(8.0), // حواف داخلية حول محتوى الصفحة
          child: GridView.count(
            crossAxisCount: 2, // عدد الأعمدة في الشبكة (عمودان)
            crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
            mainAxisSpacing: 10, // المسافة العمودية بين العناصر
            children: [
              // الزر الأول: الانتقال إلى صفحة إضافة موعد جديد
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // زوايا مستديرة للزر
                  ),
                ),
                onPressed: () {
                  // عند الضغط يتم الانتقال إلى صفحة AddAppointmentPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAppointmentPage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // محاذاة محتوى الزر في الوسط
                  children: [
                    Icon(
                      Icons.add_circle, // أيقونة إضافة
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "إضافة موعد جديد", // نص وصفي للزر
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
              // الزر الثاني: الانتقال إلى صفحة عرض المواعيد السابقة
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // زوايا مستديرة للزر
                  ),
                ),
                onPressed: () {
                  // عند الضغط يتم الانتقال إلى صفحة Showappointment
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Showappointment()),
                  );
                },
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // محاذاة المحتوى في وسط الزر
                  children: [
                    Icon(
                      Icons.history, // أيقونة تاريخ/سجل
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "عرض المواعيد السابقة", // نص وصفي للزر
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
