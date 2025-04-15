import 'package:billiard_club_frontend/model/cue_response.dart';

class SelectedCueResponse {
  final int id;
  final int amount;
  final CueResponse cue;

  SelectedCueResponse({
    required this.id,
    required this.amount,
    required this.cue,
  });

  factory SelectedCueResponse.fromMap(Map<String, dynamic> json) {
    return SelectedCueResponse(
      id: json['id'],
      amount: json['amount'] ?? 0,
      cue: CueResponse.fromMap(json['cue']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'cue': cue.toMap(),
    };
  }
}