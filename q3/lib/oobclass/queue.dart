// queue.dart
class Token {
  String? tokenId;
  String? appointmentId;
  int? number; // رقم الطابور
  String? status; // pending, served, skipped
}

class Queue {
  String? queueId;
  String? doctorId;
  List<Token> tokens = [];

  // توليد رقم جديد للطابور
  int getNextNumber() {
    if (tokens.isEmpty) return 1;
    return tokens.last.number! + 1;
  }
}
