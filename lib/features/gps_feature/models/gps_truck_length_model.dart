class GpsTruckLengthModel {
  final int id;
  final String type;
  final String subType;

  GpsTruckLengthModel({
    required this.id,
    required this.type,
    required this.subType,
  });

  factory GpsTruckLengthModel.fromJson(Map<String, dynamic> json) {
    return GpsTruckLengthModel(
      id: json['id'],
      type: json['type'],
      subType: json['subType'],
    );
  }
} 