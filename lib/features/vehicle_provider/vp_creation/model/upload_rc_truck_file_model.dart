class UploadRcTruckFileModel {
  UploadRcTruckFileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  factory UploadRcTruckFileModel.fromJson(Map<String, dynamic> json){
    return UploadRcTruckFileModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.url,
  });

  final String url;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      url: json["url"] ?? "",
    );
  }

}
