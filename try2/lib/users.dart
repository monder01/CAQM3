import 'dart:io';
class User
{
  String? _name,_role,_password,_email;
  int? _phonenum;
  void setrole(String rl)
  {
    _role = rl;
  }
  void setinfo(String na,String rl,String pd,String el,int pn)
  {
    _name = na;
    _role = rl;
    _password = pd;
    _email = el;
    _phonenum = pn;
  }
  
  void displayu()
  {
    print("Name : $_name");
    print("Email : $_email");
    print("Name : $_phonenum");
    print("Name : $_role");
  }
}
