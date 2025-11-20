import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  final db = FirebaseFirestore.instance;

  // ⏭ وظيفة زيادة الدور وتحديث حالة الموعد
  Future<void> nextToken() async {
    final queueRef = db.collection('Queue').doc('main');

    await db.runTransaction((tx) async {
      final snap = await tx.get(queueRef);
      if (!snap.exists) return;

      int tokenDone = snap['tokenDone'] ?? 0;
      int tokenCounter = snap['tokenCounter'] ?? 0;

      if (tokenDone < tokenCounter) {
        int nextToken = tokenDone + 1;

        // تحديث الطابور
        tx.update(queueRef, {'tokenDone': nextToken});

        // تحديث حالة الموعد المقابل للتوكن إلى "done"
        final query = await db
            .collection('Appointments')
            .where('token', isEqualTo: nextToken)
            .get();

        for (var doc in query.docs) {
          tx.update(doc.reference, {'status': 'done'});
        }
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
          int tokenCounter = data['tokenCounter'] ?? 0;
          int tokenDone = data['tokenDone'] ?? 0;

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
                  tokenDone > 0 ? "$tokenDone" : "-",
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
