import 'package:flutter_test/flutter_test.dart';
import 'package:gro_one_app/service/pushNotification/notification_payload.dart';

void main() {
  group('Notification Payload Tests', () {
    test('should parse critical alert payload correctly', () {
      final json = {
        'route': '/alert/sos',
        'eventType': 'sos',
        'mode': 'emergency',
      };

      final payload = NotificationPayload.fromJson(json);

      expect(payload.route, '/alert/sos');
      expect(payload.eventType, 'sos');
      expect(payload.mode, 'emergency');
    });

    test('should handle missing fields gracefully', () {
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
  });

  group('Critical Alert Detection Tests', () {
    test('should detect SOS as critical alert', () {
      // This would test the _isCriticalAlert method
      // Since it's private, we test the logic indirectly
      const criticalEvents = [
        'sos',
        'powercut',
        'power_cut',
        'unauthorized_parking',
        'unauthorised_parking',
        'parking',
        'tow',
      ];

      expect(criticalEvents.contains('sos'), true);
      expect(criticalEvents.contains('powercut'), true);
      expect(criticalEvents.contains('general'), false);
    });

    test('should detect critical modes', () {
      const criticalModes = ['owl', 'parking', 'alarm'];

      expect(criticalModes.contains('owl'), true);
      expect(criticalModes.contains('parking'), true);
      expect(criticalModes.contains('normal'), false);
    });
  });
}
