import 'package:billiard_club_frontend/model/user_response.dart';

class ReservationResponse {
  final int id;
  final DateTime createdAt;
  final String address;
  final String startReservationDate;
  final String endReservationDate;
  final int durationHours;
  final UserResponse user;

  ReservationResponse({
    required this.id,
    required this.createdAt,
    required this.address,
    required this.startReservationDate,
    required this.endReservationDate,
    required this.durationHours,
    required this.user,
  });

  factory ReservationResponse.fromMap(Map<String, dynamic> json) {
    return ReservationResponse(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      address: json['address'] ?? '',
      startReservationDate: json['startReservationDate'] ?? '',
      endReservationDate: json['endReservationDate'] ?? '',
      durationHours: json['durationHours'] ?? 0,
      user: UserResponse.fromMap(json['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'address': address,
      'startReservationDate': startReservationDate,
      'endReservationDate': endReservationDate,
      'durationHours': durationHours,
      'user': user.toMap(),
    };
  }
}