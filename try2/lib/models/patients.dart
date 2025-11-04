import '../user.dart';

class Patient extends User {
  // يمكنك إضافة خصائص خاصة بالمريض هنا مثل تاريخ الميلاد، ملاحظات، إلخ
  Patient({
    required String userId,
    required String firstName,
    required String secondName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) : super(
         userId: userId,
         firstName: firstName,
         secondName: secondName,
         lastName: lastName,
         email: email,
         phoneNumber: phoneNumber,
         role: 'patient',
       );
}
