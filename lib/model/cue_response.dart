import 'package:billiard_club_frontend/model/cue_type_response.dart';
import 'package:billiard_club_frontend/model/manufacturer_response.dart';

class CueResponse {
  final int id;
  final String name;
  final double price;
  final int amount;
  final String tipType;
  final int amountOfParts;
  final String material;
  final int diameter;
  final double weight; // Use double for BigDecimal
  final double length; // Use double for BigDecimal
  final String category;
  final String description;
  final CueTypeResponse cueType;
  final ManufacturerResponse manufacturer;

  CueResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.amount,
    required this.tipType,
    required this.amountOfParts,
    required this.material,
    required this.diameter,
    required this.weight,
    required this.length,
    required this.category,
    required this.description,
    required this.cueType,
    required this.manufacturer,
  });

  factory CueResponse.fromMap(Map<String, dynamic> json) {
    return CueResponse(
      id: json['id'],
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      amount: json['amount'] ?? 0,
      tipType: json['tipType'] ?? '',
      amountOfParts: json['amountOfParts'] ?? 0,
      material: json['material'] ?? '',
      diameter: json['diameter'] ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      length: (json['length'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      cueType: CueTypeResponse.fromMap(json['cueType']),
      manufacturer: ManufacturerResponse.fromMap(json['manufacturer']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'amount': amount,
      'tipType': tipType,
      'amountOfParts': amountOfParts,
      'material': material,
      'diameter': diameter,
      'weight': weight,
      'length': length,
      'category': category,
      'description': description,
      'cueType': cueType.toMap(),
      'manufacturer': manufacturer.toMap(),
    };
  }
}