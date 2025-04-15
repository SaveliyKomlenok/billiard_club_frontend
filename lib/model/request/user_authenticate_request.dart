class UserAuthenticateRequest {
  final String username;
  final String password;

  UserAuthenticateRequest({
    required this.username,
    required this.password,
  });

  factory UserAuthenticateRequest.fromMap(Map<String, dynamic> json) {
    return UserAuthenticateRequest(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}