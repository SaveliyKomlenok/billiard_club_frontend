import 'package:billiard_club_frontend/model/selected_table_response.dart';

class SelectedTableListResponse {
  final List<SelectedTableResponse> items;

  SelectedTableListResponse({required this.items});

  factory SelectedTableListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => SelectedTableResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return SelectedTableListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}