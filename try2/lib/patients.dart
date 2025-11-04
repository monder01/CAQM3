import 'dart:io';

import 'package:try2/users.dart';

class patient extends User
{
  String? _username;
  String? _password;
  void read()
  {
    print("Enter your Name : ");
    _username = stdin.readLineSync();
    print("Enter your Age : ");
    _password = stdin.readLineSync(); 
  }
  void display()
  {
    print("your Name : $_username");
    print("your Age : $_password");
  }
}
