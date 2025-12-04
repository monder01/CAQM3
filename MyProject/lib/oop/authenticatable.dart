
/*class Authenticatable extends UserC {


  Future<void> signin(
    String emailcontroller,
    String passwordcontroller,
    BuildContext context,
  ) async {
    email = emailcontroller;
    password = passwordcontroller;
    try {
      UserCredential userAuth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      print("verified : ${userAuth.user!.emailVerified}");
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth.user!.uid)
          .get();
      fullname = userInfo['FullName'];
      role = userInfo['Role'];
      if (role == "Admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Adminspage()),
        );
      } else if (role == "Patient") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Patientpage()),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("مرحبا بك في عيادتنا 😝 $fullname"),
          showCloseIcon: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == "user-not-found") {
        message = "المستخدم غير موجود";
      } else if (e.code == "wrong-password") {
        message = "كلمة المرور غير صحيحة";
      } else if (e.code == "invalid-email") {
        message = "البريد الإلكتروني غير صالح";
      } else {
        message = e.message ?? "حدث خطأ أثناء تسجيل الدخول";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ $message")));
      print("Error: $e");
    }
  }

  //-----------------------------------
  // تسجيل مستخدم جديد باستخدام البريد الإلكتروني وكلمة المرور
  Future<void> signup(
    String emailController,
    String passwordController,
    String fullnameController,
    String phoneNumberController,
    String roleController,
    BuildContext context,
  ) async {
    email = emailController;
    password = passwordController;
    fullname = fullnameController;
    phoneNumber = phoneNumberController;
    role = roleController;
    try {
      // إنشاء مستخدم await
      UserCredential userinfo = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userinfo.user!.uid)
          .set({
            'FullName': fullname,
            'Email': email,
            'PhoneNumber': phoneNumber,
            'Role': role,
            'UserID': userinfo.user!.uid,
          });

      // الانتقال لصفحة Homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Patientpage()),
      );

      // رسالة ترحيب
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("تم إنشاء الحساب بنجاح ✅ $email")));

      print("✅ patient created successfully: $email");
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == "email-already-in-use") {
        message = "هذا البريد مسجل بالفعل";
      } else if (e.code == "weak-password") {
        message = "كلمة المرور ضعيفة جدًا";
      } else if (e.code == "invalid-email") {
        message = "البريد الإلكتروني غير صالح";
      } else {
        message = e.message ?? "حدث خطأ أثناء إنشاء الحساب";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ $message")));

      print("❌ Error: $message");
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ غير متوقع")));
      print("❌ Error: $e");
    }
  }
}
*/
