class VehicleVerificationResponse {
  final bool status;
  final String message;
  final VehicleVerificationData? data;

  VehicleVerificationResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory VehicleVerificationResponse.fromJson(Map<String, dynamic> json) {
    return VehicleVerificationResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null 
          ? VehicleVerificationData.fromJson(json['data']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return 'VehicleVerificationResponse{status: $status, message: $message, data: $data}';
  }
}

class VehicleVerificationData {
  final String message;

  VehicleVerificationData({
    required this.message,
  });

  factory VehicleVerificationData.fromJson(Map<String, dynamic> json) {
    return VehicleVerificationData(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  @override
  String toString() {
    return 'VehicleVerificationData{message: $message}';
  }
} 