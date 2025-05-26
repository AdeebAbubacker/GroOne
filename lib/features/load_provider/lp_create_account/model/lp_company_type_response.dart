class LpCompanyTypeResponse {
  LpCompanyTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<CompanyType> data;

  factory LpCompanyTypeResponse.fromJson(Map<String, dynamic> json) {
    return LpCompanyTypeResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data:
          json["data"] == null
              ? []
              : List<CompanyType>.from(
                json["data"]!.map((x) => CompanyType.fromJson(x)),
              ),
    );
  }
}

class CompanyType {
  CompanyType({
    required this.id,
    required this.companyType,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String companyType;
  final num status;
  final dynamic createdAt;
  final dynamic deletedAt;

  factory CompanyType.fromJson(Map<String, dynamic> json) {
    return CompanyType(
      id: json["id"] ?? 0,
      companyType: json["companyType"] ?? "",
      status: json["status"] ?? 0,
      createdAt: json["createdAt"],
      deletedAt: json["deletedAt"],
    );
  }
}
