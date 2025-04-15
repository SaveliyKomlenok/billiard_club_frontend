class AuthenticationResponse {
  final String token;
  final String role;
  final String username;

  AuthenticationResponse({
    required this.token,
    required this.role,
    required this.username,
  });

  factory AuthenticationResponse.fromMap(Map<String, dynamic> json) {
    return AuthenticationResponse(
      token: json['token'],
      role: json['role'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'role': role,
      'username': username,
    };
  }
}