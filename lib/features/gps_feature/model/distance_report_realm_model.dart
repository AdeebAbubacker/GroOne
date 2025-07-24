import 'package:realm/realm.dart';

part 'distance_report_realm_model.realm.dart';

@RealmModel()
class _DistanceReportRealmModel {
  @PrimaryKey()
  late ObjectId id;

  late String deviceId;
  late int dateTime; // in milliseconds
  late double distance;
  late String deviceName;
}
