import 'package:realm/realm.dart';

part 'gps_vehicle_extra_info_realm_model.realm.dart';


@RealmModel()
class _GpsVehicleExtraInfoRealm {
  @PrimaryKey()
  late String deviceId;

  late String vehicleRegistrationNumber;
  String? dateAdded;
  String? vehicleRegCertificateUrl;
  String? vehicleBrand;
  String? vehicleModel;
  String? insuranceExpiryDate;
  String? pollutionExpiryDate;
  String? subscriptionExpiryDate;
  String? insuranceCertificateUrl;
  String? pollutionCertificateUrl;
  String? deviceRCUrl;
  String? fitnessExpiryDate;
  String? fitnessCertificateUrl;
  String? nationalPermitExpiryDate;
  String? nationalPermitCertificateUrl;
  String? yearExpiryDate;
  String? yearPermitCertificateUrl;
  String? taxExpiryDate;
  String? taxCertificateUrl;
  String? chasisNumber;
  String? plateNumber;
  String? nextServiceDate;
  String? id;
}
