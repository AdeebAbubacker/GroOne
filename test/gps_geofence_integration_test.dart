import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_geofence_realm_model.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_geofence_model.dart';

void main() {
  group('GPS Geofence Integration Tests', () {
    test('GpsGeofenceRealmModel should convert to and from domain model', () {
      // Create a test geofence
      final testGeofence = GpsGeofenceModel(
        id: '123',
        name: 'Test Geofence',
        area: 'Test Area',
        shapeType: 'circle',
        coveredArea: 'Covered Area',
        center: const LatLng(28.6139, 77.2090),
        radius: 500.0,
        polygonPoints: [
          const LatLng(28.6139, 77.2090),
          const LatLng(28.6149, 77.2100),
        ],
      );

      // Convert to Realm model
      final realmModel = GpsGeofenceRealmModelMapper.fromDomain(testGeofence);

      // Verify Realm model properties
      expect(realmModel.geofenceId, equals('123'));
      expect(realmModel.name, equals('Test Geofence'));
      expect(realmModel.area, equals('Test Area'));
      expect(realmModel.shapeType, equals('circle'));
      expect(realmModel.coveredArea, equals('Covered Area'));
      expect(realmModel.centerLatitude, equals(28.6139));
      expect(realmModel.centerLongitude, equals(77.2090));
      expect(realmModel.radius, equals(500.0));
      // Check polygon points with approximate equality due to floating point precision
      expect(realmModel.polygonPoints.length, equals(2));
      expect(realmModel.polygonPoints[0], contains('28.6139'));
      expect(realmModel.polygonPoints[0], contains('77.209'));
      expect(realmModel.polygonPoints[1], contains('28.6149'));
      expect(realmModel.polygonPoints[1], contains('77.21'));

      // Convert back to domain model
      final convertedGeofence = realmModel.toDomain();

      // Verify domain model properties
      expect(convertedGeofence.id, equals('123'));
      expect(convertedGeofence.name, equals('Test Geofence'));
      expect(convertedGeofence.area, equals('Test Area'));
      expect(convertedGeofence.shapeType, equals('circle'));
      expect(convertedGeofence.coveredArea, equals('Covered Area'));
      expect(convertedGeofence.center?.latitude, equals(28.6139));
      expect(convertedGeofence.center?.longitude, equals(77.2090));
      expect(convertedGeofence.radius, equals(500.0));
      expect(convertedGeofence.polygonPoints?.length, equals(2));
      expect(convertedGeofence.polygonPoints?[0].latitude, equals(28.6139));
      expect(convertedGeofence.polygonPoints?[0].longitude, equals(77.2090));
    });

    test('GpsGeofenceModel.fromJson should parse JSON correctly', () {
      final jsonData = {
        'id': '456',
        'name': 'JSON Test Geofence',
        'area': 'JSON Test Area',
        'attributes': {
          'type': 'circle',
          'covered_area': 'JSON Covered Area',
          'radius': 750.0,
          'geojson': {
            'features': [
              {
                'geometry': {
                  'coordinates': [77.2090, 28.6139],
                },
              },
            ],
          },
        },
      };

      final geofence = GpsGeofenceModel.fromJson(jsonData);

      expect(geofence.id, equals('456'));
      expect(geofence.name, equals('JSON Test Geofence'));
      expect(geofence.area, equals('JSON Test Area'));
      expect(geofence.shapeType, equals('circle'));
      expect(geofence.coveredArea, equals('JSON Covered Area'));
      expect(geofence.radius, equals(750.0));
      expect(geofence.center?.latitude, equals(28.6139));
      expect(geofence.center?.longitude, equals(77.2090));
    });
  });
}
