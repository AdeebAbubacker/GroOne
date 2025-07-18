class UpdateDamageModel {
  UpdateDamageModel({
    required this.damageId,
    required this.vehicleId,
    required this.loadId,
    required this.itemName,
    required this.quantity,
    required this.status,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final String damageId;
  final String vehicleId;
  final String loadId;
  final String itemName;
  final int quantity;
  final int status;
  final List<String> image;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  UpdateDamageModel copyWith({
    String? damageId,
    String? vehicleId,
    String? loadId,
    String? itemName,
    int? quantity,
    int? status,
    List<String>? image,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
  }) {
    return UpdateDamageModel(
      damageId: damageId ?? this.damageId,
      vehicleId: vehicleId ?? this.vehicleId,
      loadId: loadId ?? this.loadId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      image: image ?? this.image,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory UpdateDamageModel.fromJson(Map<String, dynamic> json){
    return UpdateDamageModel(
      damageId: json["damageId"] ?? "",
      vehicleId: json["vehicleId"] ?? "",
      loadId: json["loadId"] ?? "",
      itemName: json["itemName"] ?? "",
      quantity: json["quantity"] ?? 0,
      status: json["status"] ?? 0,
      image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
      description: json["description"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
