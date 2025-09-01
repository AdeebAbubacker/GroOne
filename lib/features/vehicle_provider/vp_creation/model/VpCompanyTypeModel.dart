class VpCompanyTypeModel {
  VpCompanyTypeModel({
    required this.id,
    required this.companyType,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String companyType;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  VpCompanyTypeModel copyWith({
    int? id,
    String? companyType,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
  }) {
    return VpCompanyTypeModel(
      id: id ?? this.id,
      companyType: companyType ?? this.companyType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory VpCompanyTypeModel.fromJson(Map<String, dynamic> json){
    return VpCompanyTypeModel(
      id: json["id"] ?? 0,
      companyType: json["companyType"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
