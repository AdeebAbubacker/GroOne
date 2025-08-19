class PaymentStatusResponse {
  final bool success;
  final String message;
  final PaymentStatusData? findData;

  PaymentStatusResponse({
    required this.success,
    required this.message,
    this.findData,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      findData: json["findData"] == null ? null : PaymentStatusData.fromJson(json["findData"]),
    );
  }
}

class PaymentStatusData {
  final String id;
  final String paymentRequestId;
  final String customerId;
  final String? orderId;
  final String amount;
  final String status; // Success, Failed, Pending, etc.
  final String createdAt;
  final String updatedAt;

  PaymentStatusData({
    required this.id,
    required this.paymentRequestId,
    required this.customerId,
    this.orderId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentStatusData.fromJson(Map<String, dynamic> json) {
    return PaymentStatusData(
      id: json["id"] ?? "",
      paymentRequestId: json["payment_request_id"] ?? "",
      customerId: json["customer_id"] ?? "",
      orderId: json["order_id"],
      amount: json["amount"] ?? "0",
      status: json["status"] ?? "Unknown",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}
