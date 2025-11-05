import 'Users.dart';

class Admin extends User {
  Admin({
    required super.userId,
    required super.firstName,
    required super.secondName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
  }) : super(role: 'admin');

  // يمكنك إضافة دوال لإدارة المستخدمين أو المواعيد لاحقًا
}
