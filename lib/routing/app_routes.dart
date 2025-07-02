import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/features/choose_role_screen/view/choose_role_screen.dart';
import 'package:gro_one_app/features/kyc/view/kyc_upload_document_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_bottom_navigation/lp_bottom_navigation.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/view/lp_create_account.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_home_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_track_load_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_validate_memo.dart';
import 'package:gro_one_app/features/load_provider/lp_pay_now_screen/view/lp_pay_now_screen.dart';
import 'package:gro_one_app/features/login/view/login_screen.dart';
import 'package:gro_one_app/features/otp_verification/view/mobile_otp_verification_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/buy_fastag/view/buy_fastag_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/en_dhan_card/view/en_dhan_card.dart';
import 'package:gro_one_app/features/our_value_added_service/view/gps/view/gps_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/instant_loan/view/instant_loan_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/insurance/view/insurance_screen.dart';
import 'package:gro_one_app/features/splash/splash_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_schedule/view/trip_schedule_screen.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/default_screen.dart';

import '../features/vehicle_provider/vp_details/view/vp_load_details_screen.dart';

class AppRoutes {
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
          return SplashScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.buyFastag,
        builder: (BuildContext context, GoRouterState state) {
          return BuyFasTagScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.enDhanCard,
        builder: (BuildContext context, GoRouterState state) {
          return EnDhanCard();
        },
      ),

      GoRoute(
        path: AppRouteName.gps,
        builder: (BuildContext context, GoRouterState state) {
          return GpsScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.instantLoan,
        builder: (BuildContext context, GoRouterState state) {
          return InstantLoanScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.lpValidateMemo,
        builder: (BuildContext context, GoRouterState state) {
          return LpValidateMemo();
        },
      ),

      GoRoute(
        path: AppRouteName.insurance,
        builder: (BuildContext context, GoRouterState state) {
          return InsuranceScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.lpPayNowScreen,
        builder: (BuildContext context, GoRouterState state) {
          return LpPayNowScreen();
        },
      ),

      // VP Bottom Navigation bar
      GoRoute(
        path: AppRouteName.vpBottomNavigationBar,
        builder: (BuildContext context, GoRouterState state) {
          return VPBottomNavigationBar();
        },
      ),

      GoRoute(
        path: AppRouteName.homeScreenLoadProvider,
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreenLoadProvider();
        },
      ),

      GoRoute(
        path: AppRouteName.lpBottomNavigationBar,
        builder: (BuildContext context, GoRouterState state) {
          return LpBottomNavigation();
        },
      ),

      GoRoute(
        path: AppRouteName.login,
        builder: (BuildContext context, GoRouterState state) {
          final role = "${state.extra}";
          return LoginScreen(roleId: int.parse(role!));
        },
      ),

      GoRoute(
        path: AppRouteName.chooseLanguage,
        builder: (BuildContext context, GoRouterState state) {
          return ChooseLanguageScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.chooseRoleScreen,
        builder: (BuildContext context, GoRouterState state) {
          return ChooseRoleScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.lpPayNowAndTrackLoad,
        builder: (BuildContext context, GoRouterState state) {
          return LPTrackLoadScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.lpCreateAccount,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra! as Map<String, dynamic>;
          final String id = data["userId"];
          final String roleId = data["roleId"];
          final String mobileNumber = data["mobileNumber"];
          return LpCreateAccount(
            userId: id,
            mobileNumber: mobileNumber,
            roleId: roleId,
          );
        },
      ),

      GoRoute(
        path: AppRouteName.otpVerificationScreen,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra! as Map<String, dynamic>;
          final String mobileNumber = data["mobileNumber"];
          final String otp = data["otp"];
          final String roleId = data["roleId"];
          return MobileOtpVerificationScreen(
            otp: otp,
            mobileNumber: mobileNumber,
            roleId: roleId,
          );
        },
      ),

      // Default Screen
      GoRoute(
        path: AppRouteName.notFound,
        builder: (BuildContext context, GoRouterState state) {
          return const DefaultScreen();
        },
      ),
      GoRoute(
        path: AppRouteName.loadDetailsScreen,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra! as Map<String, dynamic>;
          final int loadId = data["loadId"];
          return VpLoadDetailsScreen(
            loadId:loadId,
          );
        },
      ),
      GoRoute(
        path: AppRouteName.tripScheduleScreen,
        builder: (BuildContext context, GoRouterState state) {
          return TripScheduleScreen();
        },
      ),
    ],
  );
}
