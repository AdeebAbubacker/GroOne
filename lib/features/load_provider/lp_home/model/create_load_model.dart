class CreateLoadModel {
  CreateLoadModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  CreateLoadModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return CreateLoadModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory CreateLoadModel.fromJson(Map<String, dynamic> json){
    return CreateLoadModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

}

class Data {
  Data({
    required this.status,
    required this.createdAt,
    required this.id,
    required this.loadId,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.deletedAt,
  });

  final num status;
  final DateTime? createdAt;
  final int id;
  final String loadId;
  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;
  final dynamic deletedAt;

  Data copyWith({
    num? status,
    DateTime? createdAt,
    int? id,
    String? loadId,
    num? customerId,
    num? commodityId,
    num? truckTypeId,
    String? pickUpAddr,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLatlon,
    DateTime? dueDate,
    num? consignmentWeight,
    dynamic? deletedAt,
  }) {
    return Data(
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      loadId: loadId ?? this.loadId,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      dueDate: dueDate ?? this.dueDate,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      id: json["id"] ?? "",
      loadId: json["loadId"] ?? 0,
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      pickUpAddr: json["pickUpAddr"] ?? "",
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json["consignmentWeight"] ?? 0,
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "id": id,
    "loadId": loadId,
    "customerId": customerId,
    "commodityId": commodityId,
    "truckTypeId": truckTypeId,
    "pickUpAddr": pickUpAddr,
    "pickUpLatlon": pickUpLatlon,
    "dropAddr": dropAddr,
    "dropLatlon": dropLatlon,
    "dueDate": dueDate?.toIso8601String(),
    "consignmentWeight": consignmentWeight,
    "deletedAt": deletedAt,
  };

}
