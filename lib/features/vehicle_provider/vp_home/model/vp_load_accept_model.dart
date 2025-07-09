class VpLoadAcceptModel {
  VpLoadAcceptModel({

    required this.message,
    required this.data,
  });


  final String message;
  final Load? data;

  VpLoadAcceptModel copyWith({
    bool? success,
    String? message,
    Load? data,
  }) {
    return VpLoadAcceptModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory VpLoadAcceptModel.fromJson(Map<String, dynamic> json){
    return VpLoadAcceptModel(

      message: json["message"] ?? "",
      data: json["data"] == null ? null : Load.fromJson(json["data"]),
    );
  }



}



class Load {
  Load({
    required this.id,
    required this.status,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.assignStatus,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.rate,
    required this.acceptedBy,
    required this.createdAt,
    required this.deletedAt,
    required this.loadStatus,
  });

  final int? id;
  final dynamic status;
  final dynamic customerId;
  final dynamic commodityId;
  final dynamic truckTypeId;
  final dynamic pickUpAddr;
  final dynamic assignStatus;
  final dynamic pickUpLatlon;
  final dynamic dropAddr;
  final dynamic dropLatlon;
  final DateTime? dueDate;
  final dynamic consignmentWeight;
  final dynamic rate;
  final dynamic acceptedBy;
  final DateTime? createdAt;
  final dynamic? loadStatus;
  final dynamic deletedAt;

  Load copyWith({
    int? id,
    int? loadStatus,
    num? status,
    num? customerId,
    num? commodityId,
    num? truckTypeId,
    String? pickUpAddr,
    num? assignStatus,
    String? pickUpLatlon,
    String? dropAddr,
    String? dropLatlon,
    DateTime? dueDate,
    num? consignmentWeight,
    String? rate,
    num? acceptedBy,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return Load(
      loadStatus: loadStatus?? this.loadStatus,
      id: id ?? this.id,
      status: status ?? this.status,
      customerId: customerId ?? this.customerId,
      commodityId: commodityId ?? this.commodityId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      pickUpAddr: pickUpAddr ?? this.pickUpAddr,
      assignStatus: assignStatus ?? this.assignStatus,
      pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
      dropAddr: dropAddr ?? this.dropAddr,
      dropLatlon: dropLatlon ?? this.dropLatlon,
      dueDate: dueDate ?? this.dueDate,
      consignmentWeight: consignmentWeight ?? this.consignmentWeight,
      rate: rate ?? this.rate,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Load.fromJson(Map<String, dynamic> json){
    return Load(
      loadStatus: json["loadStatusId"] ?? 0,
      id: json["id"] ?? 0,
      status: json["status"] ?? 0,
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      pickUpAddr: json["pickUpAddr"] ?? "",
      assignStatus: json["assignStatus"] ?? 0,
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json["consignmentWeight"] ?? 0,
      rate: json["rate"] ?? "",
      acceptedBy: json["acceptedBy"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "customerId": customerId,
    "commodityId": commodityId,
    "truckTypeId": truckTypeId,
    "pickUpAddr": pickUpAddr,
    "assignStatus": assignStatus,
    "pickUpLatlon": pickUpLatlon,
    "dropAddr": dropAddr,
    "dropLatlon": dropLatlon,
    "dueDate": dueDate?.toIso8601String(),
    "consignmentWeight": consignmentWeight,
    "rate": rate,
    "acceptedBy": acceptedBy,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
