class LoadWeightModel {
  LoadWeightModel({
    required this.id,
    required this.measurementUnitId,
    required this.value,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final int measurementUnitId;
  final int value;
  final dynamic description;
  final int status;
  final DateTime? createdAt;
  final dynamic deletedAt;

  LoadWeightModel copyWith({
    int? id,
    int? measurementUnitId,
    int? value,
    dynamic description,
    int? status,
    DateTime? createdAt,
    dynamic deletedAt,
  }) {
    return LoadWeightModel(
      id: id ?? this.id,
      measurementUnitId: measurementUnitId ?? this.measurementUnitId,
      value: value ?? this.value,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadWeightModel.fromJson(Map<String, dynamic> json){
    return LoadWeightModel(
      id: json["weightageId"] ?? 0,
      measurementUnitId: json["measurementUnitId"] ?? 0,
      value: json["value"] ?? 0,
      description: json["description"],
      status: json["status"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
