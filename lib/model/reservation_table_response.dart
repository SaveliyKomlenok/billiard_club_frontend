import 'package:billiard_club_frontend/model/billiard_table_response.dart';

class ReservationTableResponse {
  final int id;
  final int amount;
  final BilliardTableResponse billiardTable;

  ReservationTableResponse({
    required this.id,
    required this.amount,
    required this.billiardTable,
  });

  factory ReservationTableResponse.fromMap(Map<String, dynamic> json) {
    return ReservationTableResponse(
      id: json['id'],
      amount: json['amount'] ?? 0,
      billiardTable: BilliardTableResponse.fromMap(json['billiardTable']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'billiardTable': billiardTable.toMap(),
    };
  }
}