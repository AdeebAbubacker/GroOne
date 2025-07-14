class CreditCheckApiResponse {
  CreditCheckApiResponse({
    required this.data,
    required this.message,
  });

  final Data? data;
  final String message;

  CreditCheckApiResponse copyWith({
    Data? data,
    String? message,
  }) {
    return CreditCheckApiResponse(
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  factory CreditCheckApiResponse.fromJson(Map<String, dynamic> json){
    return CreditCheckApiResponse(
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      message: json["message"] ?? "",
    );
  }

}

class Data {
  Data({
    required this.creditLimitId,
    required this.customerId,
    required this.creditLimit,
    required this.remarks,
    required this.utilisedLimit,
    required this.availableCreditLimit,
    required this.insuranceLimit,
    required this.uploadCreditReport,
    required this.statusCode,
    required this.approvedByNumbers,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String creditLimitId;
  final String customerId;
  final String creditLimit;
  final String remarks;
  final String utilisedLimit;
  final String availableCreditLimit;
  final String insuranceLimit;
  final String uploadCreditReport;
  final num statusCode;
  final num approvedByNumbers;
  final num status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data copyWith({
    String? creditLimitId,
    String? customerId,
    String? creditLimit,
    String? remarks,
    String? utilisedLimit,
    String? availableCreditLimit,
    String? insuranceLimit,
    String? uploadCreditReport,
    num? statusCode,
    num? approvedByNumbers,
    num? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Data(
      creditLimitId: creditLimitId ?? this.creditLimitId,
      customerId: customerId ?? this.customerId,
      creditLimit: creditLimit ?? this.creditLimit,
      remarks: remarks ?? this.remarks,
      utilisedLimit: utilisedLimit ?? this.utilisedLimit,
      availableCreditLimit: availableCreditLimit ?? this.availableCreditLimit,
      insuranceLimit: insuranceLimit ?? this.insuranceLimit,
      uploadCreditReport: uploadCreditReport ?? this.uploadCreditReport,
      statusCode: statusCode ?? this.statusCode,
      approvedByNumbers: approvedByNumbers ?? this.approvedByNumbers,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      creditLimitId: json["creditLimitId"] ?? "",
      customerId: json["customerId"] ?? "",
      creditLimit: json["creditLimit"] ?? "",
      remarks: json["remarks"] ?? "",
      utilisedLimit: json["utilisedLimit"] ?? "",
      availableCreditLimit: json["availableCreditLimit"] ?? "",
      insuranceLimit: json["insuranceLimit"] ?? "",
      uploadCreditReport: json["uploadCreditReport"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      approvedByNumbers: json["approvedByNumbers"] ?? 0,
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
