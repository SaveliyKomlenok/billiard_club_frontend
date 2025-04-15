import 'dart:convert';
import 'package:billiard_club_frontend/model/billiard_table_type_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class BilliardTableTypeService {
  Future<List<BilliardTableTypeResponse>> getAllBilliardTableTypes() async {
    final url = Uri.parse('$baseURL/api/v1/carambol/billiard-table-types');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((json) => BilliardTableTypeResponse.fromMap(json))
            .toList();
      } else {
        throw Exception('Failed to load billiard table types: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}