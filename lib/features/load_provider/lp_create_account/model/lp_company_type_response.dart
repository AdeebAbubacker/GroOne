class VpCompanyTypeResponse {
  VpCompanyTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<CompanyType> data;

  factory VpCompanyTypeResponse.fromJson(Map<String, dynamic> json) {
    return VpCompanyTypeResponse(
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


class LpCompanyTypeResponse {
    LpCompanyTypeResponse({
        required this.id,
        required this.companyType,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
    });

    final int? id;
    final String? companyType;
    final int? status;
    final DateTime? createdAt;
    final dynamic deletedAt;

    LpCompanyTypeResponse copyWith({
        int? id,
        String? companyType,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return LpCompanyTypeResponse(
            id: id ?? this.id,
            companyType: companyType ?? this.companyType,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory LpCompanyTypeResponse.fromJson(Map<String, dynamic> json){ 
        return LpCompanyTypeResponse(
            id: json["id"],
            companyType: json["companyType"],
            status: json["status"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}
