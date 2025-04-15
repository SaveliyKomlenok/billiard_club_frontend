import 'dart:convert';
import 'package:billiard_club_frontend/model/request/selected_cue_request.dart';
import 'package:billiard_club_frontend/model/selected_cue_list_response.dart';
import 'package:billiard_club_frontend/model/selected_cue_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class SelectedCueService {
  static const String selectedCuesUrl = "$baseURL/api/v1/carambol/selected-cues"; 

  static Future<String?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<SelectedCueResponse> getById(int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('$selectedCuesUrl/$id'),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return SelectedCueResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load selected cue: ${response.statusCode}');
    }
  }

  static Future<SelectedCueListResponse> getAll() async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse(selectedCuesUrl),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return SelectedCueListResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load selected cues: ${response.statusCode}');
    }
  }

  static Future<SelectedCueResponse> save(SelectedCueRequest request) async {
    final jwtToken = await getJwtToken();
    final response = await http.post(
      Uri.parse(selectedCuesUrl),
      headers: {
        "Content-Type": "application/json",
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 201) {
      return SelectedCueResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to save selected cue: ${response.statusCode}');
    }
  }

  static Future<SelectedCueResponse> update(int id, SelectedCueRequest request) async {
    final jwtToken = await getJwtToken();
    final response = await http.put(
      Uri.parse('$selectedCuesUrl/$id'),
      headers: {
        "Content-Type": "application/json",
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 200) {
      return SelectedCueResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update selected cue: ${response.statusCode}');
    }
  }

  static Future<void> delete(int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.delete(
      Uri.parse('$selectedCuesUrl/$id'),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete selected cue: ${response.statusCode}');
    }
  }
}