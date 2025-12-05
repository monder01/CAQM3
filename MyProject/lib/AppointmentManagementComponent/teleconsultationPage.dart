import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Teleconsultationpage extends StatefulWidget {
  final String
  otherUserEmail; // البريد الإلكتروني للطرف الآخر في المحادثة (طبيب أو مريض)
  final String otherUserName; // اسم الطرف الآخر لعرضه في واجهة الاستشارة

  const Teleconsultationpage({
    super.key,
    required this.otherUserEmail,
    required this.otherUserName,
  });

  @override
  State<Teleconsultationpage> createState() => _TeleconsultationpageState(); // إنشاء حالة الصفحة
}

class _TeleconsultationpageState extends State<Teleconsultationpage> {
  final _firestore =
      FirebaseFirestore.instance; // كائن للوصول إلى قاعدة بيانات Firestore
  final _auth =
      FirebaseAuth.instance; // كائن للوصول إلى المستخدم الحالي من Firebase Auth
  final TextEditingController messageController =
      TextEditingController(); // متحكم لحقل إدخال الرسالة النصية
  late String currentUserEmail; // متغير لحفظ بريد المستخدم الحالي

  @override
  void initState() {
    super.initState();
    currentUserEmail = _auth
        .currentUser!
        .email!; // عند فتح الصفحة يتم جلب بريد المستخدم الحالي وتخزينه
  }

  void sendMessage() {
    // دالة لإرسال رسالة جديدة
    final text = messageController.text
        .trim(); // قراءة النص من الحقل مع إزالة الفراغات الزائدة
    if (text.isNotEmpty) {
      // التأكد أن الرسالة ليست فارغة
      _firestore.collection('messages').add({
        'text': text, // نص الرسالة
        'senderEmail': currentUserEmail, // بريد المرسل (المستخدم الحالي)
        'receiverEmail': widget.otherUserEmail, // بريد المستلم (الطرف الآخر)
        'timestamp':
            FieldValue.serverTimestamp(), // وقت الإرسال من خادم Firebase
      });
      messageController.clear(); // مسح حقل الإدخال بعد الإرسال
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إستشارة طبية مع  ${widget.otherUserName}",
        ), // عنوان أعلى الصفحة مع اسم الطبيب
        backgroundColor: Colors.amberAccent[200], // لون خلفية شريط التطبيق
      ),
      body: Column(
        children: [
          Expanded(
            // الجزء العلوي لعرض الرسائل
            child: StreamBuilder<QuerySnapshot>(
              // الاستماع الفوري لتغييرات مجموعة messages من Firestore
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp') // ترتيب الرسائل حسب وقت الإرسال
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // في حال لم تصل البيانات بعد، يتم عرض دائرة تحميل
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs; // قائمة جميع الرسائل
                List<Widget> messageWidgets = []; // قائمة لعناصر واجهة الرسائل

                for (var msg in messages) {
                  final sender = msg.get('senderEmail'); // بريد المرسل
                  final receiver = msg.get('receiverEmail'); // بريد المستقبل

                  // عرض فقط الرسائل المتبادلة بين المستخدم الحالي والطرف الآخر
                  if ((sender == currentUserEmail &&
                          receiver == widget.otherUserEmail) ||
                      (sender == widget.otherUserEmail &&
                          receiver == currentUserEmail)) {
                    final text = msg.get('text'); // نص الرسالة
                    final isMe =
                        sender ==
                        currentUserEmail; // هل هذه الرسالة أرسلها المستخدم الحالي؟

                    messageWidgets.add(
                      Align(
                        // محاذاة الفقاعة حسب المرسل (يمين للمستخدم الحالي، يسار للطرف الآخر)
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ), // مسافة حول فقاعة الرسالة
                          padding: EdgeInsets.all(
                            12,
                          ), // حشوة داخل فقاعة الرسالة

                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors
                                      .lightBlueAccent // لون مختلف لرسائل المرسل
                                : Colors.grey[300], // لون لرسائل الطرف الآخر
                            borderRadius: isMe
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ), // زوايا دائرية للفقاعة
                          ),
                          child: Text(
                            text, // نص الرسالة داخل الفقاعة
                            style: TextStyle(
                              fontSize: 24,
                              color: isMe
                                  ? Colors
                                        .white // لون خط للمرسل
                                  : Colors.black87, // لون خط للطرف الآخر
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }

                // عرض قائمة الرسائل في ListView
                return ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ), // مسافة علوية وسفلية للقائمة
                  children: messageWidgets, // إضافة عناصر الرسائل
                );
              },
            ),
          ),
          // الجزء السفلي لكتابة وإرسال رسالة جديدة
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ), // مسافة حول شريط الإدخال
            color: Colors.grey[200], // خلفية خفيفة لشريط الإدخال
            child: Row(
              children: [
                Expanded(
                  // حقل كتابة الرسالة يأخذ أكبر مساحة متاحة
                  child: TextField(
                    controller: messageController, // ربط الحقل بالمتحكم
                    decoration: InputDecoration(
                      hintText: "اكتب رسالتك...", // نص إرشادي داخل الحقل
                      border: InputBorder.none, // بدون إطار ظاهر
                    ),
                  ),
                ),
                IconButton(
                  // زر الإرسال على شكل أيقونة
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed:
                      sendMessage, // استدعاء دالة إرسال الرسالة عند الضغط
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
