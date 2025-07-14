class DeleteDamageModel {
  DeleteDamageModel({
    required this.message,
  });

  final String message;

  DeleteDamageModel copyWith({
    String? message,
  }) {
    return DeleteDamageModel(
      message: message ?? this.message,
    );
  }

  factory DeleteDamageModel.fromJson(Map<String, dynamic> json){
    return DeleteDamageModel(
      message: json["message"] ?? "",
    );
  }

}
