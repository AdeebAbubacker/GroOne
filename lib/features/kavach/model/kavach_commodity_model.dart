class CommodityModel {
  final int id;
  final String name;

  CommodityModel({required this.id, required this.name});

  factory CommodityModel.fromJson(Map<String, dynamic> json) {
    return CommodityModel(
      id: json['id'],
      name: json['name'],
    );
  }
}