import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/home/view/home_screen.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/default_screen.dart' show DefaultScreen;
import 'package:gro_one_app/routing/app_route_name.dart';

class AppRoutes{
  AppRoutes._();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRouteName.home,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[

      // Splash
      GoRoute(
        path: AppRouteName.home,
        builder: (BuildContext context, GoRouterState state) {
          return  HomeScreen();
        },
      ),

      // Introduction Screen
      GoRoute(
        path: AppRouteName.intro,
        builder: (BuildContext context, GoRouterState state) {
          return  Container();
        },
      ),

      // Sign In
      GoRoute(
        path: AppRouteName.signIn,
        builder: (BuildContext context, GoRouterState state) {
          return  Container();
        },
      ),

      // GoRoute(
      //   path: AppRouteName.signIn,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //     child: const SignInScreen(),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       const begin = Offset(0.0, 1.0);
      //       const end = Offset.zero;
      //       const curve = Curves.ease;
      //
      //       final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      //       final offsetAnimation = animation.drive(tween);
      //
      //       return SlideTransition(
      //         position: offsetAnimation,
      //         child: child,
      //       );
      //     },
      //   ),
      // ),

      // Home
      GoRoute(
        path: AppRouteName.home,
        builder: (BuildContext context, GoRouterState state) {
          return  Container();
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