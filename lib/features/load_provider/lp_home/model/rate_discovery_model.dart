class RateDiscoveryModel {
  RateDiscoveryModel({
    required this.message,
    required this.data,
  });

  final String message;
  final Data? data;

  RateDiscoveryModel copyWith({
    String? message,
    Data? data,
  }) {
    return RateDiscoveryModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory RateDiscoveryModel.fromJson(Map<String, dynamic> json){
    return RateDiscoveryModel(
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.rateDiscoveryId,
    required this.laneId,
    required this.truckTypeId,
    required this.price,
    required this.minPrice,
    required this.maxPrice,
    required this.weightId,
    required this.monthYear,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int rateDiscoveryId;
  final int laneId;
  final int truckTypeId;
  final String price;
  final int minPrice;
  final int maxPrice;
  final int weightId;
  final String monthYear;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  Data copyWith({
    int? rateDiscoveryId,
    int? laneId,
    int? truckTypeId,
    String? price,
    int? minPrice,
    int? maxPrice,
    int? weightId,
    String? monthYear,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return Data(
      rateDiscoveryId: rateDiscoveryId ?? this.rateDiscoveryId,
      laneId: laneId ?? this.laneId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      price: price ?? this.price,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      weightId: weightId ?? this.weightId,
      monthYear: monthYear ?? this.monthYear,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      rateDiscoveryId: json["rateDiscoveryId"] ?? 0,
      laneId: json["laneId"] ?? 0,
      truckTypeId: json["truckTypeId"] ?? 0,
      price: json["price"] ?? "",
      minPrice: json["minPrice"] ?? 0,
      maxPrice: json["maxPrice"] ?? 0,
      weightId: json["weightId"] ?? 0,
      monthYear: json["monthYear"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
