class UserRegisterRequest {
  final String username;
  final String firstname;
  final String lastname;
  final String password;

  UserRegisterRequest({
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.password,
  });

  factory UserRegisterRequest.fromMap(Map<String, dynamic> json) {
    return UserRegisterRequest(
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'password': password,
    };
  }
}