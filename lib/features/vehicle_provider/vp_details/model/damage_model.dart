class DamageModel {
  DamageModel({
    required this.vehicleId,
    required this.loadId,
    required this.itemName,
    required this.quantity,
    required this.image,
    required this.description,
    required this.updatedAt,
    required this.damageId,
    required this.createdAt,
    required this.deletedAt,
  });

  final String vehicleId;
  final String loadId;
  final String itemName;
  final int quantity;
  final List<String> image;
  final String description;
  final dynamic updatedAt;
  final String damageId;
  final DateTime? createdAt;
  final dynamic deletedAt;

  DamageModel copyWith({
    String? vehicleId,
    String? loadId,
    String? itemName,
    int? quantity,
    List<String>? image,
    String? description,
    dynamic? updatedAt,
    String? damageId,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return DamageModel(
      vehicleId: vehicleId ?? this.vehicleId,
      loadId: loadId ?? this.loadId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      description: description ?? this.description,
      updatedAt: updatedAt ?? this.updatedAt,
      damageId: damageId ?? this.damageId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory DamageModel.fromJson(Map<String, dynamic> json){
    return DamageModel(
      vehicleId: json["vehicleId"] ?? "",
      loadId: json["loadId"] ?? "",
      itemName: json["itemName"] ?? "",
      quantity: json["quantity"] ?? 0,
      image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
      description: json["description"] ?? "",
      updatedAt: json["updatedAt"],
      damageId: json["damageId"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
