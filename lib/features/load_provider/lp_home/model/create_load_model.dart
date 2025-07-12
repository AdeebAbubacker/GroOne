class CreateLoadModel {
  CreateLoadModel({
    required this.data,
  });

  final Data? data;

  CreateLoadModel copyWith({
    Data? data,
  }) {
    return CreateLoadModel(
      data: data ?? this.data,
    );
  }

  factory CreateLoadModel.fromJson(Map<String, dynamic> json){
    return CreateLoadModel(
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.loadId,
    required this.loadSeriesId,
    required this.customerId,
  });

  final String loadId;
  final String loadSeriesId;
  final String customerId;

  Data copyWith({
    String? loadId,
    String? loadSeriesId,
    String? customerId,
  }) {
    return Data(
      loadId: loadId ?? this.loadId,
      loadSeriesId: loadSeriesId ?? this.loadSeriesId,
      customerId: customerId ?? this.customerId,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      loadId: json["loadId"] ?? "",
      loadSeriesId: json["loadSeriesId"] ?? "",
      customerId: json["customerId"] ?? "",
    );
  }

}
