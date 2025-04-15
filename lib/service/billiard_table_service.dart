import 'dart:convert';
import 'dart:typed_data';
import 'package:billiard_club_frontend/model/billiard_table_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class BilliardTableService {
  Future<Uint8List?> getBilliardTableImage(int id) async {
    final url = Uri.parse('$baseURL/api/v1/carambol/billiard-tables/$id/image');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return response.bodyBytes; // Return image as Uint8List
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  Future<List<BilliardTableResponse>> getAllBilliardTables() async {
    final url = Uri.parse('$baseURL/api/v1/carambol/billiard-tables');

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
            .map((json) => BilliardTableResponse.fromMap(json))
            .toList();
      } else {
        throw Exception('Failed to load billiard tables: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}