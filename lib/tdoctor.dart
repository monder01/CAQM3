import 'tuser.dart';

class Doctor extends Users {
  String? specialization;
  String? doctorId;

  Doctor({
    String? fullname,
    String? email,
    String? phoneNumber,
    String? role,
    String? userId,
    this.specialization,
    this.doctorId,
  }) : super(
         fullname: fullname,
         email: email,
         phoneNumber: phoneNumber,
         role: role ?? 'doctor',
         userId: userId,
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
