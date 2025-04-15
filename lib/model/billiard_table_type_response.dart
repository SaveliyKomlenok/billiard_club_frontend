class BilliardTableTypeResponse {
  final int id;
  final String name;

  BilliardTableTypeResponse({
    required this.id,
    required this.name,
  });

  factory BilliardTableTypeResponse.fromMap(Map<String, dynamic> json) {
    return BilliardTableTypeResponse(
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