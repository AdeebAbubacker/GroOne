import 'gps_vehicle_extra_info_model.dart';
import 'gps_vehicle_extra_info_realm_model.dart';

class GpsVehicleExtraInfoMapper {
  /// Convert domain model to Realm model
  static GpsVehicleExtraInfoRealm toRealm(GpsVehicleExtraInfo domain) {
    return GpsVehicleExtraInfoRealm(
      domain.deviceId?.toString() ?? '',
      domain.vehicleRegistrationNumber?.toString() ?? '',
      dateAdded: domain.dateAdded?.toString(),
      vehicleRegCertificateUrl: domain.vehicleRegCertificateUrl?.toString(),
      vehicleBrand: domain.vehicleBrand?.toString(),
      vehicleModel: domain.vehicleModel?.toString(),
      insuranceExpiryDate: domain.insuranceExpiryDate?.toString(),
      pollutionExpiryDate: domain.pollutionExpiryDate?.toString(),
      subscriptionExpiryDate: domain.subscriptionExpiryDate?.toString(),
      insuranceCertificateUrl: domain.insuranceUpload?.toString(),
      pollutionCertificateUrl: domain.pollutionCertificateUpload?.toString(),
      deviceRCUrl: domain.carRcCopy?.toString(),
      fitnessExpiryDate: domain.fitnessExpiryDate?.toString(),
      fitnessCertificateUrl: domain.fitnessCertificateUrl?.toString(),
      nationalPermitExpiryDate: domain.nationalPermitExpiryDate?.toString(),
      nationalPermitCertificateUrl: domain.nationalPermitCertificateUrl?.toString(),
      yearExpiryDate: domain.yearExpiryDate?.toString(),
      yearPermitCertificateUrl: domain.yearPermitCertificateUrl?.toString(),
      taxExpiryDate: domain.taxExpiryDate?.toString(),
      taxCertificateUrl: domain.taxCertificateUrl?.toString(),
      chasisNumber: domain.chasisNumber?.toString(),
      plateNumber: domain.plateNumber?.toString(),
      nextServiceDate: domain.nextServiceDate?.toString(),
      id: domain.id?.toString(),
    );
  }

  /// Convert Realm model to domain model
  static GpsVehicleExtraInfo fromRealm(GpsVehicleExtraInfoRealm realm) {
    return GpsVehicleExtraInfo(
      id: realm.id,
      deviceId: realm.deviceId,
      vehicleRegistrationNumber: realm.vehicleRegistrationNumber,
      dateAdded: realm.dateAdded,
      vehicleRegCertificateUrl: realm.vehicleRegCertificateUrl,
      vehicleBrand: realm.vehicleBrand,
      vehicleModel: realm.vehicleModel,
      insuranceExpiryDate: realm.insuranceExpiryDate,
      pollutionExpiryDate: realm.pollutionExpiryDate,
      subscriptionExpiryDate: realm.subscriptionExpiryDate,
      insuranceUpload: realm.insuranceCertificateUrl,
      pollutionCertificateUpload: realm.pollutionCertificateUrl,
      carRcCopy: realm.deviceRCUrl,
      fitnessExpiryDate: realm.fitnessExpiryDate,
      fitnessCertificateUrl: realm.fitnessCertificateUrl,
      nationalPermitExpiryDate: realm.nationalPermitExpiryDate,
      nationalPermitCertificateUrl: realm.nationalPermitCertificateUrl,
      yearExpiryDate: realm.yearExpiryDate,
      yearPermitCertificateUrl: realm.yearPermitCertificateUrl,
      taxExpiryDate: realm.taxExpiryDate,
      taxCertificateUrl: realm.taxCertificateUrl,
      chasisNumber: realm.chasisNumber,
      plateNumber: realm.plateNumber,
      nextServiceDate: realm.nextServiceDate,
    );
  }

  /// Convert list of domain models to list of Realm models
  static List<GpsVehicleExtraInfoRealm> toRealmList(List<GpsVehicleExtraInfo> domainList) {
    return domainList.map((domain) => toRealm(domain)).toList();
  }

  /// Convert list of Realm models to list of domain models
  static List<GpsVehicleExtraInfo> fromRealmList(List<GpsVehicleExtraInfoRealm> realmList) {
    return realmList.map((realm) => fromRealm(realm)).toList();
  }
} 