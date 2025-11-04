import 'Users.dart';

class Admin extends User {
  Admin({
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
         role: 'admin',
       );
}
