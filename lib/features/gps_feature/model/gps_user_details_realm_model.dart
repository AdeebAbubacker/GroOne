import 'package:realm/realm.dart';

import 'gps_user_details_model.dart';

part 'gps_user_details_realm_model.realm.dart';

@RealmModel()
class _GpsUserDetailsRealmModel {
  @PrimaryKey()
  late ObjectId id;

  int? userId;
  String? name;
  String? email;
  int? disabled;
  String? attributesEmail;
  late DateTime createdAt;
}

extension GpsUserDetailsRealmModelMapper on GpsUserDetailsRealmModel {
  GpsUserDetailsModel toDomain() => GpsUserDetailsModel(
    data: [
      GpsUserData(id: userId, name: name, email: email, disabled: disabled),
    ],
    success: true,
    total: 1,
  );

  static GpsUserDetailsRealmModel fromDomain(GpsUserDetailsModel data) {
    final firstUser = data.firstUser;
    final obj = GpsUserDetailsRealmModel(
      ObjectId(),
      userId: firstUser?.id,
      name: firstUser?.name ?? '',
      email: firstUser?.email ?? '',
      disabled: firstUser?.disabled,
      attributesEmail: null, // No longer used in new structure
      DateTime.now(),
    );
    return obj;
  }
}
