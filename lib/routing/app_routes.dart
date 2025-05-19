import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/home/view/home_screen.dart';
import 'package:gro_one_app/features/splash/splash_screen.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/default_screen.dart' show DefaultScreen;
import 'package:gro_one_app/routing/app_route_name.dart';

import '../features/choose_language_screen/view/choose_language_screen.dart';
import '../features/choose_role_screen/view/choose_role_screen.dart';
import '../features/load_provider/bottom_navigation/view/bottom_navigation.dart';
import '../features/load_provider/lp_home/view/home_screen_load_provider.dart';
import '../features/login/view/login_screen.dart';
import '../features/otp_verification/view/otp_verification_screen.dart';

class AppRoutes{
  AppRoutes._();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRouteName.splash,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[

      // Splash
      GoRoute(
        path: AppRouteName.splash,
        builder: (BuildContext context, GoRouterState state) {
          return  SplashScreen();
        },
      ),

      //home screen
      GoRoute(
        path: AppRouteName.home,
        builder: (BuildContext context, GoRouterState state) {
          return  HomeScreen();
        },
      ),   GoRoute(
        path: AppRouteName.homeScreenLoadProvider,
        builder: (BuildContext context, GoRouterState state) {
          return  HomeScreenLoadProvider();
        },
      ),  GoRoute(
        path: AppRouteName.bottomNavigation,
        builder: (BuildContext context, GoRouterState state) {
          return  BottomNavigation();
        },
      ),  GoRoute(
        path: AppRouteName.login,
        builder: (BuildContext context, GoRouterState state) {
          return  LoginScreen();
        },
      ), GoRoute(
        path: AppRouteName.chooseLanguage,
        builder: (BuildContext context, GoRouterState state) {
          return  ChooseLanguageScreen();
        },
      ), GoRoute(
        path: AppRouteName.chooseRoleScreen,
        builder: (BuildContext context, GoRouterState state) {
          return  ChooseRoleScreen();
        },
      ),
GoRoute(
        path: AppRouteName.otpVerificationScreen,
        builder: (BuildContext context, GoRouterState state) {
          return  OtpVerificationScreen();
        },
      ),





      // Default Screen
      GoRoute(
        path: AppRouteName.notFound,
        builder: (BuildContext context, GoRouterState state) {
          return const DefaultScreen();
        },
      ),

    ],
  );


}