class UserResponse {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final DateTime createdAt;

  UserResponse({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.createdAt,
  });

  factory UserResponse.fromMap(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      username: json['username'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}