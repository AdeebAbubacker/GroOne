class KavachTransactionModel {
  final String orderId;
  final String txnId;
  final double orderAmount;
  final String status;
  final DateTime date;

  KavachTransactionModel({
    required this.orderId,
    required this.txnId,
    required this.orderAmount,
    required this.status,
    required this.date,
  });

  factory KavachTransactionModel.fromJson(Map<String, dynamic> json) {
    return KavachTransactionModel(
      orderId: json['orderId'],
      txnId: json['txnId'],
      orderAmount: (json['orderAmount'] as num).toDouble(),
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }
}