import 'package:billiard_club_frontend/model/selected_cue_response.dart';

class SelectedCueListResponse {
  final List<SelectedCueResponse> items;

  SelectedCueListResponse({required this.items});

  factory SelectedCueListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => SelectedCueResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return SelectedCueListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}