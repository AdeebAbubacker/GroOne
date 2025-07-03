class CardFormData {
  String vehicleNumber;
  String vehicleType;
  String vinNumber;
  String mobile;
  String rcNumber;
  List rcDocuments;

  CardFormData({
    this.vehicleNumber = '',
    this.vehicleType = 'Select',
    this.vinNumber = '',
    this.mobile = '',
    this.rcNumber = '',
    List? rcDocuments,
  }) : rcDocuments = rcDocuments ?? [];

  CardFormData copyWith({
    String? vehicleNumber,
    String? vehicleType,
    String? vinNumber,
    String? mobile,
    String? rcNumber,
    List<Map<String, dynamic>>? rcDocuments,
  }) {
    return CardFormData(
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      vinNumber: vinNumber ?? this.vinNumber,
      mobile: mobile ?? this.mobile,
      rcNumber: rcNumber ?? this.rcNumber,
      rcDocuments: rcDocuments ?? this.rcDocuments,
    );
  }
} 