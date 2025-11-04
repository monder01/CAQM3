import 'dart:io';
import 'admins.dart';
import 'patients.dart';
import 'doctors.dart';
import 'users.dart';

int choice()
{
  int? ch;
  print("TO INSERT A PATIENT PRESS (1) : ");
  print("TO INSERT A DOCTOR  PRESS (2) : ");
  print("TO INSERT AN ADMIN  PRESS (3) : ");
  ch = int.parse(stdin.readLineSync()!);
  return ch;
}
void signup(String? name, String? password, String? email, int? phonenum)
  {
    print("Enter your full name : ");
    name = stdin.readLineSync();
    print("Enter your password : ");
    password = stdin.readLineSync();
    print("Enter your email : ");
    email = stdin.readLineSync();
    print("Enter your phone number : ");
    phonenum = int.parse(stdin.readLineSync()!);
  }
void main()
{
  String? name, password, email, role; int? phonenum; 
  patient p = patient();
  Doctor d = Doctor();
  User u = User();
  admin a = admin();
  int ch=0;
  while (ch!=3) {
    ch=choice();
    switch (ch) {
      case 1:
      role = "Patiant";
      p.read();
        break;
      case 2:
        p.display();
        break;
      case 3:
        print("Thank You For Your Time :)");
        break;
      default:
      print("WRONG INPUT!!!");
        break;
    }
  }
}