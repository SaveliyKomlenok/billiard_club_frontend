import 'package:billiard_club_frontend/model/billiard_table_type_response.dart';
import 'package:billiard_club_frontend/model/manufacturer_response.dart';

class BilliardTableResponse {
  final int id;
  final String name;
  final int amount;
  final String size;
  final String sizeOfPockets;
  final String frameMaterial;
  final String clothMaterial;
  final String clothColor;
  final String numberOfPockets;
  final String description;
  final ManufacturerResponse manufacturer; 
  final double price;
  final BilliardTableTypeResponse billiardTableType;

  BilliardTableResponse({
    required this.id,
    required this.name,
    required this.amount,
    required this.size,
    required this.sizeOfPockets,
    required this.frameMaterial,
    required this.clothMaterial,
    required this.clothColor,
    required this.numberOfPockets,
    required this.description,
    required this.manufacturer,
    required this.price,
    required this.billiardTableType,
  });

  factory BilliardTableResponse.fromMap(Map<String, dynamic> json) {
    return BilliardTableResponse(
      id: json['id'],
      name: json['name'] ?? '',
      amount: json['amount'] ?? 0,
      size: json['size'] ?? '',
      sizeOfPockets: json['sizeOfPockets'] ?? '',
      frameMaterial: json['frameMaterial'] ?? '',
      clothMaterial: json['clothMaterial'] ?? '',
      clothColor: json['clothColor'] ?? '',
      price: json['price'] ?? '',
      numberOfPockets: json['numberOfPockets'],
      description: json['description'] ?? '',
      manufacturer: ManufacturerResponse.fromMap(json['manufacturer']),
      billiardTableType: BilliardTableTypeResponse.fromMap(json['billiardTableType']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'size': size,
      'sizeOfPockets': sizeOfPockets,
      'frameMaterial': frameMaterial,
      'clothMaterial': clothMaterial,
      'clothColor': clothColor,
      'numberOfPockets': numberOfPockets,
      'description': description,
      'price': price,
      'manufacturer': manufacturer.toMap(),
      'billiardTableType': billiardTableType.toMap(),
    };
  }
}