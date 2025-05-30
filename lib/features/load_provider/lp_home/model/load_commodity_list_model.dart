class LoadCommodityListModel {
  LoadCommodityListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<LoadCommodityList> data;

  LoadCommodityListModel copyWith({
    bool? success,
    String? message,
    List<LoadCommodityList>? data,
  }) {
    return LoadCommodityListModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LoadCommodityListModel.fromJson(Map<String, dynamic> json){
    return LoadCommodityListModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<LoadCommodityList>.from(json["data"]!.map((x) => LoadCommodityList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class LoadCommodityList {
  LoadCommodityList({
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

  LoadCommodityList copyWith({
    int? id,
    String? name,
    dynamic? description,
    dynamic? iconUrl,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return LoadCommodityList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadCommodityList.fromJson(Map<String, dynamic> json){
    return LoadCommodityList(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"],
      iconUrl: json["iconUrl"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "iconUrl": iconUrl,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
