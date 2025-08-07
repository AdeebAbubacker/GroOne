class LicenseCategoryResponseModel {
  LicenseCategoryResponseModel({
    this.id,
    this.categoryName,
    this.status,
    this.createdAt,
    this.deletedAt,
  });

  final int? id;
  final String? categoryName;
  final int? status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  LicenseCategoryResponseModel copyWith({
    int? id,
    String? categoryName,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
  }) {
    return LicenseCategoryResponseModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LicenseCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return LicenseCategoryResponseModel(
      id: json["id"],
      categoryName: json["categoryName"],
      status: json["status"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      deletedAt: json["deletedAt"],
    );
  }
}
