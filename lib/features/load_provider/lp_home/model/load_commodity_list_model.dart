class LoadCommodityListModel {
  LoadCommodityListModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String name;
  final dynamic description;
  final dynamic iconUrl;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  LoadCommodityListModel copyWith({
    int? id,
    String? name,
    dynamic description,
    dynamic iconUrl,
    int? status,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return LoadCommodityListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadCommodityListModel.fromJson(Map<String, dynamic> json){
    return LoadCommodityListModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"],
      iconUrl: json["iconUrl"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: DateTime.tryParse(json["deletedAt"] ?? ""),
    );
  }

}
