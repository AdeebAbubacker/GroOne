class RateDiscoveryModel {
  RateDiscoveryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  RateDiscoveryModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return RateDiscoveryModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory RateDiscoveryModel.fromJson(Map<String, dynamic> json){
    return RateDiscoveryModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.pickUp,
    required this.drop,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String pickUp;
  final String drop;
  final String price;
  final num status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  Data copyWith({
    int? id,
    String? pickUp,
    String? drop,
    String? price,
    num? status,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return Data(
      id: id ?? this.id,
      pickUp: pickUp ?? this.pickUp,
      drop: drop ?? this.drop,
      price: price ?? this.price,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"] ?? 0,
      pickUp: json["pickUp"] ?? "",
      drop: json["drop"] ?? "",
      price: json["price"] ?? "",
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
