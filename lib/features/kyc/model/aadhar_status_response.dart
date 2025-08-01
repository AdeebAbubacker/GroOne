class AadharVerificationResponse {
  final bool? success;
  final String? message;
  final AadharVerificationData? data;

  AadharVerificationResponse({
    this.success,
    this.message,
    this.data,
  });

  factory AadharVerificationResponse.fromJson(Map<String, dynamic> json) {
    return AadharVerificationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? AadharVerificationData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class AadharVerificationData {
  final String? requestId;
  final String? status;
  final String? aadharNumber;
  final String? sentAt;
  final ApiResponse? apiResponse;
  final String? dataPdf;

  AadharVerificationData({
    this.requestId,
    this.status,
    this.aadharNumber,
    this.sentAt,
    this.apiResponse,
    this.dataPdf,
  });

  factory AadharVerificationData.fromJson(Map<String, dynamic> json) {
    return AadharVerificationData(
      requestId: json['request_id'],
      status: json['status'],
      aadharNumber: json['aadhar_number'],
      sentAt: json['sent_at'],
      apiResponse: json['api_response'] != null
          ? ApiResponse.fromJson(json['api_response'])
          : null,
      dataPdf: json['data_pdf'],
    );
  }

  Map<String, dynamic> toJson() => {
    'request_id': requestId,
    'status': status,
    'aadhar_number': aadharNumber,
    'sent_at': sentAt,
    'api_response': apiResponse?.toJson(),
    'data_pdf': dataPdf,
  };
}

class ApiResponse {
  final String? requestId;
  final String? webhookSecurityKey;
  final String? requestTimestamp;
  final String? expiresAt;
  final bool? success;
  final String? sdkUrl;

  ApiResponse({
    this.requestId,
    this.webhookSecurityKey,
    this.requestTimestamp,
    this.expiresAt,
    this.success,
    this.sdkUrl,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      requestId: json['request_id'],
      webhookSecurityKey: json['webhook_security_key'],
      requestTimestamp: json['request_timestamp'],
      expiresAt: json['expires_at'],
      success: json['success'],
      sdkUrl: json['sdk_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'request_id': requestId,
    'webhook_security_key': webhookSecurityKey,
    'request_timestamp': requestTimestamp,
    'expires_at': expiresAt,
    'success': success,
    'sdk_url': sdkUrl,
  };
}
