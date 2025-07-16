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
    try {
      // Handle the date parsing more robustly
      DateTime parseDate(String dateString) {
        try {
          // Try parsing as ISO format first
          return DateTime.parse(dateString);
        } catch (e) {
          try {
            // Try parsing with timezone offset format
            final parts = dateString.split(' ');
            if (parts.length >= 2) {
              final dateTimePart = '${parts[0]} ${parts[1]}';
              return DateTime.parse(dateTimePart);
            }
            // Fallback to current date
            return DateTime.now();
          } catch (e) {
            // Return current date if parsing fails
            return DateTime.now();
          }
        }
      }

      return KavachTransactionModel(
        orderId: json['orderId']?.toString() ?? '',
        txnId: json['txnId']?.toString() ?? '',
        orderAmount: (json['orderAmount'] as num?)?.toDouble() ?? 0.0,
        status: json['status']?.toString() ?? '',
        date: parseDate(json['date']?.toString() ?? ''),
      );
    } catch (e) {
      // Return a default model if parsing fails
      return KavachTransactionModel(
        orderId: json['orderId']?.toString() ?? '',
        txnId: json['txnId']?.toString() ?? '',
        orderAmount: (json['orderAmount'] as num?)?.toDouble() ?? 0.0,
        status: json['status']?.toString() ?? '',
        date: DateTime.now(),
      );
    }
  }
}