import 'dart:io';
import 'admins.dart';
import 'patients.dart';
import 'doctors.dart';
//import 'users.dart';

int choice() {
  int? ch;
  stdout.writeln("TO INSERT A PATIENT  PRESS (1) : ");
  stdout.writeln("TO INSERT A DOCTOR   PRESS (2) : ");
  stdout.writeln("TO INSERT AN ADMIN   PRESS (3) : ");
  stdout.writeln("TO DISPLAY A PATIENT PRESS (4) : ");
  stdout.writeln("TO DISPLAY A DOCTOR  PRESS (5) : ");
  stdout.writeln("TO DISPLAY AN ADMIN  PRESS (6) : ");
  stdout.writeln("TO EXIT THE PROGRAM  PRESS (7) : ");
  ch = int.parse(stdin.readLineSync()!);
  return ch;
}

Map<String?, dynamic> signup() {
  stdout.writeln("Enter your full name : ");
  String? name = stdin.readLineSync();
  stdout.writeln("Enter your password : ");
  String? password = stdin.readLineSync();
  stdout.writeln("Enter your email : ");
  String? email = stdin.readLineSync();
  stdout.writeln("Enter your phone number : ");
  int? phonenum = int.parse(stdin.readLineSync()!);
  return {
    "name": name,
    "password": password,
    "email": email,
    "phonenum": phonenum,
  };
}

void main() {
  String? role;
  Patient p = Patient();
  Doctor d = Doctor();
  //User u = User();
  Admin a = Admin();
  int ch = 0;
  while (ch != 7) {
    ch = choice();
    switch (ch) {
      case 1:
        var info = signup();
        role = "Patiant";
        p.setinfo(
          info["name"],
          role,
          info["password"],
          info["email"],
          info["phonenum"],
        );
        break;
      case 2:
        var info = signup();
        role = "Doctor";
        d.setinfo(
          info["name"],
          role,
          info["password"],
          info["email"],
          info["phonenum"],
        );
        break;
      case 3:
        var info = signup();
        role = "Admin";
        a.setinfo(
          info["name"],
          role,
          info["password"],
          info["email"],
          info["phonenum"],
        );
        break;
      case 4:
        p.displayu();
        break;
      case 5:
        d.displayu();
        break;
      case 6:
        a.displayu();
        break;
      default:
        stdout.writeln("WRONG INPUT!!!");
        break;
    }
  }
}
