import 'package:billiard_club_frontend/model/user_response.dart';
import 'reservation_cue_response.dart';
import 'reservation_table_response.dart';

class ReservationResponse {
  final int id;
  final String address;
  final String startReservationDate;
  final String endReservationDate;
  final String status;
  final UserResponse user;
  final DateTime createdAt;
  final double totalPrice;
  final List<ReservationCueResponse> reservedCues;
  final List<ReservationTableResponse> reservedBilliardTables;

  ReservationResponse({
    required this.id,
    required this.address,
    required this.startReservationDate,
    required this.endReservationDate,
    required this.status,
    required this.user,
    required this.createdAt,
    required this.totalPrice,
    required this.reservedCues,
    required this.reservedBilliardTables,
  });

  factory ReservationResponse.fromMap(Map<String, dynamic> json) {
    var cuesList = (json['reservedCues'] as List<dynamic>?)
        ?.map((item) => ReservationCueResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    var tablesList = (json['reservedBilliardTables'] as List<dynamic>?)
        ?.map((item) => ReservationTableResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ReservationResponse(
      id: json['id'],
      address: json['address'] ?? '',
      startReservationDate: json['startReservationDate'] ?? '',
      endReservationDate: json['endReservationDate'] ?? '',
      status: json['status'] ?? '',
      user: UserResponse.fromMap(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      totalPrice: (json['totalPrice'] != null)
          ? (json['totalPrice'] as num).toDouble()
          : 0.0,
      reservedCues: cuesList,
      reservedBilliardTables: tablesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'startReservationDate': startReservationDate,
      'endReservationDate': endReservationDate,
      'status': status,
      'user': user.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'totalPrice': totalPrice,
      'reservedCues': reservedCues.map((cue) => cue.toMap()).toList(),
      'reservedBilliardTables': reservedBilliardTables.map((table) => table.toMap()).toList(),
    };
  }
}