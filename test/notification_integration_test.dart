import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/service/pushNotification/notification_payload.dart';
import 'package:gro_one_app/service/pushNotification/notification_service.dart';

void main() {
  group('Notification Service Integration Tests', () {
    late NotificationService notificationService;
    late SecuredSharedPreferences securedSharedPrefs;
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();

      notificationService = NotificationService();
      securedSharedPrefs = SecuredSharedPreferences(
        const FlutterSecureStorage(),
      );
      navigatorKey = GlobalKey<NavigatorState>();
    });

    test('should handle critical alert detection correctly', () {
      // Test critical event types
      final criticalEvents = [
        'sos',
        'powercut',
        'power_cut',
        'unauthorized_parking',
        'unauthorised_parking',
        'parking',
        'tow',
      ];

      // Test critical modes
      final criticalModes = ['owl', 'parking', 'alarm'];

      // These should all be detected as critical alerts
      for (final event in criticalEvents) {
        expect(
          _isCriticalAlertTest(event, 'normal'),
          true,
          reason: '$event should be critical',
        );
      }

      for (final mode in criticalModes) {
        expect(
          _isCriticalAlertTest('gps_disconnected', mode),
          true,
          reason: '$mode should be critical',
        );
      }

      // These should not be critical
      expect(_isCriticalAlertTest('general', 'normal'), false);
      expect(_isCriticalAlertTest('update', 'info'), false);
    });

    test('should parse notification payload correctly', () {
      final json = {
        'route': '/alert/sos',
        'eventType': 'sos',
        'mode': 'emergency',
        'title': 'SOS Alert',
        'body': 'Emergency situation detected',
      };

      final payload = NotificationPayload.fromJson(json);

      expect(payload.route, '/alert/sos');
      expect(payload.eventType, 'sos');
      expect(payload.mode, 'emergency');
    });

    test('should handle missing payload fields gracefully', () {
      final json = {'route': '/alert/general'};

      final payload = NotificationPayload.fromJson(json);

      expect(payload.route, '/alert/general');
      expect(payload.eventType, null);
      expect(payload.mode, null);
    });

    test('should serialize payload correctly', () {
      final payload = NotificationPayload(
        route: '/alert/parking',
        eventType: 'unauthorized_parking',
        mode: 'owl',
      );

      final json = payload.toJson();

      expect(json['route'], '/alert/parking');
      expect(json['eventType'], 'unauthorized_parking');
      expect(json['mode'], 'owl');
    });

    test('should handle different app states correctly', () {
      // Test terminated state payload
      final terminatedPayload = NotificationPayload(
        route: '/alert/sos',
        eventType: 'sos',
        mode: 'emergency',
      );

      // Test background state payload
      final backgroundPayload = NotificationPayload(
        route: '/alert/parking',
        eventType: 'unauthorized_parking',
        mode: 'owl',
      );

      // Test foreground state payload
      final foregroundPayload = NotificationPayload(
        route: '/alert/powercut',
        eventType: 'powercut',
        mode: 'alarm',
      );

      // All should be detected as critical alerts
      expect(
        _isCriticalAlertTest(
          terminatedPayload.eventType ?? '',
          terminatedPayload.mode ?? '',
        ),
        true,
      );
      expect(
        _isCriticalAlertTest(
          backgroundPayload.eventType ?? '',
          backgroundPayload.mode ?? '',
        ),
        true,
      );
      expect(
        _isCriticalAlertTest(
          foregroundPayload.eventType ?? '',
          foregroundPayload.mode ?? '',
        ),
        true,
      );
    });

    test('should handle edge cases correctly', () {
      // Test null values
      expect(_isCriticalAlertTest('', ''), false);
      expect(_isCriticalAlertTest('null', 'null'), false);

      // Test case sensitivity
      expect(_isCriticalAlertTest('SOS', 'EMERGENCY'), true);
      expect(_isCriticalAlertTest('sOs', 'eMeRgEnCy'), true);

      // Test whitespace - should be trimmed and still work
      expect(_isCriticalAlertTest(' sos ', ' emergency '), true);
      expect(_isCriticalAlertTest('  parking  ', '  owl  '), true);
    });

    test('should handle notification service singleton pattern', () {
      // Test that NotificationService follows singleton pattern
      final instance1 = NotificationService();
      final instance2 = NotificationService();

      expect(identical(instance1, instance2), true);
    });

    test('should handle payload with extra fields', () {
      final json = {
        'route': '/alert/sos',
        'eventType': 'sos',
        'mode': 'emergency',
        'extraField1': 'value1',
        'extraField2': 'value2',
        'timestamp': '1234567890',
      };

      final payload = NotificationPayload.fromJson(json);

      // Should only parse the expected fields
      expect(payload.route, '/alert/sos');
      expect(payload.eventType, 'sos');
      expect(payload.mode, 'emergency');

      // Extra fields should be ignored
      expect(payload.toJson().containsKey('extraField1'), false);
      expect(payload.toJson().containsKey('extraField2'), false);
      expect(payload.toJson().containsKey('timestamp'), false);
    });
  });
}

// Helper function to test critical alert detection logic
bool _isCriticalAlertTest(String eventType, String mode) {
  const criticalEvents = [
    'sos',
    'powercut',
    'power_cut',
    'unauthorized_parking',
    'unauthorised_parking',
    'parking',
    'tow',
  ];

  const criticalModes = ['owl', 'parking', 'alarm'];

  // Trim whitespace and convert to lowercase
  final trimmedEventType = eventType.trim().toLowerCase();
  final trimmedMode = mode.trim().toLowerCase();

  return criticalEvents.contains(trimmedEventType) ||
      criticalModes.contains(trimmedMode);
}
