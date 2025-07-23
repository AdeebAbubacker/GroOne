import 'package:flutter_test/flutter_test.dart';
import 'package:gro_one_app/features/gps_feature/model/trip_path_model.dart';

void main() {
  group('TripPath Model Tests', () {
    test('should parse trip path data correctly', () {
      // Sample data based on the actual API response
      final jsonData = {
        '@timestamp': '2025-07-22 16:52:09',
        'altitude': 20.0,
        'device_id': 46,
        'device_time': '2025-07-22 16:52:09',
        'distance': 0.0,
        'engine2': null,
        'engine_hours': '0 H 0 M',
        'ext_power': 27.1,
        'fix_time': '2025-07-22 16:52:09',
        'ignition': 'ON',
        'latitude': 13.1807683,
        'location': '13.1807683,80.3121466',
        'longitude': 80.3121466,
        'motion': 'MOVING',
        'server_time': '2025-07-22 16:52:10',
        'speed': 5.0,
        'stop_time': null,
        'temperature': null,
        'total_distance': 0.0,
      };

      final tripPath = TripPath.fromJson(jsonData);

      expect(tripPath.timestamp, '2025-07-22 16:52:09');
      expect(tripPath.deviceId, 46);
      expect(tripPath.latitude, 13.1807683);
      expect(tripPath.longitude, 80.3121466);
      expect(tripPath.speed, 5.0);
      expect(tripPath.ignition, 'ON');
      expect(tripPath.motion, 'MOVING');
      expect(tripPath.altitude, 20.0);
      expect(tripPath.extPower, 27.1);
      expect(tripPath.engineHours, '0 H 0 M');
      expect(tripPath.engine2, null);
      expect(tripPath.temperature, null);
      expect(tripPath.stopTime, null);
    });

    test('should handle mixed data types correctly', () {
      // Test with string values that should be parsed as numbers
      final jsonData = {
        '@timestamp': '2025-07-22 16:52:09',
        'device_id': '46', // String instead of int
        'latitude': '13.1807683', // String instead of double
        'longitude': '80.3121466', // String instead of double
        'speed': '5.0', // String instead of double
        'altitude': '20.0', // String instead of double
        'ext_power': '27.1', // String instead of double
        'ignition': 'ON',
        'motion': 'MOVING',
      };

      final tripPath = TripPath.fromJson(jsonData);

      expect(tripPath.deviceId, 46);
      expect(tripPath.latitude, 13.1807683);
      expect(tripPath.longitude, 80.3121466);
      expect(tripPath.speed, 5.0);
      expect(tripPath.altitude, 20.0);
      expect(tripPath.extPower, 27.1);
    });

    test('should handle null values correctly', () {
      final jsonData = {
        '@timestamp': null,
        'device_id': null,
        'latitude': null,
        'longitude': null,
        'speed': null,
        'ignition': null,
        'motion': null,
        'altitude': null,
        'ext_power': null,
        'engine_hours': null,
        'engine2': null,
        'temperature': null,
        'stop_time': null,
      };

      final tripPath = TripPath.fromJson(jsonData);

      expect(tripPath.timestamp, null);
      expect(tripPath.deviceId, null);
      expect(tripPath.latitude, null);
      expect(tripPath.longitude, null);
      expect(tripPath.speed, null);
      expect(tripPath.ignition, null);
      expect(tripPath.motion, null);
      expect(tripPath.altitude, null);
      expect(tripPath.extPower, null);
      expect(tripPath.engineHours, null);
      expect(tripPath.engine2, null);
      expect(tripPath.temperature, null);
      expect(tripPath.stopTime, null);
    });

    test('should convert back to JSON correctly', () {
      final originalData = {
        '@timestamp': '2025-07-22 16:52:09',
        'device_id': 46,
        'latitude': 13.1807683,
        'longitude': 80.3121466,
        'speed': 5.0,
        'ignition': 'ON',
        'motion': 'MOVING',
        'altitude': 20.0,
        'ext_power': 27.1,
        'engine_hours': '0 H 0 M',
        'engine2': null,
        'temperature': null,
        'stop_time': null,
      };

      final tripPath = TripPath.fromJson(originalData);
      final jsonData = tripPath.toJson();

      expect(jsonData['@timestamp'], '2025-07-22 16:52:09');
      expect(jsonData['device_id'], 46);
      expect(jsonData['latitude'], 13.1807683);
      expect(jsonData['longitude'], 80.3121466);
      expect(jsonData['speed'], 5.0);
      expect(jsonData['ignition'], 'ON');
      expect(jsonData['motion'], 'MOVING');
      expect(jsonData['altitude'], 20.0);
      expect(jsonData['ext_power'], 27.1);
      expect(jsonData['engine_hours'], '0 H 0 M');
      expect(jsonData['engine2'], null);
      expect(jsonData['temperature'], null);
      expect(jsonData['stop_time'], null);
    });
  });
}
