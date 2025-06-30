class CreditCheckApiResponse {
  final bool success;
  final String message;
  final int statusCode;
  final LpLoadCreditCheckResponse? data;

  CreditCheckApiResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory CreditCheckApiResponse.fromJson(Map<String, dynamic> json) {
    return CreditCheckApiResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      statusCode: json["statusCode"] ?? 0,
      data: json["data"] == null ? null : LpLoadCreditCheckResponse.fromJson(json["data"]),
    );
  }
}


class LpLoadCreditCheckResponse {
  LpLoadCreditCheckResponse({
    required this.id,
    required this.customerId,
    required this.creditLimit,
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

  final int id;
  final num customerId;
  final String creditLimit;
  final String utilisedLimit;
  final String availableCreditLimit;
  final String insuranceLimit;
  final String uploadCreditReport;
  final num statusCode;
  final num approvedByNumbers;
  final num status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LpLoadCreditCheckResponse copyWith({
    int? id,
    num? customerId,
    String? creditLimit,
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
    return LpLoadCreditCheckResponse(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      creditLimit: creditLimit ?? this.creditLimit,
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

  factory LpLoadCreditCheckResponse.fromJson(Map<String, dynamic> json){
    return LpLoadCreditCheckResponse(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      creditLimit: json["creditLimit"] ?? "",
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
