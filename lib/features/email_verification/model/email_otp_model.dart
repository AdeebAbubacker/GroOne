class EmailOtpModel {
  EmailOtpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  EmailOtpModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return EmailOtpModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory EmailOtpModel.fromJson(Map<String, dynamic> json){
    return EmailOtpModel(
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
