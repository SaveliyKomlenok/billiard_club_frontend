import 'package:billiard_club_frontend/model/cue_type_response.dart';

class CueTypeListResponse {
  final List<CueTypeResponse> items;

  CueTypeListResponse({required this.items});

  factory CueTypeListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => CueTypeResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return CueTypeListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}