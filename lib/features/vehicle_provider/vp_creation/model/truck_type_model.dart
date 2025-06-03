class TruckTypeModel {
  TruckTypeModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<String> data;

  TruckTypeModel copyWith({
    bool? success,
    String? message,
    List<String>? data,
  }) {
    return TruckTypeModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory TruckTypeModel.fromJson(Map<String, dynamic> json){
    return TruckTypeModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
    );
  }

}
