class SelectedCueRequest {
  final int amount;
  final int cue; // Use int for Long

  SelectedCueRequest({
    required this.amount,
    required this.cue,
  });

  factory SelectedCueRequest.fromMap(Map<String, dynamic> json) {
    return SelectedCueRequest(
      amount: json['amount'] ?? 0,
      cue: json['cue'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'cue': cue,
    };
  }
}