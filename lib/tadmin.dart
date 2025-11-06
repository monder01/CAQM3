import 'tuser.dart';

class Admin extends Users {
  String? adminId;

  Admin({
    String? fullname,
    String? email,
    String? phoneNumber,
    String? role,
    String? userId,
    this.adminId,
  }) : super(
         fullname: fullname,
         email: email,
         phoneNumber: phoneNumber,
         role: role ?? 'admin',
         userId: userId,
       );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({'adminId': adminId});
    return map;
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      fullname: map['fullname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      userId: map['userId'],
      adminId: map['adminId'],
    );
  }
}
