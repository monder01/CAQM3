class Users {
  String? fullname;
  String? email;
  String? phoneNumber;
  String? role;
  String? userId;
  String? password;

  Users({
    this.fullname,
    this.email,
    this.phoneNumber,
    this.role,
    this.userId,
    this.password,
  });

  // لتحويل الكائن إلى Map لتخزينه في Firebase
  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'userId': userId,
      // لا تحفظ كلمة المرور في قاعدة البيانات لأمان المستخدم
    };
  }

  // لإنشاء كائن Users من بيانات Firestore
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      fullname: map['fullname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      userId: map['userId'],
    );
  }
}
