import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  final db = FirebaseFirestore
      .instance; // مرجع إلى قاعدة بيانات فايرستور لإجراء العمليات عليها

  //  وظيفة  الدور وتحديث حالة الموعد
  Future<void> nextToken() async {
    final queueRef = db
        .collection('Queue')
        .doc('main'); // مرجع وثيقة الطابور الرئيسي

    await db.runTransaction((tx) async {
      // بدء معاملة لضمان التحديث الذري للبيانات
      final snap = await tx.get(queueRef); // جلب بيانات وثيقة الطابور
      if (!snap.exists) return; // التأكد من وجود الوثيقة قبل المتابعة

      int tokenDone = snap['tokenDone'] ?? 0; // عدد التوكينات التي تم خدمتها
      int tokenCounter = snap['tokenCounter'] ?? 0; // آخر رقم توكن تم إعطاؤه

      if (tokenDone < tokenCounter) {
        // التحقق من وجود توكنات بانتظار الخدمة
        int nextToken = tokenDone + 1; // حساب التوكن التالي

        tx.update(queueRef, {'tokenDone': nextToken});
        // تحديث قيمة التوكن المُنجز في الطابور

        final query = await db
            .collection('Appointments') // الوصول إلى مجموعة المواعيد
            .where(
              'token',
              isEqualTo: nextToken,
            ) // البحث عن الموعد المرتبط بالتوكن
            .get();

        for (var doc in query.docs) {
          tx.update(doc.reference, {'status': 'done'});
          // تحديث حالة الموعد إلى "منجز"
        }
      }
    });
  }

  // 🔁 وظيفة إعادة ضبط الطابور
  Future<void> resetQueue() async {
    final queueRef = db.collection('Queue').doc('main'); // مرجع وثيقة الطابور

    await queueRef.set({
      'tokenCounter': 0, // إعادة تعيين عدد التوكينات المُعطاة
      'tokenDone': 0, // إعادة تعيين عدد التوكينات المنجزة
    }, SetOptions(merge: true)); // دمج البيانات دون حذف معلومات أخرى
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queue Manager"), // عنوان صفحة إدارة الطابور
        backgroundColor: Colors.redAccent, // تخصيص لون شريط العنوان
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: db.collection('Queue').doc('main').snapshots(),
        // الاستماع للتحديثات الحية على وثيقة الطابور
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
            // عرض مؤشر انتظار أثناء تحميل البيانات
          }

          var data = snapshot.data!;
          int tokenCounter =
              data['tokenCounter'] ?? 0; // العدد الإجمالي للتوكينات
          int tokenDone =
              data['tokenDone'] ?? 0; // عدد التوكينات التي تمت خدمتها

          int upcomingToken = tokenDone + 1; // التوكن التالي المتوقع
          int remaining = tokenCounter - tokenDone; // عدد المتبقّي من التوكينات

          return Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // محاذاة المحتوى في وسط الصفحة
              children: [
                Text(
                  "Queue Status", // عنوان القسم
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),

                //  Current Token
                Text("Now Serving", style: TextStyle(fontSize: 24)),
                // عرض التوكن الحالي
                Text(
                  tokenDone > 0 ? "$tokenDone" : "-",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),

                //  Next Token
                Text("Next Token", style: TextStyle(fontSize: 24)),
                // عرض التوكن التالي
                Text(
                  remaining > 0 ? "$upcomingToken" : "No More Tokens",
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 40),

                //  Remaining
                Text("Remaining: $remaining", style: TextStyle(fontSize: 22)),
                // عدد التوكينات المتبقية
                SizedBox(height: 50),

                // ⏭ Next Button
                ElevatedButton(
                  onPressed: remaining > 0 ? nextToken : null,
                  // تفعيل الزر فقط إذا كانت هناك توكنات متبقية
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                //  Reset Button
                ElevatedButton(
                  onPressed: resetQueue, // استدعاء وظيفة إعادة ضبط الطابور
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(
                    "Reset Queue",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
