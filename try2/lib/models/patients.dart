import 'Users.dart';

class Patient extends User {
  // يمكنك إضافة خصائص خاصة بالمريض هنا مثل تاريخ الميلاد، ملاحظات، إلخ
  Patient({
    required super.userId,
    required super.firstName,
    required super.secondName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
  }) : super(
         role: 'patient',
       );
}
