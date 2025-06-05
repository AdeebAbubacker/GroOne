class GetLoadResponse {
  GetLoadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<LoadData> data;

  factory GetLoadResponse.fromJson(Map<String, dynamic> json){
    return GetLoadResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<LoadData>.from(json["data"]!.map((x) => LoadData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class LoadData {
  LoadData({
    required this.id,
    required this.customerId,
    required this.commodityId,
    required this.truckTypeId,
    required this.pickUpAddr,
    required this.pickUpLatlon,
    required this.dropAddr,
    required this.dropLatlon,
    required this.dueDate,
    required this.consignmentWeight,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final num customerId;
  final num commodityId;
  final num truckTypeId;
  final String pickUpAddr;
  final String pickUpLatlon;
  final String dropAddr;
  final String dropLatlon;
  final DateTime? dueDate;
  final num consignmentWeight;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory LoadData.fromJson(Map<String, dynamic> json){
    return LoadData(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      commodityId: json["commodityId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      pickUpAddr: json["pickUpAddr"] ?? "",
      pickUpLatlon: json["pickUpLatlon"] ?? "",
      dropAddr: json["dropAddr"] ?? "",
      dropLatlon: json["dropLatlon"] ?? "",
      dueDate: DateTime.tryParse(json["dueDate"] ?? ""),
      consignmentWeight: json["consignmentWeight"] ?? 0,
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "commodityId": commodityId,
    "truckTypeId": truckTypeId,
    "pickUpAddr": pickUpAddr,
    "pickUpLatlon": pickUpLatlon,
    "dropAddr": dropAddr,
    "dropLatlon": dropLatlon,
    "dueDate": dueDate?.toIso8601String(),
    "consignmentWeight": consignmentWeight,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

  // {
  // "id": 26,
  // "customerId": 146,
  // "commodityId": 1,
  // "truckTypeId": 5,
  // "pickUpAddr": "Google Building 43, Mountain View, United States",
  // "assignStatus": 1,
  // "pickUpLatlon": "37.4219983,-122.084",
  // "dropAddr": "New York, NY, USA",
  // "dropLatlon": "40.7127753,-74.0059728",
  // "dueDate": "2025-06-20T00:00:00.000Z",
  // "consignmentWeight": 12,
  // "notes": "12000-15000",
  // "rate": "12000-15000",
  // "status": 1,
  // "acceptedBy": null,
  // "createdAt": "2025-06-03T08:32:41.036Z",
  // "deletedAt": null

}
