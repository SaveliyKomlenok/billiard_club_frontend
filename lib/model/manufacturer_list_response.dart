import 'package:billiard_club_frontend/model/manufacturer_response.dart';

class ManufacturerListResponse {
  final List<ManufacturerResponse> items;

  ManufacturerListResponse({required this.items});

  factory ManufacturerListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ManufacturerResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ManufacturerListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}