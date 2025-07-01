class LpLoadVerifyAdvanceResponse {
  LpLoadVerifyAdvanceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final dynamic data;

  LpLoadVerifyAdvanceResponse copyWith({
    bool? success,
    String? message,
    dynamic? data,
  }) {
    return LpLoadVerifyAdvanceResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory LpLoadVerifyAdvanceResponse.fromJson(Map<String, dynamic> json){
    return LpLoadVerifyAdvanceResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"],
    );
  }

}
