class KycInitResponse {
  final String? requestId;
  final String? webhookSecurityKey;
  final DateTime? requestTimestamp;
  final DateTime? expiresAt;
  final bool? success;
  final String? sdkUrl;
  final String? status;
  final String? dataPdf;

  KycInitResponse({
    this.requestId,
    this.webhookSecurityKey,
    this.requestTimestamp,
    this.expiresAt,
    this.success,
    this.sdkUrl,
    this.status,
    this.dataPdf,
  });

  factory KycInitResponse.fromJson(Map<String, dynamic> json) {
    return KycInitResponse(
      status:json['status'] as String? ,
      dataPdf:json['data_pdf'] as String? ,
      requestId: json['request_id'] as String?,
      webhookSecurityKey: json['webhook_security_key'] as String?,
      requestTimestamp: json['request_timestamp'] != null
          ? DateTime.tryParse(json['request_timestamp'])
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
      success: json['success'] as bool?,
      sdkUrl: json['sdk_url'] as String?,
    );
  }


}
