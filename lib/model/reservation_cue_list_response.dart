import 'package:billiard_club_frontend/model/reservation_cue_response.dart';

class ReservationCueListResponse {
  final List<ReservationCueResponse> items;

  ReservationCueListResponse({required this.items});

  factory ReservationCueListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ReservationCueResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ReservationCueListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}