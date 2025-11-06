import 'tuser.dart';

class Admin extends Users {
  String? adminId;

  Admin({
    super.fullname,
    super.email,
    super.phoneNumber,
    String? role,
    super.userId,
    this.adminId,
  }) : super(
         role: role ?? 'admin',
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
