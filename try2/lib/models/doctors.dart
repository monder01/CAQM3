import '../user.dart';

class Doctor extends User {
  final String specialty; // تخصص الطبيب

  Doctor({
    required String userId,
    required String firstName,
    required String secondName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required this.specialty,
  }) : super(
         userId: userId,
         firstName: firstName,
         secondName: secondName,
         lastName: lastName,
         email: email,
         phoneNumber: phoneNumber,
         role: 'doctor',
       );
}
