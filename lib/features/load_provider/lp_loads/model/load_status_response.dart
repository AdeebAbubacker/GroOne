class LoadStatusResponse {
  LoadStatusResponse({
    required this.id,
    required this.loadStatus,
    required this.status,
    required this.statusBgColor,
    required this.statusTxtColor,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int id;
  final String loadStatus;
  final int status;
  final String statusBgColor;
  final String statusTxtColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  LoadStatusResponse copyWith({
    int? id,
    String? loadStatus,
    int? status,
    String? statusBgColor,
    String? statusTxtColor,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return LoadStatusResponse(
      id: id ?? this.id,
      loadStatus: loadStatus ?? this.loadStatus,
      status: status ?? this.status,
      statusBgColor: statusBgColor ?? this.statusBgColor,
      statusTxtColor: statusTxtColor ?? this.statusTxtColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadStatusResponse.fromJson(Map<String, dynamic> json){
    return LoadStatusResponse(
      id: json["id"] ?? 0,
      loadStatus: json["loadStatus"] ?? "",
      status: json["status"] ?? 0,
      statusBgColor: json["statusBgColor"] ?? "",
      statusTxtColor: json["statusTxtColor"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "loadStatus": loadStatus,
    "status": status,
    "statusBgColor": statusBgColor,
    "statusTxtColor": statusTxtColor,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
