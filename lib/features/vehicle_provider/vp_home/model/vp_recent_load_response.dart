class VpRecentLoadResponse {
  VpRecentLoadResponse({
    required this.id,
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
    required this.notes,
    required this.rate,
    required this.status,
    required this.acceptedBy,
    required this.createdAt,
    required this.deletedAt,
    required this.commodity,
    required this.truckType,
    required this.customer,
    required this.customerDetail,
  });

  final int id;
  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final num assignStatus;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;
  final dynamic notes;
  final dynamic rate;
  final num status;
  final dynamic acceptedBy;
  final DateTime? createdAt;
  final dynamic deletedAt;
  final Commodity? commodity;
  final TruckType? truckType;
  final dynamic customer;
  final dynamic customerDetail;

  VpRecentLoadResponse copyWith({
    int? id,
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
    dynamic notes,
    dynamic rate,
    num? status,
    dynamic acceptedBy,
    DateTime? createdAt,
    dynamic deletedAt,
    Commodity? commodity,
    TruckType? truckType,
    dynamic customer,
    dynamic customerDetail,
  }) {
    return VpRecentLoadResponse(
      id: id ?? this.id,
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
      notes: notes ?? this.notes,
      rate: rate ?? this.rate,
      status: status ?? this.status,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      customer: customer ?? this.customer,
      customerDetail: customerDetail ?? this.customerDetail,
    );
  }

  factory VpRecentLoadResponse.fromJson(Map<String, dynamic> json){
    return VpRecentLoadResponse(
      id: json["id"] ?? 0,
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
      notes: json["notes"],
      rate: json["rate"],
      status: json["status"] ?? 0,
      acceptedBy: json["acceptedBy"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
      commodity: json["commodity"] == null ? null : Commodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
      customer: json["customer"],
      customerDetail: json["customerDetail"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
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
    "notes": notes,
    "rate": rate,
    "status": status,
    "acceptedBy": acceptedBy,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
    "commodity": commodity?.toJson(),
    "truckType": truckType?.toJson(),
    "customer": customer,
    "customerDetail": customerDetail,
  };

}

class Commodity {
  Commodity({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  final int id;
  final String name;
  final dynamic iconUrl;

  Commodity copyWith({
    int? id,
    String? name,
    dynamic iconUrl,
  }) {
    return Commodity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  factory Commodity.fromJson(Map<String, dynamic> json){
    return Commodity(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      iconUrl: json["iconUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "iconUrl": iconUrl,
  };

}

class TruckType {
  TruckType({
    required this.id,
    required this.type,
    required this.subType,
  });

  final int id;
  final String type;
  final String subType;

  TruckType copyWith({
    int? id,
    String? type,
    String? subType,
  }) {
    return TruckType(
      id: id ?? this.id,
      type: type ?? this.type,
      subType: subType ?? this.subType,
    );
  }

  factory TruckType.fromJson(Map<String, dynamic> json){
    return TruckType(
      id: json["id"] ?? 0,
      type: json["type"] ?? "",
      subType: json["subType"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "subType": subType,
  };

}
