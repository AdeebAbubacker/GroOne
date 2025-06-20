class TruckTypeModel {
  TruckTypeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<TruckTypeData> data;

  TruckTypeModel copyWith({
    bool? success,
    String? message,
    List<TruckTypeData>? data,
  }) {
    return TruckTypeModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory TruckTypeModel.fromJson(Map<String, dynamic> json){
    return TruckTypeModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<TruckTypeData>.from(json["data"]!.map((x) => TruckTypeData.fromJson(x))),
    );
  }

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

}
