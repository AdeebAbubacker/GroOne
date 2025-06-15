class SendEmailOtpModel {
  SendEmailOtpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final Data? data;

  SendEmailOtpModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return SendEmailOtpModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory SendEmailOtpModel.fromJson(Map<String, dynamic> json){
    return SendEmailOtpModel(
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
