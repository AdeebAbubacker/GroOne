class SubmitKycModel {
  SubmitKycModel({
    required this.status,
    required this.message,
  });

  final bool status;
  final String message;

  factory SubmitKycModel.fromJson(Map<String, dynamic> json){
    return SubmitKycModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };

}
