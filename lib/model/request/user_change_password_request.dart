class UserChangePasswordRequest {
  final String password;

  UserChangePasswordRequest({required this.password});

  factory UserChangePasswordRequest.fromMap(Map<String, dynamic> json) {
    return UserChangePasswordRequest(
      password: json['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'password': password,
    };
  }
}