import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/home/view/home_screen.dart';
import 'package:gro_one_app/features/splash/splash_screen.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/default_screen.dart' show DefaultScreen;
import 'package:gro_one_app/routing/app_route_name.dart';

import '../features/choose_language_screen/view/choose_language_screen.dart';
import '../features/choose_role_screen/view/choose_role_screen.dart';
import '../features/login/view/login_screen.dart';

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