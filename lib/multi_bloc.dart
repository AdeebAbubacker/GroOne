import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_bloc.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import 'package:gro_one_app/features/kavach/cubit/choose_preference_cubit.dart';
import 'package:gro_one_app/features/kavach/cubit/kavach_add_vehicle_cubit/kavach_add_vehicle_cubit.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/cubit/lp_create_account_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_commodity/load_commodity_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_truck_type/load_truck_type_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/rate_discovery/rate_discovery_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/select_address/lp_select_address_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/privacy_policy/bloc/privacy_policy_bloc.dart';
import 'package:gro_one_app/features/profile/bloc/profile_bloc.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/terms_and_conditions/bloc/terms_and_conditions_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/bloc/vp_all_loads_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/upload_rc_truck_file/upload_rc_truck_file_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'dependency_injection/locator.dart';
import 'features/choose_role_screen/bloc/role_bloc.dart';
import 'features/kavach/bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_bloc.dart';
import 'features/kavach/bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import 'features/login/bloc/login_bloc.dart';
import 'features/otp_verification/bloc/otp_bloc.dart';
import 'features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';


class MultiBlocWrapper extends StatelessWidget {
  final Widget child;
  const MultiBlocWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(create: (_) => locator<LanguageBloc>()),
        BlocProvider<RoleBloc>(create: (_) => locator<RoleBloc>()),
        BlocProvider<LoginBloc>(create: (_) => locator<LoginBloc>()),
        BlocProvider<OtpBloc>(create: (_) => locator<OtpBloc>()),
        BlocProvider<VpCreationBloc>(create: (_) => locator<VpCreationBloc>()),
        BlocProvider<KycCubit>(create: (_) => locator<KycCubit>()),
        BlocProvider<UploadRcTruckFileBloc>(create: (_) => locator<UploadRcTruckFileBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => locator<ProfileBloc>()),
        BlocProvider<LpMapSelectPickPointBloc>(create: (_) => locator<LpMapSelectPickPointBloc>()),
        BlocProvider<LoadPostingBloc>(create: (_) => locator<LoadPostingBloc>()),
        BlocProvider<LoadTruckTypeBloc>(create: (_) => locator<LoadTruckTypeBloc>()),
        BlocProvider<LoadCommodityBloc>(create: (_) => locator<LoadCommodityBloc>()),
        BlocProvider<RateDiscoveryBloc>(create: (_) => locator<RateDiscoveryBloc>()),
        BlocProvider<VpHomeBloc>(create: (_) => locator<VpHomeBloc>()),
        BlocProvider<VpHomeBloc>(create: (_) => locator<VpHomeBloc>()),
        BlocProvider<VpHomeBloc>(create: (_) => locator<VpHomeBloc>()),
        BlocProvider<VpRecentLoadListBloc>(create: (_) => locator<VpRecentLoadListBloc>()),
        BlocProvider<VpAcceptLoadBloc>(create: (_) => locator<VpAcceptLoadBloc>()),
        BlocProvider<KavachCheckoutShippingAddressBloc>(create: (_) => locator<KavachCheckoutShippingAddressBloc>()),
        BlocProvider<KavachCheckoutBillingAddressBloc>(create: (_) => locator<KavachCheckoutBillingAddressBloc>()),
        BlocProvider<KavachCheckoutVehicleBloc>(create: (_) => locator<KavachCheckoutVehicleBloc>()),
        BlocProvider<KavachCheckoutAddAddressBloc>(create: (_) => locator<KavachCheckoutAddAddressBloc>()),
        BlocProvider<LPHomeCubit>(create: (_) => locator<LPHomeCubit>()),
        BlocProvider<KavachOrderBloc>(create: (_) => locator<KavachOrderBloc>()),
        BlocProvider<KavachOrderListBloc>(create: (_) => locator<KavachOrderListBloc>()),
        BlocProvider<VpLoadBloc>(create: (_) => locator<VpLoadBloc>()),
        BlocProvider<TermsAndConditionsBloc>(create: (_) => locator<TermsAndConditionsBloc>()),
        BlocProvider<PrivacyPolicyBloc>(create: (_) => locator<PrivacyPolicyBloc>()),
        BlocProvider<EmailVerificationCubit>(create: (_) => locator<EmailVerificationCubit>()),
        BlocProvider<LpLoadCubit>(create: (_) => locator<LpLoadCubit>()),
        BlocProvider<LoadDetailsCubit>(create: (_) => locator<LoadDetailsCubit>()),
        BlocProvider<ChoosePreferenceCubit>(create: (_) => locator<ChoosePreferenceCubit>()),
        BlocProvider<LoadDetailsCubit>(create: (_) => locator<LoadDetailsCubit>()),
        BlocProvider<KavachAddVehicleFormCubit>(create: (_) => locator<KavachAddVehicleFormCubit>()),
        // EnDhanCubit removed from MultiBlocWrapper to control lifecycle manually
        BlocProvider<ProfileCubit>(create: (_) => locator<ProfileCubit>()),
        BlocProvider<LpCreateAccountCubit>(create: (_) => locator<LpCreateAccountCubit>()),
      ],
      child: child,
    );
  }
}
