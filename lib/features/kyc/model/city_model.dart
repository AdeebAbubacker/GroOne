class CityModel {
  CityModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final CityData? data;

  CityModel copyWith({
    bool? success,
    String? message,
    CityData? data,
  }) {
    return CityModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory CityModel.fromJson(Map<String, dynamic> json){
    return CityModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : CityData.fromJson(json["data"]),
    );
  }

}

class CityData {
  CityData({
    required this.success,
    required this.response,
  });

  final bool success;
  final List<String> response;

  CityData copyWith({
    bool? success,
    List<String>? response,
  }) {
    return CityData(
      success: success ?? this.success,
      response: response ?? this.response,
    );
  }

  factory CityData.fromJson(Map<String, dynamic> json){
    return CityData(
      success: json["success"] ?? false,
      response: json["response"] == null ? [] : List<String>.from(json["response"]!.map((x) => x)),
    );
  }

}
