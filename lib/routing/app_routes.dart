import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/home/view/home_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/view/lp_profile_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/buy_fastag/view/buy_fastag_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/en_dhan_card/view/en_dhan_card.dart';
import 'package:gro_one_app/features/our_value_added_service/view/gps/view/gps_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/instant_loan/view/instant_loan_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/insurance/view/insurance_screen.dart';

import 'package:gro_one_app/features/splash/splash_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/view/vp_bottom_navigation.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/default_screen.dart' show DefaultScreen;
import 'package:gro_one_app/routing/app_route_name.dart';
import '../features/choose_language_screen/view/choose_language_screen.dart';
import '../features/choose_role_screen/view/choose_role_screen.dart';
import '../features/kyc/view/kyc_screen.dart';
import '../features/load_provider/home/validate_memo/view/lp_validate_memo.dart';
import '../features/load_provider/lp_bottom_navigation/view/lp_bottom_navigation.dart';
import '../features/load_provider/lp_create_account/view/lp_create_account.dart';
import '../features/load_provider/lp_home/view/home_screen_load_provider.dart';
import '../features/load_provider/lp_location_screens/lp_pay_now_or_track_load/view/lp_pay_now_and_track_load.dart';
import '../features/load_provider/lp_location_screens/lp_select_pick_point/view/lp_select_pick_point_screen.dart';
import '../features/load_provider/lp_pay_now_screen/view/lp_pay_now_screen.dart';
import '../features/load_provider/lp_profile/view/my_account/edit_my_account/view/lp_edit_my_account.dart';
import '../features/load_provider/lp_profile/view/my_account/view/lp_my_account.dart';
import '../features/load_provider/lp_profile/view/setting/view/lp_setting.dart';
import '../features/load_provider/lp_profile/view/support/view/lp_support.dart';
import '../features/load_provider/lp_profile/view/transaction/view/lp_transaction.dart';
import '../features/login/view/login_screen.dart';
import '../features/otp_verification/view/otp_verification_screen.dart';

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
        path: AppRouteName.kycScreen,
        builder: (BuildContext context, GoRouterState state) {
          return KycScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.lpSupport,
        builder: (BuildContext context, GoRouterState state) {
          return LpSupport();
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
      ),   GoRoute(
        path: AppRouteName.lpPayNowScreen,
        builder: (BuildContext context, GoRouterState state) {
          return LpPayNowScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.lpTransaction,
        builder: (BuildContext context, GoRouterState state) {
          return LpTransaction();
        },
      ),  GoRoute(
        path: AppRouteName.lpSelectPickPointScreen,
        builder: (BuildContext context, GoRouterState state) {
          return LpSelectPickPointScreen();
        },
      ),
      GoRoute(
        path: AppRouteName.lpSetting,
        builder: (BuildContext context, GoRouterState state) {
          return LpSetting();
        },
      ),

      GoRoute(
        path: AppRouteName.lpMyAccount,
        builder: (BuildContext context, GoRouterState state) {
          return LpMyAccount();
        },
      ),
      GoRoute(
        path: AppRouteName.lpProfile,
        builder: (BuildContext context, GoRouterState state) {
          return LpProfileScreen();
        },
      ),
      GoRoute(
        path: AppRouteName.lpEditMyAccount,
        builder: (BuildContext context, GoRouterState state) {
          return LpEditMyAccount();
        },
      ),

      //home screen
      GoRoute(
        path: AppRouteName.home,
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen();
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
        path: AppRouteName.lpBottomNavigation,
        builder: (BuildContext context, GoRouterState state) {
          return LpBottomNavigation();
        },
      ),
      GoRoute(
        path: AppRouteName.login,
        builder: (BuildContext context, GoRouterState state) {
          final role = "${state.extra}" ;

          return LoginScreen(roleId: int.parse(role!),);
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
          return LpPayNowAndTrackLoad();
        },
      ), GoRoute(
        path: AppRouteName.lpCreateAccount,
        builder: (BuildContext context, GoRouterState state) {
          return LpCreateAccount();
        },
      ),
      GoRoute(
        path: AppRouteName.otpVerificationScreen,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra! as Map<String, dynamic>;
          final String mobileNumber = data["mobileNumber"];
          final String otp = data["otp"];
          final String roleId = data["roleId"];

          return OtpVerificationScreen(otp:otp ,mobileNumber: mobileNumber,roleId:roleId);
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
