import 'Users.dart';

class Doctor extends User {
  final String specialty; // تخصص الطبيب

  Doctor({
    required super.userId,
    required super.firstName,
    required super.secondName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required this.specialty,
  }) : super(role: 'doctor');

  // يمكنك إضافة دوال لإدارة المرضى أو المواعيد لاحقًا إذا أردت
}
