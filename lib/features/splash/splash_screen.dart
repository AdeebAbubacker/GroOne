import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/splash/model/app_update_response.dart';
import 'package:gro_one_app/features/splash/splash_view_mode.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:lottie/lottie.dart';

enum AppUpdateType { none, soft, force }

AppUpdateType parseUpdateType(AppUpdateResponse resp) {
  if (resp.updateRequired) {
    return resp.isForce ? AppUpdateType.force : AppUpdateType.soft;
  }
  return AppUpdateType.none;
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashViewModel = locator<SplashViewModel>();

  @override
  void initState() {
    init(context);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }


  //  Init Function
  Future<void> init(BuildContext context) async {
    try {
      CustomLog.debug(this, "Splash screen init started");

      await Future.delayed(const Duration(seconds: 4));

      final prefs = locator<SecuredSharedPreferences>();
      final savedLangCode = await prefs.get(AppString.sessionKey.selectedLanguage);

      CustomLog.debug(this, "Fetching user login status");
      // Add timeout for fetchIsUserLogin
      await splashViewModel.fetchIsUserLogin().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          CustomLog.error(this, "fetchIsUserLogin timed out", null);
          throw TimeoutException('Login check timed out', const Duration(seconds: 10));
        },
      );

      final loginState = splashViewModel.checkIsUserLoginUIState;
      CustomLog.debug(this, "Login state: ${loginState?.status}, data: ${loginState?.data}");

      if (loginState != null && loginState.status == Status.SUCCESS) {
        if (loginState.data == true) {
          if (!context.mounted) return;
          await _checkUserType(context); // Go to home screen
        } else {
          if (!context.mounted) return;
          context.go(AppRouteName.login, extra: {"showBackButton": false}); // Go to login screen
        }
      } else if (loginState != null && loginState.status == Status.ERROR) {
        if (!context.mounted) return;
        if (savedLangCode == null) {
          context.go(AppRouteName.chooseLanguage); // First-time user, no language
        } else {
          context.go(AppRouteName.login, extra: {"showBackButton": false}); // Language exists, go to login
        }
      } else {
        // Fallback navigation if state is null or unexpected
        if (!context.mounted) return;
        // CustomLog.error(this, "Unexpected login state, using fallback navigation", null);
        if (savedLangCode == null) {
          context.go(AppRouteName.chooseLanguage);
        } else {
          context.go(AppRouteName.login, extra: {"showBackButton": false});
        }
      }
    } catch (e) {
      CustomLog.error(this, "Init function error", e);
      if (!context.mounted) return;

      // Fallback navigation on any error
      final prefs = locator<SecuredSharedPreferences>();
      final savedLangCode = await prefs.get(AppString.sessionKey.selectedLanguage);

      if (savedLangCode == null) {
        context.go(AppRouteName.chooseLanguage);
      } else {
        context.go(AppRouteName.login, extra: {"showBackButton": false});
      }
    }
  }


  // Check user type (1 LP, 2 VP, 3 Both, 4)
  _checkUserType(BuildContext context) async {
    try {
      // CustomLog.debug(this, "Fetching user type");

      // Add timeout for fetchUserType
      await splashViewModel.fetchUserType().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          CustomLog.error(this, "fetchUserType timed out", null);
          throw TimeoutException('User type check timed out', const Duration(seconds: 10));
        },
      );

      if (!context.mounted) return;

      final userRoleState = splashViewModel.userRoleUIState;
      // CustomLog.debug(this, "User role state: ${userRoleState?.status}, data: ${userRoleState?.data}");

      if (userRoleState != null && userRoleState.status != null) {
        if (userRoleState.status == Status.ERROR) {
          // Navigate to login on error instead of showing toast and hanging
          context.go(AppRouteName.login, extra: {"showBackButton": false});
          return;
        }
        if (userRoleState.status == Status.SUCCESS) {
          if (userRoleState.data != null) {
            // CustomLog.debug(this, "Navigating to home with user role: ${userRoleState.data}");
            frameCallback(() {
              navigateHomeScreen(userRoleState.data!, context);
            });
          } else {
            // Fallback if data is null
            context.go(AppRouteName.login, extra: {"showBackButton": false});
          }
        }
      } else {
        // Fallback navigation if state is null
        context.go(AppRouteName.login, extra: {"showBackButton": false});
      }
    } catch (e) {
      CustomLog.error(this, "Check user type error", e);
      if (!context.mounted) return;

      // Always navigate somewhere on error to prevent hanging
      context.go(AppRouteName.login, extra: {"showBackButton": false});
    }
  }

  //Navigate Home Screen
  void navigateHomeScreen(int userRole, BuildContext context){
    CustomLog.debug(this, "User Role data type : ${userRole.runtimeType}");
    if (userRole == 0) {
      context.go(AppRouteName.driverHome);
    } else if (userRole == 1) {
      context.go(AppRouteName.lpBottomNavigationBar);
    } else if (userRole == 2) {
      context.go(AppRouteName.vpBottomNavigationBar);
    } else if (userRole == 3){
      context.go(AppRouteName.lpBottomNavigationBar);
    } else if (userRole == 4){
      context.go(AppRouteName.lpBottomNavigationBar);
    } else {
      context.push(AppRouteName.notFound);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(
        AppJSON.splash,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        frameRate: FrameRate(120),
        repeat: false,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
