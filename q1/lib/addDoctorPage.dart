import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addAvailabilityPage.dart';
import 'doctors.dart';
import 'users.dart';

class Adddoctorpage extends StatefulWidget {
  const Adddoctorpage({super.key});

  @override
  State<Adddoctorpage> createState() => _AdddoctorpageState();
}

class _AdddoctorpageState extends State<Adddoctorpage> {
  Users users = Users();
  Doctors doctor = Doctors();
  final TextEditingController fullNamecon = TextEditingController();
  final TextEditingController emailcon = TextEditingController();
  final TextEditingController passwordcon = TextEditingController();
  final TextEditingController phoneNumcon = TextEditingController();
  final TextEditingController specialtyCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add A Doctor"),
        backgroundColor: Colors.amberAccent[200],
      ),
      body: Column(
        children: [
          TextField(
            controller: fullNamecon,
            decoration: InputDecoration(
              labelText: "Full name",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: emailcon,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passwordcon,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: phoneNumcon,
            decoration: InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: specialtyCon,
            decoration: InputDecoration(
              labelText: "Specialty",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              users.fullname = fullNamecon.text;
              users.email = emailcon.text;
              users.password = passwordcon.text;
              users.phoneNumber = phoneNumcon.text;
              users.role = "Doctor";
              doctor.specialization = specialtyCon.text;
              try {
                UserCredential userinfo = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: users.email!,
                      password: users.password!,
                    );
                await FirebaseFirestore.instance
                    .collection('Doctors')
                    .doc(userinfo.user!.uid)
                    .set({
                      'Full Name': users.fullname,
                      'Email': users.email,
                      'Phone Number': users.phoneNumber,
                      'Role': users.role,
                      'specialty': doctor.specialization,
                    });
                print("✅ Account created successfully for ${users.fullname}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddAvailabilityPage(doctorId: userinfo.user!.uid),
                  ),
                );
              } catch (e) {
                print("❌ Error: $e");
              }
            },
            child: Text("Add Doctor"),
          ),
        ],
      ),
    );
  }
}
