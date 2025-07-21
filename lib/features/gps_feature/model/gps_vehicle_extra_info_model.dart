class GpsVehicleExtraInfo {
  final dynamic id;
  final dynamic deviceId;
  final dynamic name;
  final dynamic uniqueId;
  final dynamic phone;
  final dynamic dateAdded;
  final dynamic vehicleRegistrationNumber;
  final dynamic vehicleBrand;
  final dynamic vehicleModel;
  final dynamic insuranceExpiryDate;
  final dynamic pollutionExpiryDate;
  final dynamic vehicleRegCertificateUrl;
  final dynamic subscriptionExpiryDate;
  final dynamic insuranceUpload;
  final dynamic pollutionCertificateUpload;
  final dynamic lastServiceDate;
  final dynamic nextServiceDate;
  final dynamic carRcCopy;
  final dynamic vehicleType;
  final dynamic cngFittedBy;
  final dynamic cngLeakExpiry;
  final dynamic cngCertificateUpload;
  final dynamic hbtTestDate;
  final dynamic fitnessExpiryDate;
  final dynamic fitnessCertificateUrl;
  final dynamic nationalPermitExpiryDate;
  final dynamic nationalPermitCertificateUrl;
  final dynamic yearExpiryDate;
  final dynamic yearPermitCertificateUrl;
  final dynamic taxExpiryDate;
  final dynamic taxCertificateUrl;
  final dynamic chasisNumber;
  final dynamic plateNumber;
  final dynamic deviceFitImg1;
  final dynamic deviceFitImg2;

  GpsVehicleExtraInfo({
    this.id,
    this.deviceId,
    this.name,
    this.uniqueId,
    this.phone,
    this.dateAdded,
    this.vehicleRegistrationNumber,
    this.vehicleBrand,
    this.vehicleModel,
    this.insuranceExpiryDate,
    this.pollutionExpiryDate,
    this.vehicleRegCertificateUrl,
    this.subscriptionExpiryDate,
    this.insuranceUpload,
    this.pollutionCertificateUpload,
    this.lastServiceDate,
    this.nextServiceDate,
    this.carRcCopy,
    this.vehicleType,
    this.cngFittedBy,
    this.cngLeakExpiry,
    this.cngCertificateUpload,
    this.hbtTestDate,
    this.fitnessExpiryDate,
    this.fitnessCertificateUrl,
    this.nationalPermitExpiryDate,
    this.nationalPermitCertificateUrl,
    this.yearExpiryDate,
    this.yearPermitCertificateUrl,
    this.taxExpiryDate,
    this.taxCertificateUrl,
    this.chasisNumber,
    this.plateNumber,
    this.deviceFitImg1,
    this.deviceFitImg2,
  });

  factory GpsVehicleExtraInfo.fromJson(Map<String, dynamic> json) {
    return GpsVehicleExtraInfo(
      id: json['id'],
      deviceId: json['device_id'],
      name: json['name'],
      uniqueId: json['uniqueId'],
      phone: json['phone'],
      dateAdded: json['date_added'],
      vehicleRegistrationNumber: json['vehicle_registration_number'],
      vehicleBrand: json['vehicle_brand'],
      vehicleModel: json['vehicle_model'],
      insuranceExpiryDate: json['insurance_expiry_date'],
      pollutionExpiryDate: json['pollution_expiry_date'],
      vehicleRegCertificateUrl: json['registration_certificate_url'],
      subscriptionExpiryDate: json['subscription_expiry_date'],
      insuranceUpload: json['insurance_upload'],
      pollutionCertificateUpload: json['pollution_certificate_upload'],
      lastServiceDate: json['last_service_date'],
      nextServiceDate: json['next_service_date'],
      carRcCopy: json['car_rc_copy'],
      vehicleType: json['vehicle_type'],
      cngFittedBy: json['cng_fitted_by'],
      cngLeakExpiry: json['cng_leak_expiry'],
      cngCertificateUpload: json['cng_certificate_upload'],
      hbtTestDate: json['hbt_test_date'],
      fitnessExpiryDate: json['fitness_expiry_date'],
      fitnessCertificateUrl: json['fitness_upload_url'],
      nationalPermitExpiryDate: json['national_permit_expiry'],
      nationalPermitCertificateUrl: json['national_permit_upload'],
      yearExpiryDate: json['five_year_permit_expiry'],
      yearPermitCertificateUrl: json['five_year_permit_upload'],
      taxExpiryDate: json['token_tax_expiry'],
      taxCertificateUrl: json['token_tax_upload'],
      chasisNumber: json['chasis_number'],
      plateNumber: json['plate_number'],
      deviceFitImg1: json['device_fit_img1'],
      deviceFitImg2: json['device_fit_img2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'name': name,
      'uniqueId': uniqueId,
      'phone': phone,
      'date_added': dateAdded,
      'vehicle_registration_number': vehicleRegistrationNumber,
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'insurance_expiry_date': insuranceExpiryDate,
      'pollution_expiry_date': pollutionExpiryDate,
      'registration_certificate_url': vehicleRegCertificateUrl,
      'subscription_expiry_date': subscriptionExpiryDate,
      'insurance_upload': insuranceUpload,
      'pollution_certificate_upload': pollutionCertificateUpload,
      'last_service_date': lastServiceDate,
      'next_service_date': nextServiceDate,
      'car_rc_copy': carRcCopy,
      'vehicle_type': vehicleType,
      'cng_fitted_by': cngFittedBy,
      'cng_leak_expiry': cngLeakExpiry,
      'cng_certificate_upload': cngCertificateUpload,
      'hbt_test_date': hbtTestDate,
      'fitness_expiry_date': fitnessExpiryDate,
      'fitness_upload_url': fitnessCertificateUrl,
      'national_permit_expiry': nationalPermitExpiryDate,
      'national_permit_upload': nationalPermitCertificateUrl,
      'five_year_permit_expiry': yearExpiryDate,
      'five_year_permit_upload': yearPermitCertificateUrl,
      'token_tax_expiry': taxExpiryDate,
      'token_tax_upload': taxCertificateUrl,
      'chasis_number': chasisNumber,
      'plate_number': plateNumber,
      'device_fit_img1': deviceFitImg1,
      'device_fit_img2': deviceFitImg2,
    };
  }

  GpsVehicleExtraInfo copyWith({
    String? id,
    String? deviceId,
    String? name,
    String? uniqueId,
    String? phone,
    String? dateAdded,
    String? vehicleRegistrationNumber,
    String? vehicleBrand,
    String? vehicleModel,
    String? insuranceExpiryDate,
    String? pollutionExpiryDate,
    String? vehicleRegCertificateUrl,
    String? subscriptionExpiryDate,
    String? insuranceUpload,
    String? pollutionCertificateUpload,
    String? lastServiceDate,
    String? nextServiceDate,
    String? carRcCopy,
    String? vehicleType,
    String? cngFittedBy,
    String? cngLeakExpiry,
    String? cngCertificateUpload,
    String? hbtTestDate,
    String? fitnessExpiryDate,
    String? fitnessCertificateUrl,
    String? nationalPermitExpiryDate,
    String? nationalPermitCertificateUrl,
    String? yearExpiryDate,
    String? yearPermitCertificateUrl,
    String? taxExpiryDate,
    String? taxCertificateUrl,
    String? chasisNumber,
    String? plateNumber,
    String? deviceFitImg1,
    String? deviceFitImg2,
  }) {
    return GpsVehicleExtraInfo(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      uniqueId: uniqueId ?? this.uniqueId,
      phone: phone ?? this.phone,
      dateAdded: dateAdded ?? this.dateAdded,
      vehicleRegistrationNumber: vehicleRegistrationNumber ?? this.vehicleRegistrationNumber,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      insuranceExpiryDate: insuranceExpiryDate ?? this.insuranceExpiryDate,
      pollutionExpiryDate: pollutionExpiryDate ?? this.pollutionExpiryDate,
      vehicleRegCertificateUrl: vehicleRegCertificateUrl ?? this.vehicleRegCertificateUrl,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
      insuranceUpload: insuranceUpload ?? this.insuranceUpload,
      pollutionCertificateUpload: pollutionCertificateUpload ?? this.pollutionCertificateUpload,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      carRcCopy: carRcCopy ?? this.carRcCopy,
      vehicleType: vehicleType ?? this.vehicleType,
      cngFittedBy: cngFittedBy ?? this.cngFittedBy,
      cngLeakExpiry: cngLeakExpiry ?? this.cngLeakExpiry,
      cngCertificateUpload: cngCertificateUpload ?? this.cngCertificateUpload,
      hbtTestDate: hbtTestDate ?? this.hbtTestDate,
      fitnessExpiryDate: fitnessExpiryDate ?? this.fitnessExpiryDate,
      fitnessCertificateUrl: fitnessCertificateUrl ?? this.fitnessCertificateUrl,
      nationalPermitExpiryDate: nationalPermitExpiryDate ?? this.nationalPermitExpiryDate,
      nationalPermitCertificateUrl: nationalPermitCertificateUrl ?? this.nationalPermitCertificateUrl,
      yearExpiryDate: yearExpiryDate ?? this.yearExpiryDate,
      yearPermitCertificateUrl: yearPermitCertificateUrl ?? this.yearPermitCertificateUrl,
      taxExpiryDate: taxExpiryDate ?? this.taxExpiryDate,
      taxCertificateUrl: taxCertificateUrl ?? this.taxCertificateUrl,
      chasisNumber: chasisNumber ?? this.chasisNumber,
      plateNumber: plateNumber ?? this.plateNumber,
      deviceFitImg1: deviceFitImg1 ?? this.deviceFitImg1,
      deviceFitImg2: deviceFitImg2 ?? this.deviceFitImg2,
    );
  }
}
