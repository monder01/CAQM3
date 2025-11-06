import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';
import 'pages/add_appointment_page.dart';
import 'pages/manage_appointments_page.dart';

class AppRoutes {
  // أسماء المسارات
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String addAppointment = '/add_appointment';
  static const String manageAppointments = '/manage_appointments';

  // تعريف جميع الصفحات داخل خريطة
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    home: (context) => const HomePage(),
    addAppointment: (context) => const AddAppointmentPage(),
    manageAppointments: (context) => const ManageAppointmentsPage(),
  };
}
