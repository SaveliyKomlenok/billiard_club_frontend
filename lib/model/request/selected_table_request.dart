class SelectedTableRequest {
  final int amount;
  final int billiardTable; // Use int for Long

  SelectedTableRequest({
    required this.amount,
    required this.billiardTable,
  });

  factory SelectedTableRequest.fromMap(Map<String, dynamic> json) {
    return SelectedTableRequest(
      amount: json['amount'] ?? 0,
      billiardTable: json['billiardTable'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'billiardTable': billiardTable,
    };
  }
}