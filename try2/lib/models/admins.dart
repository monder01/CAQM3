
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
  void addapointement() {}
  void updateapointement() {}
  void deleteapointement() {}
  void displayappointement() {}
}
