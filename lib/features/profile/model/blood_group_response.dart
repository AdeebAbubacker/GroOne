class BloodGroupResponseModel {
  BloodGroupResponseModel({
    this.id,
    this.groupName,
    this.status,
    this.createdAt,
    this.deletedAt,
  });

  final int? id;
  final String? groupName;
  final int? status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  BloodGroupResponseModel copyWith({
    int? id,
    String? groupName,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
  }) {
    return BloodGroupResponseModel(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory BloodGroupResponseModel.fromJson(Map<String, dynamic> json) {
    return BloodGroupResponseModel(
      id: json["id"],
      groupName: json["groupName"],
      status: json["status"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      deletedAt: json["deletedAt"],
    );
  }
}
