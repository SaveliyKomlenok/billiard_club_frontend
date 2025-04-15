import 'dart:convert';
import 'package:billiard_club_frontend/model/request/reservation_request.dart';
import 'package:billiard_club_frontend/model/reservation_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/constants.dart';

class ReservationService {
  Future<List<ReservationResponse>> findAllReservations() async {
    final url = Uri.parse('$baseURL/api/v1/carambol/reservations');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        var list = jsonResponse['items'] as List<dynamic>;
        return list.map((model) => ReservationResponse.fromMap(model)).toList();
      } else {
        throw Exception('Failed to load reservations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  Future<ReservationResponse> createReservation(ReservationRequest request) async {
    final url = Uri.parse('$baseURL/api/v1/carambol/reservations');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.post(url, headers: headers, body: json.encode(request.toMap()));

      if (response.statusCode == 201) {
        return ReservationResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to create reservation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  Future<ReservationResponse> cancelReservation(int id) async {
    final url = Uri.parse('$baseURL/api/v1/carambol/reservations/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();    
    String? token = prefs.getString('token');
    final headers = <String, String>{
      "Content-Type": "application/json; charset=utf-8",      
      if (token != null) "Authorization": "Bearer $token",
    };
    try {
      final response = await http.put(url, headers: headers);
      if (response.statusCode == 200) {        
        return ReservationResponse.fromMap(json.decode(utf8.decode(response.bodyBytes)));
      } else {        
        throw Exception('Failed to cancel reservation: ${response.statusCode}');
      }    
    } catch (e) {
      print('Error occurred: $e');     
      rethrow;
    }  
  }
}