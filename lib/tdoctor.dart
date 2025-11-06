import 'tuser.dart';

class Doctor extends Users {
  String? specialization;
  String? doctorId;

  Doctor({
    super.fullname,
    super.email,
    super.phoneNumber,
    String? role,
    super.userId,
    this.specialization,
    this.doctorId,
  }) : super(
         role: role ?? 'doctor',
       );

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({'specialization': specialization, 'doctorId': doctorId});
    return map;
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      fullname: map['fullname'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      userId: map['userId'],
      specialization: map['specialization'],
      doctorId: map['doctorId'],
    );
  }
}
