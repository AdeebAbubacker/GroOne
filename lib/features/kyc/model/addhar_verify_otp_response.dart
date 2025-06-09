class AadhaarVerifyOtpModel {
  AadhaarVerifyOtpModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data? data;

  factory AadhaarVerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return AadhaarVerifyOtpModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.requestId,
    required this.success,
    required this.responseCode,
    required this.responseMessage,
    required this.timestamp,
  });

  final String requestId;
  final bool success;
  final String responseCode;
  final String responseMessage;
  final DateTime? timestamp;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      requestId: json["request_id"] ?? "",
      success: json["success"] ?? false,
      responseCode: json["response_code"] ?? "",
      responseMessage: json["response_message"] ?? "",
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
    );
  }
}
