import 'package:billiard_club_frontend/model/cue_response.dart';

class CueListResponse {
  final List<CueResponse> items;

  CueListResponse({required this.items});

  factory CueListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => CueResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return CueListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}