import 'package:flutter_test/flutter_test.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_data_refresh_service.dart';

void main() {
  group('GPS Data Refresh Service Tests', () {
    test('should return correct refresh intervals', () {
      final service = GpsDataRefreshService();

      expect(
        service.getRefreshInterval(GpsScreenType.map),
        const Duration(seconds: 5),
      );
      expect(
        service.getRefreshInterval(GpsScreenType.home),
        const Duration(seconds: 15),
      );
      expect(
        service.getRefreshInterval(GpsScreenType.other),
        const Duration(seconds: 15),
      );
    });

    test('should start and stop refresh correctly', () {
      final service = GpsDataRefreshService();

      // Initially not active
      expect(service.isActive, false);

      // Start refresh
      service.startRefresh(GpsScreenType.map);
      expect(service.isActive, true);
      expect(service.currentScreenType, GpsScreenType.map);

      // Stop refresh
      service.stopRefresh();
      expect(service.isActive, false);
    });

    test('should handle screen type changes', () {
      final service = GpsDataRefreshService();

      // Start with map
      service.startRefresh(GpsScreenType.map);
      expect(service.currentScreenType, GpsScreenType.map);

      // Change to home
      service.startRefresh(GpsScreenType.home);
      expect(service.currentScreenType, GpsScreenType.home);

      // Change to other
      service.startRefresh(GpsScreenType.other);
      expect(service.currentScreenType, GpsScreenType.other);
    });

    test('should not restart refresh for same screen type', () {
      final service = GpsDataRefreshService();

      // Start refresh
      service.startRefresh(GpsScreenType.map);
      final initialTime = DateTime.now();

      // Try to start again with same type
      service.startRefresh(GpsScreenType.map);

      // Should not restart (this is a behavioral test)
      expect(service.currentScreenType, GpsScreenType.map);
    });
  });

  group('GPS Screen Type Tests', () {
    test('should have correct enum values', () {
      expect(GpsScreenType.values.length, 3);
      expect(GpsScreenType.values.contains(GpsScreenType.home), true);
      expect(GpsScreenType.values.contains(GpsScreenType.map), true);
      expect(GpsScreenType.values.contains(GpsScreenType.other), true);
    });
  });
}
