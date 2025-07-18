class ResendEmailOtpModel {
  ResendEmailOtpModel({

    required this.message,

  });

  final String message;


  ResendEmailOtpModel copyWith({

    String? message,

  }) {
    return ResendEmailOtpModel(
      message: message ?? this.message,
    );
  }

  factory ResendEmailOtpModel.fromJson(Map<String, dynamic> json){
    return ResendEmailOtpModel(
      message: json["message"] ?? "",

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
