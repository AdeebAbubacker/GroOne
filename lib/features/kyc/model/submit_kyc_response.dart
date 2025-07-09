class SubmitKycModel {
  SubmitKycModel({
    required this.message,
  });

  final String message;

  SubmitKycModel copyWith({
    String? message,
  }) {
    return SubmitKycModel(
      message: message ?? this.message,
    );
  }

  factory SubmitKycModel.fromJson(Map<String, dynamic> json){
    return SubmitKycModel(
      message: json["message"] ?? "",
    );
  }

}
