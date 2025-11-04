class User {
  final String userId;
  final String firstName;
  final String secondName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;

  User({
    required this.userId,
    required this.firstName,
    required this.secondName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  String get fullName => '$firstName $secondName $lastName';
}
