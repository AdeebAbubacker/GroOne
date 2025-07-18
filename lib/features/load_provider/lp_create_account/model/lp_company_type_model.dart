class LpCompanyTypeModel {
  LpCompanyTypeModel({
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

  LpCompanyTypeModel copyWith({
    int? id,
    String? companyType,
    int? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return LpCompanyTypeModel(
      id: id ?? this.id,
      companyType: companyType ?? this.companyType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LpCompanyTypeModel.fromJson(Map<String, dynamic> json){
    return LpCompanyTypeModel(
      id: json["id"] ?? 0,
      companyType: json["companyType"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
