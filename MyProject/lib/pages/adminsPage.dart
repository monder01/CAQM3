import 'package:flutter/material.dart';
import 'package:prototype1/pages/addDoctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype1/pages/findPatient.dart';
import 'package:prototype1/pages/homePage.dart';
import 'package:prototype1/pages/queuePage.dart';

class Adminspage extends StatefulWidget {
  const Adminspage({super.key});

  @override
  State<Adminspage> createState() => _AdminspageState();
}

class _AdminspageState extends State<Adminspage> {
  int i = 0;

  // الصفحات البسيطة
  final List<Widget> _pages = [FindPatient(), Adddoctor(), Queuepage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admins Page"),
        backgroundColor: Colors.amberAccent[200],
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                  (route) => false,
                );
              },
              icon: Text("تسجيل خروج"),
            ),
          ),
        ],
      ), // عنوان شريط التطبيق
      body: _pages[i],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: i,
        onTap: (index) {
          setState(() {
            i = index; // تغيير الصفحة عند الضغط
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'إدارة مواعيد المرضى',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'إضافة طبيب',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_queue),
            label: 'إدارة الطابور',
          ),
        ],
      ),
    );
  }
}
