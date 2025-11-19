import 'package:cloud_firestore/cloud_firestore.dart';

class QueueService {
  static final _db = FirebaseFirestore.instance;

  static Future<DocumentReference> getOrCreateQueue({
    required String day,
    required String time,
    required String doctorId,
  }) async {
    final query = await _db
        .collection("Queues")
        .where("day", isEqualTo: day)
        .where("time", isEqualTo: time)
        .where("doctorId", isEqualTo: doctorId)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.reference;
    }

    return await _db.collection("Queues").add({
      "day": day,
      "time": time,
      "doctorId": doctorId,
      "currentNumber": 0,
      "createdAt": DateTime.now(),
    });
  }

  static Future<void> nextToken(DocumentReference queueRef) async {
    final snap = await queueRef.get();
    int current = snap["currentNumber"];
    await queueRef.update({"currentNumber": current + 1});
  }
}
