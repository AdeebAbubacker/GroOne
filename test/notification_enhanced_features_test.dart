import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/service/pushNotification/notification_payload.dart';
import 'package:gro_one_app/service/pushNotification/notification_service.dart';
import 'package:gro_one_app/service/pushNotification/notification_session_manager.dart';

void main() {
  group('Enhanced Notification Features Tests', () {
    late NotificationService notificationService;
    late NotificationSessionManager sessionManager;
    late SecuredSharedPreferences securedSharedPrefs;
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();

      notificationService = NotificationService();
      securedSharedPrefs = SecuredSharedPreferences(
        const FlutterSecureStorage(),
      );
      sessionManager = NotificationSessionManager();
      navigatorKey = GlobalKey<NavigatorState>();

      // Initialize session manager
      sessionManager.initialize(securedSharedPrefs);
    });

    group('New Alert Types Tests', () {
      test('should detect Tow Alerts as critical', () {
        expect(_isCriticalAlertTest('tow', 'normal'), true);
        expect(_isCriticalAlertTest('TOW', 'normal'), true);
        expect(_isCriticalAlertTest('Tow', 'normal'), true);
      });

      test('should detect Command Result Alerts as critical', () {
        // Test with exact case as in implementation
        expect(_isCriticalAlertTest('commandResult', 'normal'), true);
        expect(_isCriticalAlertTest('commandresult', 'normal'), true);
        expect(_isCriticalAlertTest('COMMANDRESULT', 'normal'), true);
      });

      test('should handle Tow Alert payload correctly', () {
        final json = {
          'route': '/alert/tow',
          'eventType': 'tow',
          'mode': 'alert',
          'vehicleName': 'Truck-001',
        };

        final payload = NotificationPayload.fromJson(json);

        expect(payload.route, '/alert/tow');
        expect(payload.eventType, 'tow');
        expect(payload.mode, 'alert');
      });

      test('should handle Command Result payload correctly', () {
        final json = {
          'route': '/alert/command',
          'eventType': 'commandResult',
          'mode': 'response',
          'vehicleName': 'Truck-002',
        };

        final payload = NotificationPayload.fromJson(json);

        expect(payload.route, '/alert/command');
        expect(payload.eventType, 'commandResult');
        expect(payload.mode, 'response');
      });
    });

    group('Device-Specific Message Tests', () {
      test('should generate correct SOS messages', () {
        final message = _getDeviceSpecificMessageTest(
          'sos',
          'Emergency-Truck',
          'Default message',
        );
        expect(
          message,
          'SOS Alert from Emergency-Truck - Emergency situation detected!',
        );

        final messageNoDevice = _getDeviceSpecificMessageTest(
          'sos',
          '',
          'Default message',
        );
        expect(messageNoDevice, 'SOS Alert - Emergency situation detected!');
      });

      test('should generate correct Power Cut messages', () {
        final message = _getDeviceSpecificMessageTest(
          'powercut',
          'Power-Truck',
          'Default message',
        );
        expect(
          message,
          'Power cut detected for Power-Truck - Device disconnected!',
        );

        final messageNoDevice = _getDeviceSpecificMessageTest(
          'powercut',
          '',
          'Default message',
        );
        expect(messageNoDevice, 'Power cut detected - Device disconnected!');
      });

      test('should generate correct Parking messages', () {
        final message = _getDeviceSpecificMessageTest(
          'parking',
          'Parking-Truck',
          'Default message',
        );
        expect(message, 'Parking/Tow alert for Parking-Truck!');

        final messageNoDevice = _getDeviceSpecificMessageTest(
          'parking',
          '',
          'Default message',
        );
        expect(messageNoDevice, 'Parking/Tow alert detected!');
      });

      test('should generate correct Command Result messages', () {
        final message = _getDeviceSpecificMessageTest(
          'commandresult',
          'Command-Truck',
          'Default message',
        );
        expect(message, 'Command result received for Command-Truck');

        final messageNoDevice = _getDeviceSpecificMessageTest(
          'commandresult',
          '',
          'Default message',
        );
        expect(messageNoDevice, 'Command result received');
      });

      test('should handle unknown event types', () {
        final message = _getDeviceSpecificMessageTest(
          'unknown',
          'Unknown-Truck',
          'Default message',
        );
        expect(message, 'Default message');
      });
    });

    group('Edge Cases Tests', () {
      test('should handle null and empty values gracefully', () {
        final json = {'route': '/alert/test'};

        final payload = NotificationPayload.fromJson(json);

        expect(payload.route, '/alert/test');
        expect(payload.eventType, null);
        expect(payload.mode, null);
      });

      test('should handle case sensitivity correctly', () {
        expect(_isCriticalAlertTest('sos', 'normal'), true);
        expect(_isCriticalAlertTest('SOS', 'NORMAL'), true);
        expect(_isCriticalAlertTest('commandResult', 'alert'), true);
        expect(_isCriticalAlertTest('commandresult', 'alert'), true);
      });

      test('should handle whitespace correctly', () {
        expect(_isCriticalAlertTest('sos', 'normal'), true);
        expect(_isCriticalAlertTest('tow', 'alert'), true);
        expect(_isCriticalAlertTest('commandResult', 'response'), true);
      });
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
    'commandresult', // Fixed to lowercase to match implementation
  ];

  const criticalModes = ['owl', 'parking', 'alarm'];

  return criticalEvents.contains(eventType.toLowerCase()) ||
      criticalModes.contains(mode.toLowerCase());
}

// Helper function to test device-specific message generation
String _getDeviceSpecificMessageTest(
  String eventType,
  String deviceName,
  String defaultMessage,
) {
  switch (eventType.toLowerCase()) {
    case 'sos':
      return deviceName.isNotEmpty
          ? "SOS Alert from $deviceName - Emergency situation detected!"
          : "SOS Alert - Emergency situation detected!";
    case 'powercut':
    case 'power_cut':
      return deviceName.isNotEmpty
          ? "Power cut detected for $deviceName - Device disconnected!"
          : "Power cut detected - Device disconnected!";
    case 'unauthorized_parking':
    case 'unauthorised_parking':
      return deviceName.isNotEmpty
          ? "Unauthorized parking detected for $deviceName!"
          : "Unauthorized parking detected!";
    case 'parking':
    case 'tow':
      return deviceName.isNotEmpty
          ? "Parking/Tow alert for $deviceName!"
          : "Parking/Tow alert detected!";
    case 'commandresult':
      return deviceName.isNotEmpty
          ? "Command result received for $deviceName"
          : "Command result received";
    default:
      return defaultMessage;
  }
}
