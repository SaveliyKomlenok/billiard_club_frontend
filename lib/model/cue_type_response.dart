class CueTypeResponse {
  final int id;
  final String name;

  CueTypeResponse({
    required this.id,
    required this.name,
  });

  factory CueTypeResponse.fromMap(Map<String, dynamic> json) {
    return CueTypeResponse(
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