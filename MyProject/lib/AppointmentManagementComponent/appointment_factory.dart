import 'package:MyCAQM/AppointmentManagementComponent/appointments.dart';

class AppointmentFactory {
  // استرجاع تكلفة الموعد بناءً على نوع الموعد
  static Appointment create(String type) {
    switch (type) {
      case 'إستشارة':
        return Consultation();
      case 'متابعة':
        return FollowUp();
      case 'فحص دوري':
        return RoutineCheckup();
      case 'تحاليل':
        return LabTest();
      case 'جراحة':
        return Surgery();
      case 'علاج طبيعي':
        return NaturalHealing();
      default:
        return Appointment();
    }
  }

  static double getCost(String type) {
    return create(type).cost ?? 0.0;
  }
}

/// تصنيفات المواعيد
class Consultation extends Appointment {
  Consultation() : super(appointmentType: 'إستشارة', cost: 30.0);
}

class FollowUp extends Appointment {
  FollowUp() : super(appointmentType: 'متابعة', cost: 50.0);
}

class RoutineCheckup extends Appointment {
  RoutineCheckup() : super(appointmentType: 'فحص دوري', cost: 40.0);
}

class LabTest extends Appointment {
  LabTest() : super(appointmentType: 'تحاليل', cost: 80.0);
}

class Surgery extends Appointment {
  Surgery() : super(appointmentType: 'جراحة', cost: 200.0);
}

class NaturalHealing extends Appointment {
  NaturalHealing() : super(appointmentType: 'علاج طبيعي', cost: 150.0);
}
