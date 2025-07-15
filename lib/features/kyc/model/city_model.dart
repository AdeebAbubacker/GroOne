class CityModel {
  CityModel({
    required this.id,
    required this.country,
    required this.countryCode,
    required this.state,
    required this.stateCode,
    required this.city,
    required this.createdAt,
    required this.deletedAt,
  });

  final int id;
  final String country;
  final String countryCode;
  final String state;
  final String stateCode;
  final String city;
  final DateTime? createdAt;
  final dynamic deletedAt;

  CityModel copyWith({
    int? id,
    String? country,
    String? countryCode,
    String? state,
    String? stateCode,
    String? city,
    DateTime? createdAt,
    dynamic? deletedAt,
  }) {
    return CityModel(
      id: id ?? this.id,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory CityModel.fromJson(Map<String, dynamic> json){
    return CityModel(
      id: json["id"] ?? 0,
      country: json["country"] ?? "",
      countryCode: json["countryCode"] ?? "",
      state: json["state"] ?? "",
      stateCode: json["stateCode"] ?? "",
      city: json["city"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
