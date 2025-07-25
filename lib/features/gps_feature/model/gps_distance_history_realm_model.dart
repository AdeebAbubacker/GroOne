import 'package:realm/realm.dart';

part 'gps_distance_history_realm_model.realm.dart';

@RealmModel()
class _GpsDistanceHistoryRealmModel {
  @PrimaryKey()
  late ObjectId id;

  late int deviceId;
  late String vehicleNumber;
  late double distance; // in km
  late DateTime date;
}
