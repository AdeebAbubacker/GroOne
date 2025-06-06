class MasterResponse {
  MasterResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<Datum> data;

  factory MasterResponse.fromJson(Map<String, dynamic> json){
    return MasterResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

}

class Datum {
  Datum({
    required this.id,
    required this.customerId,
    required this.pickupAddress,
    required this.dropAddress,
    required this.isDefault,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final num customerId;
  final String pickupAddress;
  final String dropAddress;
  final bool isDefault;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["id"] ?? 0,
      customerId: json["customerId"] ?? 0,
      pickupAddress: json["pickupAddress"] ?? "",
      dropAddress: json["dropAddress"] ?? "",
      isDefault: json["isDefault"] ?? false,
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "customerId": customerId,
    "pickupAddress": pickupAddress,
    "dropAddress": dropAddress,
    "isDefault": isDefault,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

}
