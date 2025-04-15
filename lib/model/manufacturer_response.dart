class ManufacturerResponse {
  final int id;
  final String name;

  ManufacturerResponse({
    required this.id,
    required this.name,
  });

  factory ManufacturerResponse.fromMap(Map<String, dynamic> json) {
    return ManufacturerResponse(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}