class LoadTruckTypeListModel {
  LoadTruckTypeListModel({
    required this.id,
    required this.type,
    required this.subType,
    required this.iconUrl,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String type;
  final String subType;
  final dynamic iconUrl;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  LoadTruckTypeListModel copyWith({
    int? id,
    String? type,
    String? subType,
    dynamic? iconUrl,
    int? status,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return LoadTruckTypeListModel(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadTruckTypeListModel.fromJson(Map<String, dynamic> json){
    return LoadTruckTypeListModel(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
      iconUrl: json["iconUrl"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: DateTime.tryParse(json["deletedAt"] ?? ""),
    );
  }

}
