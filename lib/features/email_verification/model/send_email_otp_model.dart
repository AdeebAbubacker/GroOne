class SendEmailOtpModel {
  SendEmailOtpModel({

    required this.message,
    required this.data,
  });


  final String message;
  final Data? data;

  SendEmailOtpModel copyWith({

    String? message,
    Data? data,
  }) {
    return SendEmailOtpModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory SendEmailOtpModel.fromJson(Map<String, dynamic> json){
    return SendEmailOtpModel(
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
