import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Teleconsultationpage extends StatefulWidget {
  final String otherUserEmail; // البريد الإلكتروني للطرف الاخر
  final String otherUserName;
  const Teleconsultationpage({
    super.key,
    required this.otherUserEmail,
    required this.otherUserName,
  });

  @override
  State<Teleconsultationpage> createState() => _TeleconsultationpageState();
}

class _TeleconsultationpageState extends State<Teleconsultationpage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController messageController = TextEditingController();
  late String currentUserEmail;

  @override
  void initState() {
    super.initState();
    currentUserEmail = _auth.currentUser!.email!;
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      _firestore.collection('messages').add({
        'text': text,
        'senderEmail': currentUserEmail,
        'receiverEmail': widget.otherUserEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إستشارة طبية من د. ${widget.otherUserName}"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var msg in messages) {
                  final sender = msg.get('senderEmail');
                  final receiver = msg.get('receiverEmail');

                  // عرض فقط الرسائل بين المستخدم الحالي والطرف الآخر
                  if ((sender == currentUserEmail &&
                          receiver == widget.otherUserEmail) ||
                      (sender == widget.otherUserEmail &&
                          receiver == currentUserEmail)) {
                    final text = msg.get('text');
                    final isMe = sender == currentUserEmail;
                    messageWidgets.add(
                      Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.lightBlueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }

                return ListView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: messageWidgets,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "اكتب رسالتك...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
