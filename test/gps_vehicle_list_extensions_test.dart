import 'package:flutter_test/flutter_test.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';

void main() {
  group('GpsVehicleListExtensions', () {
    late List<GpsCombinedVehicleData> testVehicles;

    setUp(() {
      testVehicles = [
        GpsCombinedVehicleData(
          deviceId: 1,
          vehicleNumber: "MH12AB1234",
          expired: false,
          isExpiringSoon: false,
        ),
        GpsCombinedVehicleData(
          deviceId: 2,
          vehicleNumber: "DL01CD5678",
          expired: true,
          isExpiringSoon: false,
        ),
        GpsCombinedVehicleData(
          deviceId: 3,
          vehicleNumber: "KA05EF9012",
          expired: null,
          isExpiringSoon: true,
        ),
        GpsCombinedVehicleData(
          deviceId: 4,
          vehicleNumber: "TN07GH3456",
          expired: false,
          isExpiringSoon: true,
        ),
      ];
    });

    test('withExpired should return all vehicles', () {
      final result = testVehicles.withExpired;
      expect(result.length, equals(4));
    });

    test('withoutExpired should return only non-expired vehicles', () {
      final result = testVehicles.withoutExpired;
      expect(result.length, equals(1));
      expect(result.every((v) => v.expired == false), isTrue);
    });

    test('onlyExpired should return only expired vehicles', () {
      final result = testVehicles.onlyExpired;
      expect(result.length, equals(3));
      expect(
        result.every((v) => v.expired == true || v.expired == null),
        isTrue,
      );
    });

    test('expiringSoon should return vehicles expiring soon', () {
      final result = testVehicles.expiringSoon;
      expect(result.length, equals(2));
      expect(result.every((v) => v.isExpiringSoon == true), isTrue);
    });

    test('notExpiringSoon should return vehicles not expiring soon', () {
      final result = testVehicles.notExpiringSoon;
      expect(result.length, equals(2));
      expect(result.every((v) => v.isExpiringSoon != true), isTrue);
    });
  });
}
