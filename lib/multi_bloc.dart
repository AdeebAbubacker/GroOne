import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_cubit.dart';
import 'package:gro_one_app/features/document/cubit/document_type_cubit.dart';
import 'package:gro_one_app/features/driver/driver_home/bloc/driver_loads/driver_loads_bloc.dart';
import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
import 'package:gro_one_app/features/driver/driver_profile/cubit/driver_profile_cubit.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/features/fastag/cubit/fastag_cubit.dart';
import 'package:gro_one_app/features/fastag/cubit/fasttag_order_list_cubit.dart';
import 'package:gro_one_app/features/fastag/cubit/fasttag_order_list_tab_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_info_window_details_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_notification_type_sheet_cubit/gps_notification_type_sheet_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_parking_mode_cubit/gps_parking_mode_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_vehicle_cubit/gps_vehicle_cubit.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import 'package:gro_one_app/features/kavach/cubit/choose_preference_cubit.dart';
import 'package:gro_one_app/features/kavach/cubit/kavach_add_vehicle_cubit/kavach_add_vehicle_cubit.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_commodity/load_commodity_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_truck_type/load_truck_type_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/payments/cubit/payment_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/masters/masters_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/bloc/vp_all_loads_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/cubit/vp_home_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/cubit/pod_dispatch_cubit.dart';

import 'dependency_injection/locator.dart';
import 'features/choose_role_screen/bloc/role_bloc.dart';
import 'features/gps_feature/cubit/gps_notification_cubit/gps_notification_cubit.dart';
import 'features/gps_feature/cubit/path_replay_cubit.dart';
import 'features/kavach/bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_bloc.dart';
import 'features/kavach/bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import 'features/kavach/cubit/kavach_transaction_cubit/kavach_transaction_cubit.dart';
import 'features/load_provider/lp_create_account/cubit/lp_create_account_cubit.dart';
import 'features/login/bloc/login_bloc.dart';
import 'features/otp_verification/bloc/otp_bloc.dart';
import 'features/privacy_policy/bloc/privacy_policy_bloc.dart';
import 'features/terms_and_conditions/bloc/terms_and_conditions_bloc.dart';
import 'features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'features/vehicle_provider/vp_trip_statement/cubit/vp_trip_statement_cubit.dart';

class MultiBlocWrapper extends StatelessWidget {
  final Widget child;

  const MultiBlocWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Language and Role
        BlocProvider<LanguageCubit>(create: (_) => locator<LanguageCubit>()),
        BlocProvider<RoleBloc>(create: (_) => locator<RoleBloc>()),

        // Authentication
        BlocProvider<LoginBloc>(create: (_) => locator<LoginBloc>()),
        BlocProvider<OtpBloc>(create: (_) => locator<OtpBloc>()),
        BlocProvider<KycCubit>(create: (_) => locator<KycCubit>()),

        // Load Provider
        BlocProvider<LoadPostingBloc>(
          create: (_) => locator<LoadPostingBloc>(),
        ),
        BlocProvider<LoadTruckTypeBloc>(
          create: (_) => locator<LoadTruckTypeBloc>(),
        ),
        BlocProvider<LoadCommodityBloc>(
          create: (_) => locator<LoadCommodityBloc>(),
        ),
        BlocProvider<LPHomeCubit>(create: (_) => locator<LPHomeCubit>()),
        BlocProvider<LpLoadCubit>(create: (_) => locator<LpLoadCubit>()),
        BlocProvider<LpCreateAccountCubit>(
          create: (_) => locator<LpCreateAccountCubit>(),
        ),

        // Vehicle Provider
        BlocProvider<VpHomeBloc>(create: (_) => locator<VpHomeBloc>()),
        BlocProvider<VpRecentLoadListBloc>(
          create: (_) => locator<VpRecentLoadListBloc>(),
        ),
        BlocProvider<VpAcceptLoadBloc>(
          create: (_) => locator<VpAcceptLoadBloc>(),
        ),
        BlocProvider<VpLoadCubit>(create: (_) => locator<VpLoadCubit>()),
        BlocProvider<VpCreateAccountCubit>(
          create: (_) => locator<VpCreateAccountCubit>(),
        ),
        BlocProvider<VpTripStatementCubit>(
          create: (_) => locator<VpTripStatementCubit>(),
        ),

