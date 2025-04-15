class UserEditRequest {
  final String firstname;
  final String lastname;
  final String username;

  UserEditRequest({
    required this.firstname,
    required this.lastname,
    required this.username,
  });

  factory UserEditRequest.fromMap(Map<String, dynamic> json) {
    return UserEditRequest(
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
    };
  }
}