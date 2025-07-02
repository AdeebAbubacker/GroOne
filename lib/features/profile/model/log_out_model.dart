class LogOutModel {
  LogOutModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  factory LogOutModel.fromJson(Map<String, dynamic> json){
    return LogOutModel(
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
  Data({required this.json});
  final Map<String,dynamic> json;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
        json: json
    );
  }

  Map<String, dynamic> toJson() => {
  };

}
