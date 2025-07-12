class VerifyEmailOtpModel {
  VerifyEmailOtpModel({
    required this.message,
    required this.data,
  });


  final String message;
  final Data? data;

  VerifyEmailOtpModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return VerifyEmailOtpModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory VerifyEmailOtpModel.fromJson(Map<String, dynamic> json){
    return VerifyEmailOtpModel(
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
