import 'package:billiard_club_frontend/model/reservation_response.dart';

class ReservationListResponse {
  final List<ReservationResponse> items;

  ReservationListResponse({required this.items});

  factory ReservationListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ReservationResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ReservationListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}