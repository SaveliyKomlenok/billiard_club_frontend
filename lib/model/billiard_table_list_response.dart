import 'package:billiard_club_frontend/model/billiard_table_response.dart';

class BilliardTableListResponse {
  final List<BilliardTableResponse> items;

  BilliardTableListResponse({required this.items});

  factory BilliardTableListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => BilliardTableResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return BilliardTableListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}