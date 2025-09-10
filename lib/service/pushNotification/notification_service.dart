import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/service/pushNotification/notification_helper.dart';
import 'package:gro_one_app/service/pushNotification/notification_payload.dart';
import 'package:gro_one_app/service/pushNotification/notification_session_manager.dart';
import 'package:gro_one_app/service/pushNotification/notification_view.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();
  static String? deviceToken;

  // Dependencies
  late SecuredSharedPreferences _secureSharedPrefs;
  late GlobalKey<NavigatorState> navigatorKey;
  final NotificationView _notificationView = NotificationView();
  final NotificationSessionManager _sessionManager =
      NotificationSessionManager();

  // Flutter Local Notifications (for alert-specific sounds)
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Badge management
  int badgeCount = 0;

  // Alert-specific notification channels for Android
  static final AndroidNotificationChannel _highAlertsChannel =
      AndroidNotificationChannel(
        'high_alerts',
        'High Alert Notifications',
        description:
            'Used for important notifications like SOS, Power Cut, etc.',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('sos_sound'),
      );

  static final AndroidNotificationChannel _parkingAlertsChannel =
      AndroidNotificationChannel(
        'parking_alerts',
        'Parking Alert Notifications',
        description: 'Used for parking and spy mode notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('spymode_sound'),
      );

  static final AndroidNotificationChannel _callAlertsChannel =
      AndroidNotificationChannel(
        'call_alerts',
        'Call Alert Notifications',
        description: 'Used for call and unauthorized parking notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('agora_call'),
      );

  static final AndroidNotificationChannel _powerCutChannel =
      AndroidNotificationChannel(
        'powercut_alerts',
        'Power Cut Notifications',
        description: 'Used for power cut notifications',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('powercut'),
      );

  /// Initialize the notification service with all features
  Future<void> init(
    GlobalKey<NavigatorState> key,
    SecuredSharedPreferences secureSharedPrefs,
  ) async {
    navigatorKey = key;
    _secureSharedPrefs = secureSharedPrefs;

    // Initialize session manager
    _sessionManager.initialize(secureSharedPrefs);

    // Initialize all notification systems
    await _initializeFlutterLocalNotifications();
    await _initializeAwesomeNotifications();
    await _requestPermissions();
    await getFcmToken();

    // Set up message handlers
    _setupMessageHandlers();

    // Check for pending critical alerts after initialization
    _checkForPendingCriticalAlerts();
  }

  /// Check for any pending critical alerts that might have been missed
  void _checkForPendingCriticalAlerts() {
    // This can be used to check for any stored critical alerts
    // that might have been received while the app was terminated
    // and handle them appropriately
    CustomLog.debug(this, "Checking for pending critical alerts");
  }

  /// Initialize Flutter Local Notifications for alert-specific sounds
  Future<void> _initializeFlutterLocalNotifications() async {
    try {
      // Android: Create notification channels for alert-specific sounds
      if (Platform.isAndroid) {
        final androidImplementation =
            _flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();

        await androidImplementation?.createNotificationChannel(
          _highAlertsChannel,
        );
        await androidImplementation?.createNotificationChannel(
          _parkingAlertsChannel,
        );
        await androidImplementation?.createNotificationChannel(
          _callAlertsChannel,
        );
        await androidImplementation?.createNotificationChannel(
          _powerCutChannel,
        );
      }

      // Initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _flutterLocalNotificationsPlugin.initialize(initSettings);
      CustomLog.debug(
        this,
        "Flutter Local Notifications initialized successfully",
      );
    } catch (e) {
      CustomLog.error(
        this,
        "Flutter Local Notifications initialization error",
        e,
      );
    }
  }

  /// Initialize Awesome Notifications for general notifications
  Future<void> _initializeAwesomeNotifications() async {
    try {
      await AwesomeNotifications().initialize(
        'resource://mipmap/ic_launcher',
        [
          NotificationChannel(
            channelGroupKey: 'General',
            channelKey: 'general_channel',
            channelName: 'General notifications',
            channelDescription:
                'All general notification for latest offers & coupon',
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            icon: 'resource://mipmap/ic_launcher',
            playSound: true,
            defaultRingtoneType: DefaultRingtoneType.Notification,
          ),
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupKey: 'General',
            channelGroupName: 'General notifications',
          ),
        ],
        debug: false,
      );

      // Set up awesome notifications listeners
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: _onAwesomeNotificationReceived,
      );

      CustomLog.debug(this, "Awesome Notifications initialized successfully");
    } catch (e) {
      CustomLog.error(this, "Awesome Notifications initialization error", e);
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    try {
      // Firebase messaging permissions
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        sound: true,
        provisional: false,
        criticalAlert: false,
      );

      // iOS specific permissions
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      // Awesome notifications permissions
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        CustomLog.debug(this, 'User declined or has not accepted permission');
      }

      CustomLog.debug(this, "Notification permissions requested successfully");
    } catch (e) {
      CustomLog.error(this, "Notification permission request error", e);
    }
  }

  /// Setup message handlers for different app states
  void _setupMessageHandlers() {
    try {
      // Foreground notifications
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Background/terminated notification tap
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // Terminated state
      _handleTerminatedState();

      // Note: Background handler is set up in main.dart to avoid conflicts
      // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      CustomLog.debug(this, "Message handlers setup successfully");
    } catch (e) {
      CustomLog.error(this, "Message handlers setup error", e);
    }
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      await _incrementBadgeCount();

      final eventType = message.data['eventType'] ?? 'unknown';
      final mode = message.data['mode'] ?? 'normal';

      // Check if this is a critical alert that needs special sound
      if (_isCriticalAlert(eventType, mode)) {
        await _showCriticalAlert(message);
      } else {
        // Use awesome notifications for general notifications
        await _notificationView.display(
          message: message,
          payload: await _notificationPayload(message),
        );
      }
    } catch (e) {
      CustomLog.error(this, "Foreground message handling error", e);
    }
  }

  /// Handle background messages
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    try {
      NotificationPayload payload = NotificationPayload.fromJson(message.data);

      // Check if this is a critical alert that needs special handling
      final eventType = payload.eventType ?? 'unknown';
      final mode = payload.mode ?? 'normal';

      if (_isCriticalAlert(eventType, mode)) {
        // For background state, we can show a local notification with custom sound
        // but we can't show a dialog since the app is not in foreground
        await _showCriticalAlert(message);
      }

      _handleNotificationClick(payload, "Background state");
    } catch (e) {
      CustomLog.error(this, "Background message handling error", e);
    }
  }

  /// Handle terminated state
  Future<void> _handleTerminatedState() async {
    try {
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          NotificationPayload payload = NotificationPayload.fromJson(
            message.data,
          );

          // Check if this is a critical alert that needs dialog
          final eventType = payload.eventType ?? 'unknown';
          final mode = payload.mode ?? 'normal';

          if (_isCriticalAlert(eventType, mode)) {
            // Show critical alert dialog for terminated state
            _showCriticalAlertForTerminatedState(message, payload);
          } else {
            // Handle normal navigation
            _handleNotificationClick(payload, "Terminated state");
          }
        }
      });
    } catch (e) {
      CustomLog.error(this, "Terminated state handling error", e);
    }
  }

  /// Background message handler (static method required by Firebase)
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    try {
      CustomLog.debug(
        NotificationService,
        "Background notification: ${message.toMap()}",
      );

      // Update badge
      if (await AppBadgePlus.isSupported()) {
        await AppBadgePlus.updateBadge(1);
      }

      // Handle payload
      NotificationPayload payload = NotificationPayload.fromJson(message.data);

      // Check if this is a critical alert
      final eventType = payload.eventType ?? 'unknown';
      final mode = payload.mode ?? 'normal';

      // Store critical alert information for when app opens
      if (_isCriticalAlertStatic(eventType, mode)) {
        // Store the critical alert data for when app opens
        // This will be handled in _handleTerminatedState
        CustomLog.debug(
          NotificationService,
          "Critical alert received in background: $eventType, $mode",
        );
      }

      if (payload.route != null) {
        // Store route for when app opens
        // You can implement route storage logic here
      }
    } catch (e) {
      CustomLog.error(NotificationService, "Background handler error", e);
    }
  }

  /// Awesome notifications action received handler
  @pragma("vm:entry-point")
  static Future<void> _onAwesomeNotificationReceived(
    ReceivedAction receivedAction,
  ) async {
    print("receivedAction is ${receivedAction.body}");
    print("receivedAction payload ${receivedAction.payload}");
    try {
      NotificationPayload payload = NotificationPayload.fromJson(
        receivedAction.payload ?? {},
      );
      CustomLog.debug(
        NotificationService,
        "Awesome notification clicked: $payload",
      );

      if (payload.route != null) {
        //// TODO: implement redirection here

        // Handle navigation
        // navigatorKey.currentState?.pushNamed(payload.route!);
      }
    } catch (e) {
      CustomLog.error(
        NotificationService,
        "Awesome notification action error",
        e,
      );
    }
  }

  /// Show critical alert with custom sound and popup
  Future<void> _showCriticalAlert(RemoteMessage message) async {
    final data = message.data;
    final eventType = data['eventType'] ?? 'unknown';
    final mode = data['mode'] ?? 'normal';
    final deviceName =
        data['vehicleName'] ?? data['deviceName'] ?? 'Unknown Device';

    final notification = message.notification;
    final title = '🚨 Alert ${notification?.title ?? ''}';
    final body = notification?.body ?? 'You have a new notification';

    // Save device name and notification type based on event type
    await _saveDeviceNameAndType(eventType, deviceName);

    // Event-based configuration
    final eventConfig = _getEventConfig(eventType, mode);
    final channelId = eventConfig['channelId'] ?? _highAlertsChannel.id;
    final channelName = eventConfig['channelName'] ?? _highAlertsChannel.name;
    final androidSound = eventConfig['sound'] ?? _highAlertsChannel.sound;
    final iosSound = eventConfig['iosSound'];

    // Show local notification with custom sound
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: eventConfig['description'],
          importance: Importance.max,
          priority: Priority.high,
          sound: androidSound,
        ),
        iOS: DarwinNotificationDetails(sound: iosSound),
      ),
    );

    // Show popup dialog if app is in foreground
    if (navigatorKey.currentContext != null) {
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 280,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber, color: Colors.red, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      body,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 45,
                        vertical: 6,
                      ),
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'DISMISS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  /// Show critical alert dialog for terminated state
  Future<void> _showCriticalAlertForTerminatedState(
    RemoteMessage message,
    NotificationPayload payload,
  ) async {
    try {
      // Wait for app to be fully initialized
      await Future.delayed(const Duration(milliseconds: 500));

      final notification = message.notification;
      final eventType = payload.eventType ?? 'unknown';
      final deviceName = await _getDeviceNameForEvent(eventType);

      final title = '🚨 Alert ${notification?.title ?? ''}';
      final body = _getDeviceSpecificMessage(
        eventType,
        deviceName,
        notification?.body ?? 'You have a new notification',
      );

      // Try to show popup dialog for terminated state with retry mechanism
      bool dialogShown = false;
      int retryCount = 0;
      const maxRetries = 3;

      while (!dialogShown && retryCount < maxRetries) {
        if (navigatorKey.currentContext != null) {
          dialogShown = true;
          showDialog(
            context: navigatorKey.currentContext!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber, color: Colors.red, size: 80),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          body,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'DISMISS',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Handle navigation after dialog dismissal
                              if (payload.route != null) {
                                _handleNotificationClick(
                                  payload,
                                  "Terminated state - after dialog",
                                );
                              }
                            },
                            child: const Text(
                              'VIEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          retryCount++;
          if (retryCount < maxRetries) {
            CustomLog.debug(
              this,
              "Context not available, retrying... (attempt $retryCount)",
            );
            await Future.delayed(Duration(milliseconds: 500 * retryCount));
          }
        }
      }

      // If dialog couldn't be shown after retries, handle navigation directly
      if (!dialogShown) {
        CustomLog.debug(
          this,
          "Could not show dialog after $maxRetries attempts, handling navigation directly",
        );
        _handleNotificationClick(
          payload,
          "Terminated state - no context after retries",
        );
      }
    } catch (e) {
      CustomLog.error(this, "Terminated state critical alert error", e);
      // Fallback to normal navigation
      _handleNotificationClick(payload, "Terminated state - fallback");
    }
  }

  /// Check if notification is a critical alert
  bool _isCriticalAlert(String eventType, String mode) {
    const criticalEvents = [
      'sos',
      'powercut',
      'power_cut',
      'unauthorized_parking',
      'unauthorised_parking',
      'parking',
      'tow',
      'commandresult', // Fixed to lowercase to match toLowerCase() behavior
    ];

    const criticalModes = ['owl', 'parking', 'alarm'];

    return criticalEvents.contains(eventType.toLowerCase()) ||
        criticalModes.contains(mode.toLowerCase());
  }

  /// Static version of critical alert check for background handler
  static bool _isCriticalAlertStatic(String eventType, String mode) {
    const criticalEvents = [
      'sos',
      'powercut',
      'power_cut',
      'unauthorized_parking',
      'unauthorised_parking',
      'parking',
      'tow',
      'commandresult', // Fixed to lowercase to match toLowerCase() behavior
    ];

    const criticalModes = ['owl', 'parking', 'alarm'];

    return criticalEvents.contains(eventType.toLowerCase()) ||
        criticalModes.contains(mode.toLowerCase());
  }

  /// Get event-specific configuration
  Map<String, dynamic> _getEventConfig(String eventType, String mode) {
    switch (eventType.toLowerCase()) {
      case 'sos':
        return {
          'channelId': _highAlertsChannel.id,
          'channelName': _highAlertsChannel.name,
          'description': 'SOS emergency alerts',
          'sound': RawResourceAndroidNotificationSound('sos_sound'),
          'iosSound': 'sos_sound.aiff',
        };

      case 'powercut':
      case 'power_cut':
        return {
          'channelId': _powerCutChannel.id,
          'channelName': _powerCutChannel.name,
          'description': 'Power cut alerts',
          'sound': RawResourceAndroidNotificationSound('powercut'),
          'iosSound': 'powercut.aiff',
        };

      case 'unauthorized_parking':
      case 'unauthorised_parking':
        return {
          'channelId': _callAlertsChannel.id,
          'channelName': _callAlertsChannel.name,
          'description': 'Unauthorized parking calls',
          'sound': RawResourceAndroidNotificationSound('agora_call'),
          'iosSound': 'agora_call.aiff',
        };

      case 'parking':
      case 'tow':
        return {
          'channelId': _parkingAlertsChannel.id,
          'channelName': _parkingAlertsChannel.name,
          'description': 'Parking and tow alerts',
          'sound': RawResourceAndroidNotificationSound('spymode_sound'),
          'iosSound': 'spymode_sound.aiff',
        };

      case 'commandresult':
        return {
          'channelId': _highAlertsChannel.id,
          'channelName': _highAlertsChannel.name,
          'description': 'Command result alerts',
          'sound': RawResourceAndroidNotificationSound('sos_sound'),
          'iosSound': 'sos_sound.aiff',
        };

      case 'gps_disconnected':
      case 'engine_on':
      default:
        // Check mode for special cases
        if (mode.toLowerCase() == 'owl' ||
            mode.toLowerCase() == 'parking' ||
            mode.toLowerCase() == 'alarm') {
          return {
            'channelId': _parkingAlertsChannel.id,
            'channelName': _parkingAlertsChannel.name,
            'description': 'Spy mode alerts',
            'sound': RawResourceAndroidNotificationSound('spymode_sound'),
            'iosSound': 'spymode_sound.aiff',
          };
        }

        // Default case
        return {
          'channelId': _highAlertsChannel.id,
          'channelName': _highAlertsChannel.name,
          'description': 'General alerts',
          'sound': RawResourceAndroidNotificationSound('sos_sound'),
          'iosSound': 'sos_sound.aiff',
        };
    }
  }

  /// Handle notification click
  void _handleNotificationClick(
    NotificationPayload payload,
    String consolePrint,
  ) {
    CustomLog.debug(this, "$consolePrint : $payload");
    if (payload.route != null) {
      /// TODO: handle notification routing
      // navigatorKey.currentState?.pushNamed(payload.route!);
    }
  }

  /// Convert notification payload
  Future<Map<String, String?>> _notificationPayload(
    RemoteMessage message,
  ) async {
    Map<String, String> valueMap = {};
    try {
      String raw = message.data.toString();
      String jsonString = NotificationHelper.convertToJsonStringQuotes(
        raw: raw,
      );
      final Map<String, dynamic> result = json.decode(jsonString);
      valueMap = result.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      CustomLog.error(this, "Payload conversion error", e);
    }
    return valueMap;
  }

  /// Get FCM Token
  Future<void> getFcmToken() async {
    try {
      // Don't re-initialize Firebase, just get the token
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await FirebaseMessaging.instance.subscribeToTopic('global');
        CustomLog.debug(this, "FCM Token: ${token.trim()}");
        await _secureSharedPrefs.saveKey(
          AppString.sessionKey.fcmToken,
          token.trim(),
        );
        deviceToken = await _secureSharedPrefs.get(
          AppString.sessionKey.fcmToken,
        );
      } else {
        CustomLog.debug(this, "FCM Token is null or empty");
      }
    } catch (e) {
      CustomLog.error(this, "Get FCM token error", e);
    }
  }

  /// Clear FCM Token
  Future<void> clearFcmToken() async {
    try {
      // await FirebaseMessaging.instance.deleteToken();
      CustomLog.debug(this, "FCM token cleared successfully");
    } catch (e) {
      CustomLog.error(this, "Failed to clear FCM token", e);
    }
  }

  /// Increment badge count
  Future<void> _incrementBadgeCount() async {
    badgeCount++;
    if (await AppBadgePlus.isSupported()) {
      await AppBadgePlus.updateBadge(badgeCount);
    } else {
      CustomLog.debug(this, "App badge not supported on this device");
    }
    CustomLog.debug(this, "Badge Count: $badgeCount");
  }

  /// Clear badge count
  Future<void> clearBadgeCount() async {
    badgeCount = 0;
    if (await AppBadgePlus.isSupported()) {
      await AppBadgePlus.updateBadge(0);
    }
    CustomLog.debug(this, "Badge Count Cleared: $badgeCount");
  }

  /// Save device name and notification type based on event type
  Future<void> _saveDeviceNameAndType(
    String eventType,
    String deviceName,
  ) async {
    // Save last notification device name
    _sessionManager.saveLastNotificationDeviceName(deviceName);

    // Save device name based on event type
    switch (eventType.toLowerCase()) {
      case 'sos':
        _sessionManager.saveSOSDeviceName(deviceName);
        _sessionManager.setNewNotificationType('SOS');
        break;
      case 'powercut':
      case 'power_cut':
        _sessionManager.savePowerCutDeviceName(deviceName);
        _sessionManager.setNewNotificationType('PowerCut');
        break;
      case 'unauthorized_parking':
      case 'unauthorised_parking':
      case 'parking':
      case 'tow':
        _sessionManager.saveSpyModeDeviceName(deviceName);
        _sessionManager.setNewNotificationType('SpyMode');
        break;
      case 'commandresult':
        _sessionManager.setNewNotificationType('CommandResult');
        break;
      default:
        _sessionManager.setNewNotificationType(eventType);
        break;
    }
  }

  /// Get device name for specific event type
  Future<String> _getDeviceNameForEvent(String eventType) async {
    switch (eventType.toLowerCase()) {
      case 'sos':
        return await _sessionManager.getSOSDeviceName();
      case 'powercut':
      case 'power_cut':
        return await _sessionManager.getPowerCutDeviceName();
      case 'unauthorized_parking':
      case 'unauthorised_parking':
      case 'parking':
      case 'tow':
        return await _sessionManager.getSpyModeDeviceName();
      default:
        return await _sessionManager.getLastNotificationDeviceName();
    }
  }

  /// Get device-specific message based on event type
  String _getDeviceSpecificMessage(
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
}
