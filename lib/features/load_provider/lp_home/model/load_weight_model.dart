class LoadWeightModel {
  bool success;
  String message;
  List<LoadWeightData> data;

  LoadWeightModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoadWeightModel.fromJson(Map<String, dynamic> json) => LoadWeightModel(
    success: json["success"],
    message: json["message"],
    data: List<LoadWeightData>.from(json["data"].map((x) => LoadWeightData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

}

class LoadWeightData {
  int id;
  int measurementUnitId;
  int value;
  dynamic description;
  int status;
  DateTime createdAt;
  dynamic deletedAt;

  LoadWeightData({
    required this.id,
    required this.measurementUnitId,
    required this.value,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.deletedAt,
  });

  factory LoadWeightData.fromJson(Map<String, dynamic> json) => LoadWeightData(
    id: json["id"],
    measurementUnitId: json["measurementUnitId"],
    value: json["value"],
    description: json["description"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    deletedAt: json["deletedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "measurementUnitId": measurementUnitId,
    "value": value,
    "description": description,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "deletedAt": deletedAt,
  };
}