import 'package:billiard_club_frontend/model/reservation_table_response.dart';

class ReservationTableListResponse {
  final List<ReservationTableResponse> items;

  ReservationTableListResponse({required this.items});

  factory ReservationTableListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ReservationTableResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ReservationTableListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}