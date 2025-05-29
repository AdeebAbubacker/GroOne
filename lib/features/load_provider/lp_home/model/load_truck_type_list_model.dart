class LoadTruckTypeListModel {
  LoadTruckTypeListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<TruckTypeData> data;

  LoadTruckTypeListModel copyWith({
    bool? success,
    String? message,
    List<TruckTypeData>? data,
  }) {
    return LoadTruckTypeListModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LoadTruckTypeListModel.fromJson(Map<String, dynamic> json){
    return LoadTruckTypeListModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<TruckTypeData>.from(json["data"]!.map((x) => TruckTypeData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class TruckTypeData {
  TruckTypeData({
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
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  TruckTypeData copyWith({
    int? id,
    String? type,
    String? subType,
    dynamic? iconUrl,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return TruckTypeData(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      iconUrl: iconUrl ?? this.iconUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory TruckTypeData.fromJson(Map<String, dynamic> json){
    return TruckTypeData(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
      iconUrl: json["iconUrl"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "subType": subType,
    "iconUrl": iconUrl,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
