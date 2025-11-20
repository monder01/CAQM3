import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  final db = FirebaseFirestore.instance;

  // ⏭ وظيفة زيادة الدور
  Future<void> nextToken() async {
    final queueRef = db.collection('Queue').doc('main');

    await db.runTransaction((tx) async {
      final snap = await tx.get(queueRef);

      if (!snap.exists) return;

      int tokenDone = snap['tokenDone'];
      int tokenCounter = snap['tokenCounter'];

      if (tokenDone < tokenCounter) {
        tx.update(queueRef, {'tokenDone': tokenDone + 1});
      }
    });
  }

  // 🔁 وظيفة إعادة ضبط الطابور
  Future<void> resetQueue() async {
    final queueRef = db.collection('Queue').doc('main');

    await queueRef.set({
      'tokenCounter': 0,
      'tokenDone': 0,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queue Manager"),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: db.collection('Queue').doc('main').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!;
          int tokenCounter = data['tokenCounter'];
          int tokenDone = data['tokenDone'];

          int upcomingToken = tokenDone + 1;
          int remaining = tokenCounter - tokenDone;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Queue Status",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),

                // 🔵 Current Token
                Text("Now Serving", style: TextStyle(fontSize: 24)),
                Text(
                  "$tokenDone",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),

                // 🟡 Next Token
                Text("Next Token", style: TextStyle(fontSize: 24)),
                Text(
                  remaining > 0 ? "$upcomingToken" : "No More Tokens",
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 40),

                // 🔴 Remaining
                Text("Remaining: $remaining", style: TextStyle(fontSize: 22)),
                SizedBox(height: 50),

                // ⏭ Next Button
                ElevatedButton(
                  onPressed: remaining > 0 ? nextToken : null,
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

                // 🔁 Reset Button
                ElevatedButton(
                  onPressed: resetQueue,
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
