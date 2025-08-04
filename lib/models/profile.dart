// lib/models/profile.dart

class Profile {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String phone;
  final String? status;
  final String? totalScore; 

  Profile({
    required this.id,
    this.firstName,
    this.lastName,
    this.username,
    required this.phone,
    this.status,
    this.totalScore,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      phone: json['phone'],
      status: json['status'],
      totalScore: json['totalScore'],
    );
  }

  String get fullName => (firstName != null && lastName != null) ? '$firstName $lastName' : (username ?? 'Unnamed User');
}