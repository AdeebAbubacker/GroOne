import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_bloc.dart';
import 'package:gro_one_app/features/choose_language_screen/repository/language_repository.dart';
import 'package:gro_one_app/features/choose_language_screen/service/language_service.dart';
import 'package:gro_one_app/features/choose_role_screen/bloc/role_bloc.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/features/email_verification/repository/email_verification_repository.dart';
import 'package:gro_one_app/features/email_verification/service/email_verification_service.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_list_bloc/kavach_products_list_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import 'package:gro_one_app/features/kavach/repository/kavach_repository.dart';
import 'package:gro_one_app/features/kavach/service/kavach_service.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/bloc/lp_create_bloc.dart';
import 'package:gro_one_app/features/kyc/repository/kyc_repository.dart';
import 'package:gro_one_app/features/kyc/service/kyc_service.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/repository/create_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/service/create_service.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_commodity/load_commodity_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_truck_type/load_truck_type_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/rate_discovery/rate_discovery_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_home/service/lp_home_service.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/select_address/lp_select_address_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_select_address_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/repository/lp_all_loads_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/service/lp_all_loads_service.dart';
import 'package:gro_one_app/features/login/bloc/login_bloc.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/login_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/login/service/login_service.dart';
import 'package:gro_one_app/features/otp_verification/bloc/otp_bloc.dart';
import 'package:gro_one_app/features/otp_verification/repository/mobile_otp_verification_repository.dart';
import 'package:gro_one_app/features/otp_verification/service/mobile_otp_verification_service.dart';
import 'package:gro_one_app/features/profile/bloc/profile_bloc.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
import 'package:gro_one_app/features/profile/service/profile_service.dart';
import 'package:gro_one_app/features/splash/splash_repository.dart';
import 'package:gro_one_app/features/splash/splash_service.dart';
import 'package:gro_one_app/features/splash/splash_view_mode.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/bloc/vp_all_loads_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/repository/vp_all_load_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/service/vp_all_load_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/upload_rc_truck_file/upload_rc_truck_file_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/service/vp_creation_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/service/vp_service.dart';
import 'package:gro_one_app/helpers/analytics_helper.dart';
import 'package:gro_one_app/service/location_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

import '../features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';

var locator = GetIt.instance;

