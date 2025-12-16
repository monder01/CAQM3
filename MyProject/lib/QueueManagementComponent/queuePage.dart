//queuePage.dart
import 'package:flutter/material.dart'; // استيراد مكتبة واجهة المستخدم من فلاتر
import '/QueueManagementComponent/checkInAdmin.dart'; // استيراد صفحة/ويدجت تسجيل وصول المرضى
import '/QueueManagementComponent/manageQueuePage.dart'; // استيراد صفحة إدارة الطابور للواصلين

class Queuepage extends StatefulWidget {
  const Queuepage({
    super.key,
  }); // ويدجت رئيسية لصفحة إدارة الطابور، من نوع Stateful لأنها قد تتغير مستقبلاً

  @override
  State<Queuepage> createState() => _QueuepageState(); // إنشاء الحالة المرتبطة بهذه الصفحة
}

class _QueuepageState extends State<Queuepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // مركز المحتوى في منتصف الشاشة
        child: Padding(
          padding: const EdgeInsets.all(8.0), // حواف داخلية حول المحتوى
          child: GridView.count(
            crossAxisCount: 2, // عدد الأعمدة في الشبكة (عمودان)
            crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
            mainAxisSpacing: 10, // المسافة العمودية بين العناصر
            children: [
              // الزر الأول: إدارة الطابور (تسجيل وصول المرضى)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // زوايا مستديرة للزر
                  ),
                ),
                onPressed: () {
                  // الانتقال إلى صفحة Checkinadmin عند الضغط
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Checkinadmin()),
                  );
                },
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // محاذاة المحتوى في وسط الزر
                  children: [
                    Icon(
                      Icons.manage_accounts_rounded, // أيقونة تعبّر عن الإدارة
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "إدارة الطابور", // نص يوضح وظيفة الزر
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
              // الزر الثاني: سجل الطوابير (حاليًا يفتح نفس صفحة Checkinadmin)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // زوايا مستديرة للزر
                  ),
                ),
                onPressed: () {
                  // الانتقال إلى صفحة Checkinadmin (يمكن لاحقاً تغييره لصفحة سجل الطوابير)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Checkinadmin()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_edu, // أيقونة تعبّر عن السجل أو التاريخ
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "سجل الطوابير", // نص يوضح وظيفة الزر
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ),
              // الزر الثالث: إدارة الطابور للواصلين (التقدم/الرجوع في أرقام الدور)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // زوايا مستديرة للزر
                  ),
                ),
                onPressed: () {
                  // الانتقال إلى صفحة Managequeuepage عند الضغط
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Managequeuepage()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons
                          .confirmation_num, // أيقونة تعبّر عن رقم أو تذكرة (طابور)
                      size: 100,
                      color: Colors.amberAccent[200],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "إدارة الطابور للواصلين", // نص يوضح وظيفة الزر
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
