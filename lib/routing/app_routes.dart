import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/features/choose_role_screen/view/choose_role_screen.dart';
import 'package:gro_one_app/features/driver/driver_home/view/driver_home_screen.dart';
import 'package:gro_one_app/features/email_verification/view/email_verification_screen.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_dashboard_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_geofence_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_home_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_order/gps_order_benefits_and_order_list_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/vehicleShareAndUpdate/edit_vehicle_info.dart';
import 'package:gro_one_app/features/gps_feature/views/vehicleShareAndUpdate/select_vehicle_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/vehicleShareAndUpdate/vehicle_share_update_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/vehicle_list_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/vehicle_map_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_bottom_navigation/lp_bottom_navigation.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/view/lp_create_account.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_home_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_select_address_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/recent_route_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/lp_load_trip_statement.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_validate_memo.dart';
import 'package:gro_one_app/features/login/view/login_screen.dart';
import 'package:gro_one_app/features/master/view/master_screen.dart';
import 'package:gro_one_app/features/otp_verification/view/mobile_otp_verification_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/instant_loan/view/instant_loan_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/insurance/view/insurance_screen.dart';
import 'package:gro_one_app/features/privacy_policy/view/privacy_polcy_screen.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/view/benefits_of_membership_screen.dart';
import 'package:gro_one_app/features/profile/view/my_account_screen.dart';
import 'package:gro_one_app/features/profile/view/my_document_screen.dart';
import 'package:gro_one_app/features/profile/view/profile_screen.dart';
import 'package:gro_one_app/features/profile/view/routes_screen.dart';
import 'package:gro_one_app/features/profile/view/setting_screen.dart';
import 'package:gro_one_app/features/profile/view/support_screen.dart';
import 'package:gro_one_app/features/profile/view/transaction_screen.dart';
import 'package:gro_one_app/features/splash/splash_screen.dart';
import 'package:gro_one_app/features/terms_and_conditions/view/terms_and_conditions_screen.dart';
import 'package:gro_one_app/features/trip_tracking/widgets/payment_information_dialogue.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/vp_creation_form_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart' hide Customer;
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/view_file_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/vp_pdf_viewer.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_schedule/view/trip_schedule_screen.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/routing/transition_page.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/default_screen.dart';

