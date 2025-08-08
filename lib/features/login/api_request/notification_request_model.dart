class NotificationRequestModel {
  String? token;
  String? tokenFrom;
  String? customerId;
  String? deviceId;

  NotificationRequestModel({
    this.token,
    this.tokenFrom,
    this.customerId,
    this.deviceId,
  });

  /// Convert JSON to Dart object
  factory NotificationRequestModel.fromJson(Map<String, dynamic> json) {
    return NotificationRequestModel(
      token: json['token'] as String?,
      tokenFrom: json['token_from'] as String?,
      customerId: json['customer_id'] as String?,
      deviceId: json['device_id'] as String?,
    );
  }

  /// Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'token_from': tokenFrom,
      'customer_id': customerId,
      'device_id': deviceId,
    };
  }
}
