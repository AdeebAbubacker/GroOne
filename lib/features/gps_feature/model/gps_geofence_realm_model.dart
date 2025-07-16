import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realm/realm.dart';

import '../models/gps_geofence_model.dart';

part 'gps_geofence_realm_model.realm.dart';

@RealmModel()
class _GpsGeofenceRealmModel {
  @PrimaryKey()
  late ObjectId id;

  String? geofenceId;
  String? name;
  String? area;
  String? shapeType;
  String? coveredArea;
  double? centerLatitude;
  double? centerLongitude;
  double? radius;
  List<String> polygonPoints = [];
  late DateTime createdAt;
}

extension GpsGeofenceRealmModelMapper on GpsGeofenceRealmModel {
  GpsGeofenceModel toDomain() => GpsGeofenceModel(
    id: geofenceId ?? '',
    name: name ?? '',
    area: area ?? '',
    shapeType: shapeType ?? 'circle',
    coveredArea: coveredArea,
    center:
        (centerLatitude != null && centerLongitude != null)
            ? LatLng(centerLatitude!, centerLongitude!)
            : null,
    radius: radius,
    polygonPoints:
        polygonPoints.isNotEmpty
            ? polygonPoints.map((point) {
              final coords = point.split(',');
              if (coords.length == 2) {
                final lat = double.tryParse(coords[0]);
                final lng = double.tryParse(coords[1]);
                if (lat != null && lng != null) {
                  return LatLng(lat, lng);
                }
              }
              return const LatLng(0, 0);
            }).toList()
            : null,
  );

  static GpsGeofenceRealmModel fromDomain(GpsGeofenceModel geofence) {
    final obj = GpsGeofenceRealmModel(
      ObjectId(),
      geofenceId: geofence.id,
      name: geofence.name,
      area: geofence.area,
      shapeType: geofence.shapeType,
      coveredArea: geofence.coveredArea,
      centerLatitude: geofence.center?.latitude,
      centerLongitude: geofence.center?.longitude,
      radius: geofence.radius,
      polygonPoints:
          geofence.polygonPoints
              ?.map((point) => '${point.latitude},${point.longitude}')
              .toList() ??
          [],
      DateTime.now(),
    );
    return obj;
  }
}
