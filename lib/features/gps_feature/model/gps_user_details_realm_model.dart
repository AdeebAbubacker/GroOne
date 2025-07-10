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
    id: userId,
    name: name,
    email: email,
    disabled: disabled,
    attributes:
        attributesEmail != null
            ? GpsUserAttributes(email: attributesEmail)
            : null,
  );

  static GpsUserDetailsRealmModel fromDomain(GpsUserDetailsModel data) {
    final obj = GpsUserDetailsRealmModel(
      ObjectId(),
      userId: data.id,
      name: data.name ?? '',
      email: data.email ?? '',
      disabled: data.disabled,
      attributesEmail: data.attributes?.email,
      DateTime.now(),
    );
    return obj;
  }
}
