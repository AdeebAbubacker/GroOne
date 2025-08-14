class DocVerificationModel {
  final String? message;
  final String? error;
  final int? statusCode;

  DocVerificationModel({
    required this.message,
    required this.error,
    required this.statusCode,
  });

  factory DocVerificationModel.fromJson(Map<String, dynamic> json) {
    print("message is ${ json['message'] ?? ''}");
    return DocVerificationModel(
      message: json['message'] ?? '',
      error: json['error'] ?? '',
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'error': error,
      'statusCode': statusCode,
    };
  }
}
