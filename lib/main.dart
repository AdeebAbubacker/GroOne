import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gro_one_app/core/app_initializer.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/gps_feature/helper/gps_session_manager.dart';
import 'package:gro_one_app/l10n/l10n.dart';
import 'package:gro_one_app/routing/app_routes.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';
import 'package:gro_one_app/service/pushNotification/notification_service.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_theme_style.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';

import 'core/localization_bloc/localization_bloc.dart';
import 'core/localization_bloc/localization_state.dart';
import 'l10n/app_localizations.dart';
import 'multi_bloc.dart';

/// Firebase background message handler
/// This must be a top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase and other essential services
  await initializeApp();

  // Handle the background message using our unified notification service
  await NotificationService.firebaseMessagingBackgroundHandler(message);
}

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize GPS session manager first
    await GpsSessionManager.init();

    // Initialize the app (Firebase, etc.)
    await initializeApp();

    // Set up Firebase background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize the unified notification service
    // Note: SecuredSharedPreferences should be initialized in initializeApp()
    final secureStorage = FlutterSecureStorage();
    final securedSharedPrefs = SecuredSharedPreferences(secureStorage);

    await NotificationService().init(navigatorKey, securedSharedPrefs);

    // Run the app
    runApp(BlocProvider(create: (_) => LocaleBloc(), child: const MyApp()));
  } catch (e) {
    // Handle initialization errors gracefully
    print('❌ App initialization error: $e');
    // You might want to show an error widget or retry mechanism
    runApp(const ErrorApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // Add observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Initialize app functions
    initFun();
  }

  @override
  void dispose() {
    // Remove observer to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground - clear notification badges
        NotificationService().clearBadgeCount();
        break;
      case AppLifecycleState.paused:
        // App went to background
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        break;
      case AppLifecycleState.inactive:
        // App is inactive
        break;
      case AppLifecycleState.hidden:
        // App is hidden (newer Flutter versions)
        break;
    }
  }

  /// Initialize app functions
  initFun() => frameCallback(() async {
    try {
      // Check internet connectivity
      await HasInternetConnection().checkConnectivity();

      // Clear notification badges when app starts
      await NotificationService().clearBadgeCount();

      // Any other initialization logic
      // await authRepo.signOut(); // Uncomment if needed
    } catch (e) {
      print('InitFun error: $e');
    }
  });

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Lock orientation to portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        return MultiBlocWrapper(
          child: MaterialApp.router(
            // Localization settings
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: L10n.all,

            // App settings
            title: "Gro One",
            debugShowCheckedModeBanner: false, // Set to false for production
            // Theme and routing
            theme: AppThemeStyle.appTheme,
            routerConfig: AppRoutes.router,

            // Builder to handle global context if needed
            builder: (context, child) {
              // You can add global error handling or loading states here
              return child ?? const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}

/// Error app widget to show when initialization fails
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'App Initialization Failed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please restart the app',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Restart the app or try initialization again
                  SystemNavigator.pop();
                },
                child: const Text('Exit App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
