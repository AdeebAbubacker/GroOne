class GpsCommodityModel {
  final int id;
  final String name;

  GpsCommodityModel({required this.id, required this.name});

  factory GpsCommodityModel.fromJson(Map<String, dynamic> json) {
    return GpsCommodityModel(
      id: json['id'],
      name: json['name'],
    );
  }
} 