void initLocator() {
  try {
    CustomLog.info(locator, "Registering services with GetIt...");

    // Shared Manager
    locator.registerLazySingleton(() => const FlutterSecureStorage());
    locator.registerLazySingleton(() => SecuredSharedPreferences(locator<FlutterSecureStorage>()));

    // Firebase
    locator.registerLazySingleton(() => AnalyticsHelper());

    // Auth Services
    locator.registerLazySingleton<Dio>(() => Dio());
    locator.registerLazySingleton(() => ApiService(locator<Dio>(), locator<SecuredSharedPreferences>()));

    // Service
    locator.registerLazySingleton(() => SplashService(locator<SecuredSharedPreferences>()));
    locator.registerLazySingleton(() => LocationService());
    locator.registerLazySingleton(() => LoginInService(locator<ApiService>()));
    locator.registerLazySingleton(() => MobileOtpVerificationService(locator<ApiService>()));
    locator.registerLazySingleton(() => VpCreationService(locator<ApiService>()));
    locator.registerLazySingleton(() => LpCreateService(locator<ApiService>()));
    locator.registerLazySingleton(() => KycService(locator<ApiService>()));
    locator.registerLazySingleton(() => ProfileService(locator<ApiService>()));
    locator.registerLazySingleton(() => LpHomeService(locator<ApiService>(), locator<SecuredSharedPreferences>()));
    locator.registerLazySingleton(() => VpHomeService(locator<ApiService>()));
    locator.registerLazySingleton(() => KavachService(locator<ApiService>()));
    locator.registerLazySingleton(() => LanguageService(locator<ApiService>()));
    locator.registerLazySingleton(() => VpLoadService(locator<ApiService>()));
    locator.registerLazySingleton(() => EmailVerificationService(locator<ApiService>()));
    locator.registerLazySingleton(() => LpLoadService(locator<ApiService>()));

    // Repository
    locator.registerLazySingleton(() => SplashRepository(locator<SplashService>()));
    locator.registerLazySingleton(() => AuthRepository(locator<SecuredSharedPreferences>(), locator<ApiService>()));
    locator.registerLazySingleton(() => UserInformationRepository(locator<SecuredSharedPreferences>()));
    locator.registerLazySingleton(() => LoginInRepository(locator<LoginInService>()));
    locator.registerLazySingleton(() => MobileOtpVerificationRepository(locator<MobileOtpVerificationService>(), locator<AuthRepository>()));
    locator.registerLazySingleton(() => VpCreationRepository(locator<VpCreationService>(), locator<AuthRepository>()));
    locator.registerLazySingleton(() => LPMapSelectAddressRepository(locator<LocationService>()));
    locator.registerLazySingleton(() => KycRepository(locator<KycService>()));
    locator.registerLazySingleton(() => ProfileRepository(locator<ProfileService>()));
    locator.registerLazySingleton(() => LpHomeRepository(locator<LpHomeService>(), locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => VpHomeRepository(locator<VpHomeService>()));
    locator.registerLazySingleton(() => LpCreateRepository(locator<LpCreateService>(), locator<AuthRepository>()));
    locator.registerLazySingleton(() => KavachRepository(locator<KavachService>(),locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => LanguageRepository(locator<LanguageService>()));
    locator.registerLazySingleton(() => VpLoadRepository(locator<VpLoadService>(),locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => EmailVerificationRepository(locator<EmailVerificationService>(),locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => LpLoadRepository(locator<LpLoadService>(),locator<UserInformationRepository>()));

    // View Model
    locator.registerLazySingleton(() => SplashViewModel(locator<SplashRepository>(), locator<AuthRepository>()));

    // Bloc
    locator.registerLazySingleton(() => LanguageBloc(locator<LanguageRepository>()));
    locator.registerLazySingleton(() => RoleBloc());
    locator.registerLazySingleton(() => LoginBloc(locator<LoginInRepository>()));
    locator.registerLazySingleton(() => OtpBloc(locator<MobileOtpVerificationRepository>()));
    locator.registerLazySingleton(() => VpCreationBloc(locator<VpCreationRepository>(), locator<LpCreateRepository>()));
    locator.registerLazySingleton(() => UploadRcTruckFileBloc(locator<VpCreationRepository>()));
    locator.registerLazySingleton(() => LpCreateBloc(locator<LpCreateRepository>()));
    locator.registerLazySingleton(() => ProfileBloc(locator<ProfileRepository>(),locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => LpHomeBloc(locator<LpHomeRepository>(),locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => LpMapSelectPickPointBloc(locator<LPMapSelectAddressRepository>()));
    locator.registerLazySingleton(() => LoadPostingBloc(locator<UserInformationRepository>(), locator<LpHomeRepository>()));
    locator.registerLazySingleton(() => LoadCommodityBloc(locator<LpHomeRepository>()));
    locator.registerLazySingleton(() => LoadTruckTypeBloc(locator<LpHomeRepository>()));
    locator.registerLazySingleton(() => RateDiscoveryBloc(locator<LpHomeRepository>()));
    locator.registerLazySingleton(() => VpHomeBloc(locator<VpHomeRepository>(),locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => VpRecentLoadListBloc(locator<VpHomeRepository>()));
    locator.registerLazySingleton(() => VpAcceptLoadBloc(locator<VpHomeRepository>(), locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => KavachProductsListBloc(locator<KavachRepository>()));
    locator.registerLazySingleton(() => KavachCheckoutShippingAddressBloc(locator<KavachRepository>()));
    locator.registerLazySingleton(() => KavachCheckoutBillingAddressBloc(locator<KavachRepository>()));
    locator.registerLazySingleton(() => KavachCheckoutVehicleBloc(locator<KavachRepository>()));
    locator.registerLazySingleton(() => KavachCheckoutAddAddressBloc(locator<KavachRepository>()));
    locator.registerLazySingleton(() => KavachOrderBloc(locator<KavachRepository>(),locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => KavachOrderListBloc(locator<KavachRepository>()));
    locator.registerLazySingleton(() => VpLoadBloc(locator<VpLoadRepository>()));

    // Cubit
    locator.registerLazySingleton(() => LPHomeCubit(locator<LpHomeRepository>()));
    locator.registerLazySingleton(() => KycCubit(locator<KycRepository>(), locator<UserInformationRepository>()));
    locator.registerLazySingleton(() => EmailVerificationCubit(locator<EmailVerificationRepository>()));
    locator.registerLazySingleton(() => LpLoadCubit(locator<LpLoadRepository>()));


    CustomLog.info(locator, "All instances registered.");
  } catch (e) {
    CustomLog.error(locator, "ERROR : All instances are not registered.", e);
  }

}