        // Kavach
        BlocProvider<KavachCheckoutShippingAddressBloc>(
          create: (_) => locator<KavachCheckoutShippingAddressBloc>(),
        ),
        BlocProvider<KavachCheckoutBillingAddressBloc>(
          create: (_) => locator<KavachCheckoutBillingAddressBloc>(),
        ),
        BlocProvider<KavachCheckoutVehicleBloc>(
          create: (_) => locator<KavachCheckoutVehicleBloc>(),
        ),
        BlocProvider<KavachCheckoutAddAddressBloc>(
          create: (_) => locator<KavachCheckoutAddAddressBloc>(),
        ),
        BlocProvider<KavachOrderBloc>(
          create: (_) => locator<KavachOrderBloc>(),
        ),
        BlocProvider<KavachOrderListBloc>(
          create: (_) => locator<KavachOrderListBloc>(),
        ),
        BlocProvider<ChoosePreferenceCubit>(
          create: (_) => locator<ChoosePreferenceCubit>(),
        ),
        BlocProvider<KavachAddVehicleFormCubit>(
          create: (_) => locator<KavachAddVehicleFormCubit>(),
        ),
        BlocProvider<KavachTransactionsCubit>(
          create: (_) => locator<KavachTransactionsCubit>(),
        ),

        // Driver
        BlocProvider<DriverLoadsBloc>(
          create: (_) => locator<DriverLoadsBloc>(),
        ),
        BlocProvider<DriverProfileCubit>(
          create: (_) => locator<DriverProfileCubit>(),
        ),
        BlocProvider<DriverLoadDetailsCubit>(
          create: (_) => locator<DriverLoadDetailsCubit>(),
        ),

        // GPS
        BlocProvider<GpsGeofenceCubit>(
          create: (_) => locator<GpsGeofenceCubit>(),
        ),
        BlocProvider<PathReplayCubit>(
          create: (_) => locator<PathReplayCubit>(),
        ),
        BlocProvider<GpsNotificationCubit>(
          create: (_) => locator<GpsNotificationCubit>(),
        ),
        BlocProvider<GpsParkingModeCubit>(
          create: (_) => locator<GpsParkingModeCubit>(),
        ),
        BlocProvider<GpsNotificationTypesSheetCubit>(
          create: (_) => locator<GpsNotificationTypesSheetCubit>(),
        ),
        BlocProvider<GpsVehicleCubit>(
          create: (_) => locator<GpsVehicleCubit>(),
        ),
        BlocProvider<GpsInfoWindowDetailsCubit>(
          create: (_) => locator<GpsInfoWindowDetailsCubit>(),
        ),

        // Other
        BlocProvider<EmailVerificationCubit>(
          create: (_) => locator<EmailVerificationCubit>(),
        ),
        BlocProvider<LoadDetailsCubit>(
          create: (_) => locator<LoadDetailsCubit>(),
        ),
        BlocProvider<ProfileCubit>(create: (_) => locator<ProfileCubit>()),
        BlocProvider<PodDispatchCubit>(
          create: (_) => locator<PodDispatchCubit>(),
        ),
        BlocProvider<PaymentCubit>(create: (_) => locator<PaymentCubit>()),
        BlocProvider<MastersCubit>(create: (_) => locator<MastersCubit>()),
        BlocProvider<FastagCubit>(create: (_) => locator<FastagCubit>()),
        BlocProvider<FastagOrderListCubit>(create: (_) => locator<FastagOrderListCubit>()),
        BlocProvider<FastagOrderListTabCubit>(
          create: (_) => locator<FastagOrderListTabCubit>(),
        ),
        BlocProvider<DocumentTypeCubit>(
          create: (_) => locator<DocumentTypeCubit>(),
        ),
        BlocProvider<LoadFilterCubit>(
          create: (_) => locator<LoadFilterCubit>(),
        ),

        BlocProvider<DocumentTypeCubit>(
          create: (_) => locator<DocumentTypeCubit>(),
        ),
        BlocProvider<TermsAndConditionsBloc>(
          create: (_) => locator<TermsAndConditionsBloc>(),
        ),
        BlocProvider<PrivacyPolicyBloc>(
          create: (_) => locator<PrivacyPolicyBloc>(),
        ),
        BlocProvider<VpHomeCubit>(create: (_) => locator<VpHomeCubit>()),
      ],

      child: child,
    );
  }
}
