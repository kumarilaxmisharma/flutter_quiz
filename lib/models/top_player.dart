// lib/models/top_player.dart

class TopPlayer {
  final int userId;
  final String totalScore;
  final String? firstName;
  final String? lastName;

  TopPlayer({
    required this.userId,
    required this.totalScore,
    this.firstName,
    this.lastName,
  });

  // Helper to get the full name, with a fallback
  String get fullName => (firstName != null && lastName != null)
      ? '$firstName $lastName'
      : (firstName ?? 'Player $userId');

  factory TopPlayer.fromJson(Map<String, dynamic> json) {
    return TopPlayer(
      userId: json['userId'],
      totalScore: json['totalScore'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}