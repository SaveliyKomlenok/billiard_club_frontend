import 'dart:convert';
import 'package:billiard_club_frontend/model/reservation_cue_list_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class ReservationCueService {
  Future<ReservationCueListResponse> findAllById(int id) async {
    final url = Uri.parse('$baseURL/api/v1/carambol/reservation-cues/$id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return ReservationCueListResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to load reservation cues: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}