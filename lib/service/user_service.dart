import 'dart:convert';
import 'package:billiard_club_frontend/model/request/user_change_password_request.dart';
import 'package:billiard_club_frontend/model/request/user_edit_request.dart';
import 'package:billiard_club_frontend/model/user_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class UserService {
  Future<UserResponse> getProfile() async {
    final url = Uri.parse('$baseURL/api/v1/carambol/users/profile');
    final headers = await _getHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return UserResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to fetch user profile: ${response.statusCode}');
    }
  }

  Future<UserResponse> updateProfile(UserEditRequest request) async {
    final url = Uri.parse('$baseURL/api/v1/carambol/users/update');
    final headers = await _getHeaders();
    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update user profile: ${response.statusCode}');
    }
  }

  Future<UserResponse> changePassword(UserChangePasswordRequest request) async {
    final url = Uri.parse('$baseURL/api/v1/carambol/users/change-password');
    final headers = await _getHeaders();
    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to change password: ${response.statusCode}');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    return {
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}