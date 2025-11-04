import 'dart:io';
//import 'main.dart';

class User {
  String? _name, _role, _password, _email;
  int? _phonenum;
  //-------------------------------------------------------
  void setrole(String rl) {
    _role = rl;
  }

  void setinfo(String? na, String? rl, String? pd, String? el, int? pn) {
    _name = na;
    _role = rl;
    _password = pd;
    _email = el;
    _phonenum = pn;
  }

  //-----------------------------------------------------
  void displayu() {
    stdout.writeln("Name : $_name");
    stdout.writeln("Email : $_email");
    stdout.writeln("Name : $_phonenum");
    stdout.writeln("Name : $_role");
  }
}
