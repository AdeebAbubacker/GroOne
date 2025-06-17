class UploadGSTDocumentModel {
  UploadGSTDocumentModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  factory UploadGSTDocumentModel.fromJson(Map<String, dynamic> json){
    return UploadGSTDocumentModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

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

  Map<String, dynamic> toJson() => {
    "url": url,
  };

}
