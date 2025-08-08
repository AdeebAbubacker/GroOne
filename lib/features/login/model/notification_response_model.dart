class DeviceTokenModel {
  String? id;
  String? customerId;
  String? token;
  String? tokenFrom;
  String? deviceId;
  int? status;
  String? createdAt;
  String? updatedAt;

  DeviceTokenModel({
    this.id,
    this.customerId,
    this.token,
    this.tokenFrom,
    this.deviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceTokenModel.fromJson(Map<String, dynamic> json) {
    return DeviceTokenModel(
      id: json['id'] as String?,
      customerId: json['customerId'] as String?,
      token: json['token'] as String?,
      tokenFrom: json['tokenFrom'] as String?,
      deviceId: json['deviceId'] as String?,
      status: json['status'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'token': token,
      'tokenFrom': tokenFrom,
      'deviceId': deviceId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
