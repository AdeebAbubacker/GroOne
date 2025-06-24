class TruckLengthModel {
  final int id;
  final String type;
  final String subType;

  TruckLengthModel({
    required this.id,
    required this.type,
    required this.subType,
  });

  factory TruckLengthModel.fromJson(Map<String, dynamic> json) {
    return TruckLengthModel(
      id: json['id'],
      type: json['type'],
      subType: json['subType'],
    );
  }
}
