import 'tuser.dart';

class Patient extends Users {
  String? patientId;
  String? medicalHistory;
  String? insuranceNumber;

  Patient({
    super.fullname,
    super.email,
    super.phoneNumber,
    String? role,
    super.userId,
    this.patientId,
    this.medicalHistory,
    this.insuranceNumber,
  }) : super(
         role: role ?? 'patient',
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
