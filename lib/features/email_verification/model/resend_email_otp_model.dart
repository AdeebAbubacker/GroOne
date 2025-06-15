class ResendEmailOtpModel {
  ResendEmailOtpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  ResendEmailOtpModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return ResendEmailOtpModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ResendEmailOtpModel.fromJson(Map<String, dynamic> json){
    return ResendEmailOtpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({required this.json});
  final Map<String,dynamic> json;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
        json: json
    );
  }

}
