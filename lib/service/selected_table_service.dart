import 'dart:convert';
import 'package:billiard_club_frontend/model/request/selected_table_request.dart';
import 'package:billiard_club_frontend/model/selected_table_list_response.dart';
import 'package:billiard_club_frontend/model/selected_table_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class SelectedTableService {
  static const String selectedTablesUrl = "$baseURL/api/v1/carambol/selected-tables"; 

  static Future<String?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<SelectedTableResponse> getById(int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('$selectedTablesUrl/$id'),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return SelectedTableResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load selected table: ${response.statusCode}');
    }
  }

  static Future<SelectedTableListResponse> getAll() async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse(selectedTablesUrl),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode == 200) {
      return SelectedTableListResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load selected tables: ${response.statusCode}');
    }
  }

  static Future<SelectedTableResponse> save(SelectedTableRequest request) async {
    final jwtToken = await getJwtToken();
    final response = await http.post(
      Uri.parse(selectedTablesUrl),
      headers: {
        "Content-Type": "application/json",
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 201) {
      return SelectedTableResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to save selected table: ${response.statusCode}');
    }
  }

  static Future<SelectedTableResponse> update(int id, SelectedTableRequest request) async {
    final jwtToken = await getJwtToken();
    final response = await http.put(
      Uri.parse('$selectedTablesUrl/$id'),
      headers: {
        "Content-Type": "application/json",
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
      body: json.encode(request.toMap()),
    );

    if (response.statusCode == 200) {
      return SelectedTableResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update selected table: ${response.statusCode}');
    }
  }

  static Future<void> delete(int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.delete(
      Uri.parse('$selectedTablesUrl/$id'),
      headers: {
        if (jwtToken != null) "Authorization": "Bearer $jwtToken",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete selected table: ${response.statusCode}');
    }
  }
}