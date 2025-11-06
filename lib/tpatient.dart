import 'tuser.dart';

class Patient extends Users {
  String? patientId;
  String? medicalHistory;
  String? insuranceNumber;

  Patient({
    String? fullname,
    String? email,
    String? phoneNumber,
    String? role,
    String? userId,
    this.patientId,
    this.medicalHistory,
    this.insuranceNumber,
  }) : super(
         fullname: fullname,
         email: email,
         phoneNumber: phoneNumber,
         role: role ?? 'patient',
         userId: userId,
       );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'patientId': patientId,
      'medicalHistory': medicalHistory,
      'insuranceNumber': insuranceNumber,
    });
    return map;
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      fullname: map['fullname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      userId: map['userId'],
      patientId: map['patientId'],
      medicalHistory: map['medicalHistory'],
      insuranceNumber: map['insuranceNumber'],
    );
  }
}
