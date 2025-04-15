import 'package:billiard_club_frontend/model/cue_response.dart';
import 'package:billiard_club_frontend/model/reservation_response.dart';

class ReservationCueResponse {
  final int id;
  final int amount;
  final CueResponse cue;
  final ReservationResponse reservation;

  ReservationCueResponse({
    required this.id,
    required this.amount,
    required this.cue,
    required this.reservation,
  });

  factory ReservationCueResponse.fromMap(Map<String, dynamic> json) {
    return ReservationCueResponse(
      id: json['id'],
      amount: json['amount'] ?? 0,
      cue: CueResponse.fromMap(json['cue']),
      reservation: ReservationResponse.fromMap(json['reservation']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'cue': cue.toMap(),
      'reservation': reservation.toMap(),
    };
  }
}