import 'package:billiard_club_frontend/model/billiard_table_response.dart';

class SelectedTableResponse {
  final int id;
  final int amount;
  final BilliardTableResponse billiardTable;

  SelectedTableResponse({
    required this.id,
    required this.amount,
    required this.billiardTable,
  });

  factory SelectedTableResponse.fromMap(Map<String, dynamic> json) {
    return SelectedTableResponse(
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