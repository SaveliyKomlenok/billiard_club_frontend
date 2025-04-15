class ReservationRequest {
  final String address;
  final DateTime reservationDate; // Use DateTime for LocalDateTime
  final DateTime reservationTime;  // Use DateTime for LocalDateTime
  final int durationHours;

  ReservationRequest({
    required this.address,
    required this.reservationDate,
    required this.reservationTime,
    required this.durationHours,
  });

  factory ReservationRequest.fromMap(Map<String, dynamic> json) {
    return ReservationRequest(
      address: json['address'] ?? '',
      reservationDate: DateTime.parse(json['reservationDate']),
      reservationTime: DateTime.parse(json['reservationTime']),
      durationHours: json['durationHours'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'reservationDate': reservationDate.toIso8601String(),
      'reservationTime': reservationTime.toIso8601String(),
      'durationHours': durationHours,
    };
  }
}