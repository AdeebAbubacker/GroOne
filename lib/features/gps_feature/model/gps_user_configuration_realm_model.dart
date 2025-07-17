import 'package:realm/realm.dart';

import 'gps_user_configuration_model.dart';

part 'gps_user_configuration_realm_model.realm.dart';

@RealmModel()
class _GpsUserConfigurationRealmModel {
  @PrimaryKey()
  late ObjectId id;

  int? userId;
  String? name;
  String? defaultMap;
  String? alternateEmail;
  int? companyId;
  int? deviceLimitTotal;
  int? deviceLimitUsed;
  int? userLimitTotal;
  int? userLimitUsed;
  String? webMenuDashboardUrl;
  String? webMenuGeofenceUrl;
  String? webMenuReportsUrl;
  late DateTime createdAt;
}

extension GpsUserConfigurationRealmModelMapper
    on GpsUserConfigurationRealmModel {
  GpsUserConfigurationData toDomain() => GpsUserConfigurationData(
    id: userId,
    name: name,
    defaultMap: defaultMap,
    alternateEmail: alternateEmail,
    companyId: companyId,
    deviceLimitTotal: deviceLimitTotal,
    deviceLimitUsed: deviceLimitUsed,
    userLimitTotal: userLimitTotal,
    userLimitUsed: userLimitUsed,
    webMenu: GpsWebMenu(
      dashboard:
          webMenuDashboardUrl != null
              ? GpsWebMenuItem(url: webMenuDashboardUrl)
              : null,
      geofence:
          webMenuGeofenceUrl != null
              ? GpsWebMenuItem(url: webMenuGeofenceUrl)
              : null,
      reports:
          webMenuReportsUrl != null
              ? GpsWebMenuItem(url: webMenuReportsUrl)
              : null,
    ),
  );

  static GpsUserConfigurationRealmModel fromDomain(
    GpsUserConfigurationData data,
  ) {
    final obj = GpsUserConfigurationRealmModel(
      ObjectId(),
      userId: data.id,
      name: data.name,
      defaultMap: data.defaultMap,
      alternateEmail: data.alternateEmail,
      companyId: data.companyId,
      deviceLimitTotal: data.deviceLimitTotal,
      deviceLimitUsed: data.deviceLimitUsed,
      userLimitTotal: data.userLimitTotal,
      userLimitUsed: data.userLimitUsed,
      webMenuDashboardUrl: data.webMenu?.dashboard?.url,
      webMenuGeofenceUrl: data.webMenu?.geofence?.url,
      webMenuReportsUrl: data.webMenu?.reports?.url,
      DateTime.now(),
    );
    return obj;
  }
}