import '../dependency_injection/locator.dart';
import '../features/en-dhan_fuel/view/endhan_new_user_and_card_screen.dart';
import '../features/fastag/views/fastag_list_screen.dart';
import '../features/fastag/views/fastag_new_user_screen.dart';
import '../features/gps_feature/cubit/vehicle_list_cubit.dart';
import '../features/gps_feature/views/report_screen.dart';
import '../features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart' hide Customer, BankDetails;
import '../features/load_provider/lp_loads/view/lp_loads_location_details_screen.dart';
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
          return FastagNewUserScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.enDhanCard,
        builder: (BuildContext context, GoRouterState state) {
          return EndhanNewUserAndCardScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.gps,
        builder: (BuildContext context, GoRouterState state) {
          return GpsHomeScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.gpsDashboard,
        builder: (BuildContext context, GoRouterState state) {
          return const GpsDashboardScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.gpsGeofence,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider.value(
            value: locator<VehicleListCubit>(),
            child: GpsGeofenceScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRouteName.gpsOrderBenefits,
        builder: (BuildContext context, GoRouterState state) {
          return GpsOrderBenefitsAndOrderListScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.gpsVehicleShareAndUpdate,
        builder: (BuildContext context, GoRouterState state) {
          return const VehicleShareUpdateScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.gpsEditVehicleInfo,
        builder: (BuildContext context, GoRouterState state) {
          final vehicleData = state.extra as Map<String, dynamic>?;
          return EditVehicleInfoScreen(vehicleData: vehicleData);
        },
      ),

      GoRoute(
        path: AppRouteName.gpsVehicleSelectScreen,
        builder: (BuildContext context, GoRouterState state) {
          final isFromId = "${state.extra}";
          return VehicleSelectScreen(isFromId: int.parse(isFromId));
        },
      ),

      GoRoute(
        path: AppRouteName.instantLoan,
        builder: (BuildContext context, GoRouterState state) {
          return InstantLoanScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.insurance,
        builder: (BuildContext context, GoRouterState state) {
          return InsuranceScreen();
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
          final extra = state.extra;
          final showBackButton =
              (extra is Map<String, dynamic>)
                  ? (extra["showBackButton"] ?? true) as bool
                  : true;
          return LoginScreen(showBackButton: showBackButton);
        },
      ),

      GoRoute(
        path: AppRouteName.chooseLanguage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = (state.extra as Map<String, dynamic>?) ?? {};
          final bool isCloseButton = (data["isCloseButton"] as bool?) ?? false;

          return buildTransitionPage(
              state: state,
              child: ChooseLanguageScreen(isCloseButton: isCloseButton)
          );
        },
      ),

      GoRoute(
        path: AppRouteName.chooseRoleScreen,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra! as Map<String, dynamic>;
          final String id = data["userId"];
          final String mobileNumber = data["mobileNumber"];
          return ChooseRoleScreen(userId: id, mobileNumber: mobileNumber);
        },
      ),

      GoRoute(
        path: AppRouteName.lpPayNowAndTrackLoad,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>?;
          final String loadId = data?["loadId"] ?? "";
          return LpLoadsLocationDetailsScreen(loadId: loadId);
        },
      ),
      GoRoute(
        path: AppRouteName.gpsReports,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>?;
          final preSelectedReportType =
              extra?['preSelectedReportType'] as String?;
          final preSelectedVehicle = extra?['preSelectedVehicle'];

          return BlocProvider.value(
            value: locator<VehicleListCubit>(),
            child: GpsReportScreen(
              preSelectedReportType: preSelectedReportType,
              preSelectedVehicle: preSelectedVehicle,
            ),
          );
        },
      ),

      GoRoute(
        path: AppRouteName.lpCreateAccount,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final String id = data["userId"];
          final String roleId = data["roleId"];
          final String mobileNumber = data["mobileNumber"];
          return buildTransitionPage(
              state: state,
              child: LpCreateAccount(userId: id, mobileNumber: mobileNumber, roleId: roleId),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.vpCreateAccount,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final String id = data["userId"];
          final String roleId = data["roleId"];
          final String mobileNumber = data["mobileNumber"];
          return buildTransitionPage(
              state: state,
              child: VpCreationFormScreen(id: id, mobileNumber: mobileNumber, roleId: int.parse(roleId)),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.otpVerificationScreen,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra! as Map<String, dynamic>;
          final String mobileNumber = data["mobileNumber"];
          final String otp = data["otp"];
          final bool isDriver = data["driver"];
          return MobileOtpVerificationScreen(
            otp: otp,
            mobileNumber: mobileNumber,
            isDriver: isDriver,
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
          final String loadId = data["loadId"].toString();
          return VpLoadDetailsScreen(loadId: loadId);
        },
      ),
      GoRoute(
        path: AppRouteName.viewFileWidget,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra! as Map<String, dynamic>;
          final String url = data["url"].toString();
          final String originalFileName = data["originalFileName"].toString();
          return PdfViewer(url: url, originalFileName: originalFileName,);
        },
      ),
      GoRoute(
        path: AppRouteName.tripScheduleScreen,
        builder: (BuildContext context, GoRouterState state) {
          return TripScheduleScreen();
        },
      ),
      GoRoute(
        path: AppRouteName.vehicleList,
        builder: (BuildContext context, GoRouterState state) {
          return VehicleListScreen();
        },
      ),
      GoRoute(
        path: AppRouteName.vehicleMap,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final vehicles = data['vehicles'] as List<GpsCombinedVehicleData>;
          final initialSelectedVehicle =
              data['initialSelectedVehicle'] as GpsCombinedVehicleData?;
          return VehicleMapScreen(
            vehicles: vehicles,
            initialSelectedVehicle: initialSelectedVehicle,
          );
        },
      ),
      GoRoute(
        path: AppRouteName.driverHome,
        builder: (BuildContext context, GoRouterState state) {
          return DriverHomeScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.fastagList,
        builder: (BuildContext context, GoRouterState state) {
          return FastagListScreen();
        },
      ),

      GoRoute(
        path: AppRouteName.profile,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
              state: state,
              child: ProfileScreen(),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.benefitsOfMembership,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
              state: state,
              child: BenefitsOfMembershipScreen()
          );
        },
      ),

      GoRoute(
        path: AppRouteName.myAccount,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final CustomerDataResponse customerDetail = data["customerDetail"];
          final BankDetails bankDetails = data["bankDetails"];
          final KycDoc kycDoc = data["kycDoc"];

          return buildTransitionPage(
              state: state,
              child: LpMyAccount(customerDetail: customerDetail, bankDetails: bankDetails, kycDoc: kycDoc),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.master,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
              state: state,
              child: MasterScreen(),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.routes,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
              state: state,
              child: RouteScreen(),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.myDocuments,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
              state: state,
              child: MyDocumentScreen(),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.lpTransaction,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
              state: state,
              child: LpTransaction(),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.settings,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
              state: state,
              child: LpSetting(),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.support,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final bool showBackButton = data['showBackButton'];
          return buildTransitionPage(
              state: state,
              child: LpSupport(showBackButton: showBackButton),
              isForward: true
          );
        },
      ),

      GoRoute(
        path: AppRouteName.lpLoadsLocationDetails,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final String loadId = data["loadId"].toString();

          return buildTransitionPage(
            state: state,
            child: LpLoadsLocationDetailsScreen(loadId: loadId),
          );
        },
      ),

      GoRoute(
        path: AppRouteName.lpLoadValidateMemo,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final String loadId = data["loadId"].toString();

          return buildTransitionPage(
            state: state,
            child: LpLoadValidateMemo(loadId: loadId),
          );
        },
      ),

      GoRoute(
        path: AppRouteName.lpLoadSummary,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final String loadId = data["loadId"].toString();
          final LoadData loadItem = data["loadItem"] as LoadData;

          return buildTransitionPage(
            state: state,
            child: LpLoadSummaryScreen(loadId: loadId, loadItem: loadItem),
          );
        },
      ),

      GoRoute(
        path: AppRouteName.paymentSummary,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final String tripCost = data['tripCost'];
          final List<VpLog> lpLogs = data['lpLogs'] as List<VpLog>;
          return buildTransitionPage(
            state: state,
            child: PaymentSummary(tripCost: tripCost, lpLogs: lpLogs),
          );
        },
      ),

      GoRoute(
        path: AppRouteName.emailVerification,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final String emailAddress = data["emailAddress"].toString();
          final String userId = data["userId"].toString();

          return buildTransitionPage(
            state: state,
            child: EmailVerificationScreen(emailAddress: emailAddress, userId: userId),
          );
        },
      ),


      GoRoute(
        path: AppRouteName.recentRoute,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
            state: state,
            child: RecentRouteScreen()
          );
        },
      ),

      GoRoute(
        path: AppRouteName.termsAndConditions,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
            state: state,
            child: TermsAndConditionsScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRouteName.privacyPolicy,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildTransitionPage(
            state: state,
            child: PrivacyPolicyScreen(),
          );
        },
      ),


      GoRoute(
        path: AppRouteName.lpSelectAddressScreen,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final String title = data['title'];
          final String address = data['address'] ?? '';
          final String location = data['location'] ?? '';
          return buildTransitionPage(
            state: state,
            child: LPSelectAddressScreen(title: title, address: address, location: location),
            isForward: true
          );
        },
      ),

    ],
  );
}
