import 'dart:io';
import 'admins.dart';
import 'patients.dart';
import 'doctors.dart';
import 'users.dart';

int choice() {
  int? ch;
  print("TO INSERT A PATIENT  PRESS (1) : ");
  print("TO INSERT A DOCTOR   PRESS (2) : ");
  print("TO INSERT AN ADMIN   PRESS (3) : ");
  print("TO DISPLAY A PATIENT PRESS (4) : ");
  print("TO DISPLAY A DOCTOR  PRESS (5) : ");
  print("TO DISPLAY AN ADMIN  PRESS (6) : ");
  print("TO EXIT THE PROGRAM  PRESS (7) : ");
  ch = int.parse(stdin.readLineSync()!);
  return ch;
}

Map<String?, dynamic> signup() {
  print("Enter your full name : ");
  String? name = stdin.readLineSync();
  print("Enter your password : ");
  String? password = stdin.readLineSync();
  print("Enter your email : ");
  String? email = stdin.readLineSync();
  print("Enter your phone number : ");
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
  patient p = patient();
  Doctor d = Doctor();
  User u = User();
  admin a = admin();
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
        print("WRONG INPUT!!!");
        break;
    }
  }
}
