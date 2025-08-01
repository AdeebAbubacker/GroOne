class VehicleVerificationResponse {
  final bool success;
  final String message;
  final VehicleVerificationData? data;

  VehicleVerificationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory VehicleVerificationResponse.fromJson(Map<String, dynamic> json) {
    return VehicleVerificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null 
          ? VehicleVerificationData.fromJson(json['data']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return 'VehicleVerificationResponse{success: $success, message: $message, data: $data}';
  }
}

class VehicleVerificationData {
  final String? userName;
  final String? rcRegistrationDate;
  final int? vehicleGrossWeight;
  final String? vehicleMakeModel;
  final String? insurancePolicyNumber;
  final String? insuranceExpiryDate;
  final String? rcPuccExpiryDate;
  final String? rcExpiryDate;
  final bool? isValidVehicleType;

  VehicleVerificationData({
    this.userName,
    this.rcRegistrationDate,
    this.vehicleGrossWeight,
    this.vehicleMakeModel,
    this.insurancePolicyNumber,
    this.insuranceExpiryDate,
    this.rcPuccExpiryDate,
    this.rcExpiryDate,
    this.isValidVehicleType,
  });

  factory VehicleVerificationData.fromJson(Map<String, dynamic> json) {
    return VehicleVerificationData(
      userName: json['user_name'],
      rcRegistrationDate: json['rc_registration_date'],
      vehicleGrossWeight: json['vehicle_gross_weight'],
      vehicleMakeModel: json['vehicle_make_model'],
      insurancePolicyNumber: json['insurance_policy_number'],
      insuranceExpiryDate: json['insurance_expiry_date'],
      rcPuccExpiryDate: json['rc_pucc_expiry_date'],
      rcExpiryDate: json['rc_expiry_date'],
      isValidVehicleType: json['is_valid_vehicle_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'rc_registration_date': rcRegistrationDate,
      'vehicle_gross_weight': vehicleGrossWeight,
      'vehicle_make_model': vehicleMakeModel,
      'insurance_policy_number': insurancePolicyNumber,
      'insurance_expiry_date': insuranceExpiryDate,
      'rc_pucc_expiry_date': rcPuccExpiryDate,
      'rc_expiry_date': rcExpiryDate,
      'is_valid_vehicle_type': isValidVehicleType,
    };
  }

  @override
  String toString() {
    return 'VehicleVerificationData{userName: $userName, rcRegistrationDate: $rcRegistrationDate, vehicleGrossWeight: $vehicleGrossWeight, vehicleMakeModel: $vehicleMakeModel, insurancePolicyNumber: $insurancePolicyNumber, insuranceExpiryDate: $insuranceExpiryDate, rcPuccExpiryDate: $rcPuccExpiryDate, rcExpiryDate: $rcExpiryDate, isValidVehicleType: $isValidVehicleType}';
  }
} 