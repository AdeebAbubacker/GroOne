class LpLoadCreditUpdateResponse {
  LpLoadCreditUpdateResponse({
    required this.id,
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

  final int id;
  final num customerId;
  final num creditLimit;
  final String remarks;
  final num utilisedLimit;
  final num availableCreditLimit;
  final String insuranceLimit;
  final String uploadCreditReport;
  final num statusCode;
  final num approvedByNumbers;
  final num status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LpLoadCreditUpdateResponse copyWith({
    int? id,
    num? customerId,
    num? creditLimit,
    String? remarks,
    num? utilisedLimit,
    num? availableCreditLimit,
    String? insuranceLimit,
    String? uploadCreditReport,
    num? statusCode,
    num? approvedByNumbers,
    num? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LpLoadCreditUpdateResponse(
      id: id ?? this.id,
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

  factory LpLoadCreditUpdateResponse.fromJson(Map<String, dynamic> json){
    return LpLoadCreditUpdateResponse(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      creditLimit: json["creditLimit"] ?? 0,
      remarks: json["remarks"] ?? "",
      utilisedLimit: json["utilisedLimit"] ?? 0,
      availableCreditLimit: json["availableCreditLimit"] ?? 0,
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
