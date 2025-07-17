import 'package:realm/realm.dart';

import 'gps_login_model.dart';

part 'gps_login_realm_model.realm.dart';

@RealmModel()
class _GpsLoginResponseRealmModel {
  @PrimaryKey()
  late ObjectId id;

  late String token;
  late String refreshToken;
  late DateTime createdAt;
}

extension GpsLoginResponseRealmModelMapper on GpsLoginResponseRealmModel {
  GpsLoginResponseModel toDomain() =>
      GpsLoginResponseModel(token: token, refreshToken: refreshToken);

  static GpsLoginResponseRealmModel fromDomain(GpsLoginResponseModel data) {
    final obj = GpsLoginResponseRealmModel(
      ObjectId(),
      data.token ?? '',
      data.refreshToken ?? '',
      DateTime.now(),
    );
    return obj;
  }
}
