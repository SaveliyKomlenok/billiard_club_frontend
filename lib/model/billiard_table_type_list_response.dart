import 'package:billiard_club_frontend/model/billiard_table_type_response.dart';

class BilliardTableTypeListResponse {
  final List<BilliardTableTypeResponse> items;

  BilliardTableTypeListResponse({required this.items});

  factory BilliardTableTypeListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => BilliardTableTypeResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return BilliardTableTypeListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}