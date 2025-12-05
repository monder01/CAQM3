import 'package:prototype1/UserManagementComponent/users.dart';

class Patient extends UserC {
  String? patientId; // معرف المريض (يمكن ربطه بمعرف المستخدم في FirebaseAuth)
  String? address; // عنوان المريض (مكان السكن)
  String? dateOfBirth; // تاريخ ميلاد المريض
}
