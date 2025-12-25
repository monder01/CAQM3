import 'package:MyCAQM/AppointmentManagementComponent/appointments.dart';

class AppointmentFactory extends Appointment {
  static double getCost(String type) {
    switch (type) {
      case 'إستشارة':
        return 30.0;
      case 'متابعة':
        return 40.0;
      case 'فحص دوري':
        return 50.0;
      case 'تحليل':
        return 100.0;
      case 'جراحة':
        return 150.0;
      case 'علاج طبيعي':
        return 200.0;

      default:
        return 0.0;
    }
  }
}

class Consultation extends Appointment {}

class FollowUp extends Appointment {}

class RoutineCheckup extends Appointment {}

class LabTest extends Appointment {}

class Surgery extends Appointment {}

class NaturalHealing extends Appointment {}
