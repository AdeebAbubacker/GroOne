import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_cubit.dart';
import 'package:gro_one_app/features/choose_language_screen/repository/language_repository.dart';
import 'package:gro_one_app/features/choose_language_screen/service/language_service.dart';
import 'package:gro_one_app/features/choose_role_screen/bloc/role_bloc.dart';
import 'package:gro_one_app/features/document/cubit/document_type_cubit.dart';
import 'package:gro_one_app/features/document/repository/document_repository.dart';
import 'package:gro_one_app/features/document/services/document_service.dart';
import 'package:gro_one_app/features/driver/driver_home/bloc/driver_loads/driver_loads_bloc.dart';
import 'package:gro_one_app/features/driver/driver_home/repository/driver_load_repository.dart';
import 'package:gro_one_app/features/driver/driver_home/service/driver_load_service.dart';
import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
import 'package:gro_one_app/features/driver/driver_load_details/repository/driver_loads_details_repository.dart';
import 'package:gro_one_app/features/driver/driver_load_details/service/driver_load_details_service.dart';
import 'package:gro_one_app/features/driver/driver_profile/cubit/driver_profile_cubit.dart';
import 'package:gro_one_app/features/driver/driver_profile/repository/driver_profile_repository.dart';
import 'package:gro_one_app/features/driver/driver_profile/service/driver_profile_service.dart';
import 'package:gro_one_app/features/email_verification/cubit/email_verification_cubit.dart';
import 'package:gro_one_app/features/email_verification/repository/email_verification_repository.dart';
import 'package:gro_one_app/features/email_verification/service/email_verification_service.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/endhan_transaction_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/repository/en-dhan_repository.dart';
import 'package:gro_one_app/features/en-dhan_fuel/service/en-dhan_services.dart';
import 'package:gro_one_app/features/fastag/repository/fastag_repository.dart';
import 'package:gro_one_app/features/fastag/service/fastag_service.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_notification_cubit/gps_notification_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_billing_address_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_order_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_products_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_shipping_address_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_upload_document_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_screen_lifecycle_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_vehicle_cubit/gps_vehicle_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/vehicle_detail_cubit.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_service/gps_order_api_services.dart';
import 'package:gro_one_app/features/gps_feature/repository/gps_repository.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_service.dart';
import 'package:gro_one_app/features/gps_feature/service/report_service.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_list_bloc/kavach_products_list_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import 'package:gro_one_app/features/kavach/cubit/choose_preference_cubit.dart';
import 'package:gro_one_app/features/kavach/cubit/kavach_add_vehicle_cubit/kavach_add_vehicle_cubit.dart';
import 'package:gro_one_app/features/kavach/repository/kavach_repository.dart';
import 'package:gro_one_app/features/kavach/service/kavach_service.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/kyc/repository/kyc_repository.dart';
import 'package:gro_one_app/features/kyc/service/kyc_service.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/cubit/lp_create_account_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/repository/create_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/service/create_service.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_commodity/load_commodity_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_truck_type/load_truck_type_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_select_address_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_home/service/lp_home_service.dart';
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
import 'package:gro_one_app/features/payments/cubit/payment_cubit.dart';
import 'package:gro_one_app/features/privacy_policy/bloc/privacy_policy_bloc.dart';
import 'package:gro_one_app/features/privacy_policy/repository/privacy_repository.dart';
import 'package:gro_one_app/features/privacy_policy/service/privacy_policy_service.dart';
import 'package:gro_one_app/features/profile/cubit/masters/masters_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
import 'package:gro_one_app/features/profile/service/profile_service.dart';
import 'package:gro_one_app/features/splash/splash_repository.dart';
import 'package:gro_one_app/features/splash/splash_service.dart';
import 'package:gro_one_app/features/splash/splash_view_mode.dart';
import 'package:gro_one_app/features/terms_and_conditions/bloc/terms_and_conditions_bloc.dart';
import 'package:gro_one_app/features/terms_and_conditions/repository/t_and_c_repository.dart';
import 'package:gro_one_app/features/terms_and_conditions/service/terms_and_conditions_service.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/bloc/vp_all_loads_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/repository/vp_all_load_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/service/vp_all_load_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/service/vp_creation_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/repository/load_details_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/services/vp_details_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/service/vp_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/cubit/pod_dispatch_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/repository/pod_dispatch_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/service/pod_dispatch_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/cubit/vp_trip_statement_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/repository/vp_trip_settlement_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/service/vp_trip_settlement_service.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';
import 'package:gro_one_app/service/location_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

import '../features/ai_chat/cubit/chat_cubit.dart';
import '../features/ai_chat/repository/chat_repository.dart';
import '../features/ai_chat/service/chat_api_service.dart';
import '../features/fastag/cubit/fastag_cubit.dart';
import '../features/gps_feature/cubit/get_vehicle_extra_info_cubit.dart';
import '../features/gps_feature/cubit/gps_info_window_details_cubit.dart';
import '../features/gps_feature/cubit/gps_login_cubit.dart';
import '../features/gps_feature/cubit/gps_notification_type_sheet_cubit/gps_notification_type_sheet_cubit.dart';
import '../features/gps_feature/cubit/gps_parking_mode_cubit/gps_parking_mode_cubit.dart';
import '../features/gps_feature/cubit/path_replay_cubit.dart';
import '../features/gps_feature/cubit/report_cubit.dart';
import '../features/gps_feature/cubit/vehicle_list_cubit.dart';
import '../features/gps_feature/repository/gps_login_repository.dart';
import '../features/gps_feature/repository/gps_vehicle_extra_info_repository.dart';
import '../features/gps_feature/repository/path_replay_repository.dart';
import '../features/gps_feature/repository/report_repository.dart';
import '../features/gps_feature/service/gps_data_refresh_service.dart';
import '../features/gps_feature/service/gps_login_service.dart';
import '../features/gps_feature/service/gps_realm_service.dart';
import '../features/gps_feature/service/gps_screen_manager.dart';
import '../features/gps_feature/service/gps_vehicle_extra_info_service.dart';
import '../features/gps_feature/service/path_replay_service.dart';
import '../features/kavach/cubit/kavach_transaction_cubit/kavach_transaction_cubit.dart';
import '../service/pushNotification/notification_service.dart';

var locator = GetIt.instance;

void initLocator() {
  try {
    CustomLog.info(locator, "Registering services with GetIt...");

    // 🚀 CRITICAL SERVICES - Initialize immediately
    _registerCriticalServices();

    // 🚀 CORE SERVICES - Initialize immediately
    _registerCoreServices();

    // 🚀 AUTH SERVICES - Initialize immediately
    _registerAuthServices();

    // 🚀 BASIC REPOSITORIES - Initialize immediately
    _registerBasicRepositories();

    // 🚀 BASIC BLOCS/CUBITS - Initialize immediately
    _registerBasicBlocs();

    // 🚀 DEFERRED SERVICES - Initialize lazily (GPS, etc.)
    _registerDeferredServices();

    // 🚀 DEFERRED REPOSITORIES - Initialize lazily
    _registerDeferredRepositories();

    // 🚀 DEFERRED BLOCS/CUBITS - Initialize lazily
    _registerDeferredBlocs();

    CustomLog.info(locator, "All instances registered.");
  } catch (e) {
    CustomLog.error(locator, "ERROR : All instances are not registered.", e);
  }
}

/// Register critical services that are needed immediately
void _registerCriticalServices() {
  // Shared Manager
  locator.registerLazySingleton(() => const FlutterSecureStorage());
  locator.registerLazySingleton(
    () => SecuredSharedPreferences(locator<FlutterSecureStorage>()),
  );

  // Firebase
  locator.registerLazySingleton(() => AnalyticsService());

  // Core services
  locator.registerLazySingleton<Dio>(() => Dio());
  locator.registerLazySingleton(
    () => ApiService(locator<Dio>(), locator<SecuredSharedPreferences>()),
  );
}

/// Register core services needed for basic functionality
void _registerCoreServices() {
  locator.registerLazySingleton(
    () => SplashService(locator<SecuredSharedPreferences>(), locator<ApiService>()),
  );
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => HasInternetConnection());
}

/// Register authentication-related services
void _registerAuthServices() {
  locator.registerLazySingleton(() => LoginInService(locator<ApiService>()));
  locator.registerLazySingleton(
    () => MobileOtpVerificationService(locator<ApiService>()),
  );
  locator.registerLazySingleton(() => VpCreationService(locator<ApiService>()));
  locator.registerLazySingleton(() => DocumentService(locator<ApiService>()));
  locator.registerLazySingleton(() => LpCreateService(locator<ApiService>()));
  locator.registerLazySingleton(
    () => VpTripStatementService(locator<ApiService>()),
  );
  locator.registerLazySingleton(() => KycService(locator<ApiService>()));
  locator.registerLazySingleton(
    () => ProfileService(
      locator<ApiService>(),
      locator<SecuredSharedPreferences>(),
      locator<UserInformationRepository>(),
      locator<AuthRepository>(),
    ),
  );
  locator.registerLazySingleton(() => LpHomeService(locator<ApiService>()));
  locator.registerLazySingleton(() => VpHomeService(locator<ApiService>()));
  locator.registerLazySingleton(
    () => KavachService(
      locator<ApiService>(),
      locator<SecuredSharedPreferences>(),
    ),
  );
  locator.registerLazySingleton(
    () => FastagService(
      locator<ApiService>(),
      locator<SecuredSharedPreferences>(),
    ),
  );
  locator.registerLazySingleton(() => LanguageService(locator<ApiService>()));
  locator.registerLazySingleton(() => VpLoadService(locator<ApiService>()));
  locator.registerLazySingleton(
    () => EmailVerificationService(locator<ApiService>()),
  );
  locator.registerLazySingleton(() => LpLoadService(locator<ApiService>()));
  locator.registerLazySingleton(() => VpDetailsService(locator<ApiService>()));
  locator.registerLazySingleton(
    () => EnDhanService(
      locator<ApiService>(),
      locator<SecuredSharedPreferences>(),
    ),
  );
  locator.registerLazySingleton(
    () => TermsAndConditionsService(locator<ApiService>()),
  );
  locator.registerLazySingleton(
    () => PrivacyPolicyService(locator<ApiService>()),
  );
  locator.registerLazySingleton(
    () => PodDispatchService(locator<ApiService>()),
  );
  locator.registerLazySingleton(() => DriverLoadService(locator<ApiService>()));
  locator.registerLazySingleton(
    () => DriverLoadDetailsService(locator<ApiService>()),
  );
  locator.registerLazySingleton(
    () => DriverProfileService(
      locator<ApiService>(),
      locator<UserInformationRepository>(),
      locator<AuthRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GpsOrderApiService(
      locator<ApiService>(),
      locator<SecuredSharedPreferences>(),
    ),
  );
  locator.registerLazySingleton(
    () => GpsOrderApiRequest(locator<ApiService>()),
  );
}

/// Register basic repositories needed for core functionality
void _registerBasicRepositories() {
  locator.registerLazySingleton(
    () => SplashRepository(locator<SplashService>()),
  );
  locator.registerLazySingleton(
    () => AuthRepository(
      locator<SecuredSharedPreferences>(),
      locator<NotificationService>(),
    ),
  );
  locator.registerLazySingleton(
    () => UserInformationRepository(locator<SecuredSharedPreferences>()),
  );
  locator.registerLazySingleton(
    () => LoginInRepository(locator<LoginInService>()),
  );
  locator.registerLazySingleton(
    () => VpTripStatementRepository(locator<VpTripStatementService>()),
  );
  locator.registerLazySingleton(
    () => MobileOtpVerificationRepository(
      locator<MobileOtpVerificationService>(),
      locator<AuthRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => VpCreationRepository(
      locator<VpCreationService>(),
      locator<AuthRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => DocumentRepository(locator<DocumentService>()),
  );
  locator.registerLazySingleton(
    () => LPMapSelectAddressRepository(locator<LocationService>()),
  );
  locator.registerLazySingleton(
    () => KycRepository(
      locator<KycService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => LpHomeRepository(
      locator<LpHomeService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => ProfileRepository(
      locator<ProfileService>(),
      locator<AuthRepository>(),
      locator<SecuredSharedPreferences>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => LpCreateRepository(
      locator<LpCreateService>(),
      locator<AuthRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => KavachRepository(
      locator<KavachService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => FastagRepository(locator<FastagService>()),
  );
  locator.registerLazySingleton(
    () => LanguageRepository(locator<LanguageService>()),
  );
  locator.registerLazySingleton(
    () => VpLoadRepository(
      locator<VpLoadService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => EmailVerificationRepository(locator<EmailVerificationService>()),
  );
  locator.registerLazySingleton(
    () => LpLoadRepository(
      locator<LpLoadService>(),
      locator<UserInformationRepository>(),
      locator<SecuredSharedPreferences>(),
    ),
  );
  locator.registerLazySingleton(
    () => LoadDetailsRepository(
      locator<VpDetailsService>(),
      locator<VpHomeService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => EnDhanRepository(locator<EnDhanService>()),
  );
  locator.registerLazySingleton(
    () => TAndCRepository(locator<TermsAndConditionsService>()),
  );
  locator.registerLazySingleton(
    () => PrivacyRepository(locator<PrivacyPolicyService>()),
  );
  locator.registerLazySingleton(
    () => VpHomeRepository(
      locator<VpHomeService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => PodDispatchRepository(locator<PodDispatchService>()),
  );
  locator.registerLazySingleton(
    () => DriverLoadRepository(
      locator<DriverLoadService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => DriverLoadsDetailsRepository(
      locator<DriverLoadDetailsService>(),
      locator<UserInformationRepository>(),
      locator<SecuredSharedPreferences>(),
    ),
  );
  locator.registerLazySingleton(
    () => DriverProfileRepository(
      locator<DriverProfileService>(),
      locator<AuthRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
}

/// Register basic BLoCs and Cubits needed for core functionality
void _registerBasicBlocs() {
  // ViewModels
  locator.registerLazySingleton(
    () =>
        SplashViewModel(locator<SplashRepository>(), locator<AuthRepository>()),
  );

  // Basic BLoCs
  locator.registerLazySingleton(
    () => LanguageCubit(locator<LanguageRepository>()),
  );
  locator.registerLazySingleton(() => RoleBloc());
  locator.registerLazySingleton(() => LoginBloc(locator<LoginInRepository>()));
  locator.registerLazySingleton(
    () => OtpBloc(locator<MobileOtpVerificationRepository>()),
  );
  locator.registerLazySingleton(
    () => LpHomeBloc(locator<UserInformationRepository>()),
  );
  locator.registerLazySingleton(
    () => LoadFilterCubit(
        locator<VpLoadRepository>(),
      ),
    );
    locator.registerLazySingleton(
      () => LoadPostingBloc(
      locator<UserInformationRepository>(),
      locator<LpHomeRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => LoadCommodityBloc(locator<LpHomeRepository>()),
  );
  locator.registerLazySingleton(
    () => DocumentTypeCubit(
      locator<DocumentRepository>(),
      locator<LoadDetailsCubit>(),
      locator<DriverLoadDetailsCubit>(),
    ),
  );
  locator.registerLazySingleton(
    () => GpsOrderApiRepository(locator<GpsOrderApiService>()),
  );
  locator.registerLazySingleton(
    () => LoadTruckTypeBloc(locator<LpHomeRepository>()),
  );
  locator.registerLazySingleton(
    () => VpHomeBloc(
      locator<VpHomeRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => VpRecentLoadListBloc(locator<VpHomeRepository>()),
  );
  locator.registerLazySingleton(
    () => VpAcceptLoadBloc(
      locator<VpHomeRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => KavachProductsListBloc(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(
    () => KavachCheckoutShippingAddressBloc(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(
    () => KavachCheckoutBillingAddressBloc(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(
    () => KavachCheckoutVehicleBloc(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(
    () => KavachCheckoutAddAddressBloc(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(
    () => KavachOrderBloc(
      locator<KavachRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => KavachOrderListBloc(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(() => VpLoadCubit(locator<VpLoadRepository>()));
  locator.registerLazySingleton(
    () => TermsAndConditionsBloc(locator<TAndCRepository>()),
  );
  locator.registerLazySingleton(
    () => PrivacyPolicyBloc(locator<PrivacyRepository>()),
  );
  locator.registerLazySingleton(
    () => DriverLoadsBloc(locator<DriverLoadRepository>()),
  );

  // Basic Cubits
  locator.registerLazySingleton(() => LPHomeCubit(locator<LpHomeRepository>()));
  locator.registerLazySingleton(
    () => KycCubit(
      locator<KycRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => EmailVerificationCubit(locator<EmailVerificationRepository>()),
  );
  locator.registerLazySingleton(
    () => LpLoadCubit(
      locator<LpLoadRepository>(),
      locator<LoadDetailsRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => LoadDetailsCubit(
      locator<LoadDetailsRepository>(),
      locator<VpHomeRepository>(),
      locator<LpLoadRepository>(),
      locator<LpLoadRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => VpTripStatementCubit(locator<VpTripStatementRepository>()),
  );
  locator.registerLazySingleton(
    () => ChoosePreferenceCubit(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(
    () => KavachAddVehicleFormCubit(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(
    () => EnDhanCubit(
      locator<EnDhanRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => EndhanTransactionCubit(
      locator<EnDhanService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => ProfileCubit(
      locator<ProfileRepository>(),
      locator<VpCreationRepository>(),
      locator<LpHomeRepository>(),
      locator<KavachRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => LpCreateAccountCubit(locator<LpCreateRepository>()),
  );
  locator.registerLazySingleton(
    () => VpCreateAccountCubit(locator<VpCreationRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsUploadDocumentCubit(locator<GpsOrderApiRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsProductsCubit(locator<GpsOrderApiRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsBillingAddressCubit(
      locator<GpsOrderApiRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GpsShippingAddressCubit(
      locator<GpsOrderApiRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GpsOrderCubit(
      locator<GpsOrderApiRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => KavachTransactionsCubit(locator<KavachRepository>()),
  );
  locator.registerLazySingleton(
    () => DriverLoadDetailsCubit(
      locator<LoadDetailsRepository>(),
      locator<DriverLoadsDetailsRepository>(),
      locator<LpLoadRepository>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GpsVehicleCubit(
      locator<GpsOrderApiRequest>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(() => FastagCubit(locator<FastagRepository>()));
  locator.registerLazySingleton(
    () => PodDispatchCubit(locator<PodDispatchRepository>()),
  );
  locator.registerLazySingleton(
    () => DriverProfileCubit(locator<DriverProfileRepository>()),
  );
  locator.registerLazySingleton<PaymentCubit>(() => PaymentCubit());
  locator.registerLazySingleton(
    () => MastersCubit(locator<ProfileRepository>(),locator<KycRepository>()),
  );

  // AI Chat dependencies
  locator.registerLazySingleton(
    () => ChatApiService(
      locator<ApiService>(),
      locator<SecuredSharedPreferences>(),
    ),
  );
  locator.registerLazySingleton(
    () => ChatRepository(locator<ChatApiService>()),
  );
  locator.registerLazySingleton(() => ChatCubit(locator<ChatRepository>()));
}

/// Register GPS and other heavy services lazily
void _registerDeferredServices() {
  // GPS Services - Register but don't initialize yet
  locator.registerLazySingleton(() => GpsService(locator<ApiService>()));
  locator.registerLazySingleton(
    () => GpsLoginService(
      locator<ApiService>(),
      locator<UserInformationRepository>(),
    ),
  );
  locator.registerLazySingleton(() => GpsRealmService());
  locator.registerLazySingleton(() => GpsDataRefreshService());
  locator.registerLazySingleton(() => GpsScreenManager());
  locator.registerLazySingleton(() => GpsScreenLifecycleCubit());
  locator.registerLazySingleton(
    () =>
        GpsReportService(locator<ApiService>(), locator<GpsLoginRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsVehicleExtraInfoService(Dio(), locator<ApiService>()),
  );
  locator.registerLazySingleton(() => PathReplayService(locator<ApiService>()));
}

/// Register GPS repositories lazily
void _registerDeferredRepositories() {
  locator.registerLazySingleton(
    () => GpsRepository(locator<GpsService>(), locator<GpsLoginRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsLoginRepository(
      locator<GpsLoginService>(),
      locator<GpsRealmService>(),
      locator<HasInternetConnection>(),
    ),
  );
  locator.registerLazySingleton(
    () => GpsReportRepository(service: locator<GpsReportService>()),
  );
  locator.registerLazySingleton(
    () => GpsVehicleExtraInfoRepository(
      locator<GpsVehicleExtraInfoService>(),
      locator<GpsRealmService>(),
    ),
  );
  locator.registerLazySingleton(
    () => PathReplayRepository(locator<PathReplayService>()),
  );
}

/// Register GPS BLoCs and Cubits lazily
void _registerDeferredBlocs() {
  locator.registerLazySingleton(
    () => GpsVehicleExtraInfoCubit(locator<GpsVehicleExtraInfoRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsInfoWindowDetailsCubit(locator<GpsVehicleExtraInfoRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsGeofenceCubit(
      locator<GpsRepository>(),
      locator<GpsLoginRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => GpsNotificationCubit(locator<GpsRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsParkingModeCubit(locator<GpsRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsNotificationTypesSheetCubit(locator<GpsRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsLoginCubit(locator<GpsLoginRepository>()),
  );
  locator.registerLazySingleton(
    () => VehicleListCubit(repository: locator<GpsLoginRepository>()),
  );
  locator.registerLazySingleton(
    () => GpsReportCubit(repository: locator<GpsReportRepository>()),
  );
  locator.registerLazySingleton(() => VehicleDetailCubit());
  locator.registerLazySingleton(
    () => PathReplayCubit(locator<PathReplayRepository>()),
  );

  // Verify GPS cubits are registered
  try {
    locator<GpsBillingAddressCubit>();
    locator<GpsShippingAddressCubit>();
    locator<GpsVehicleCubit>();
    CustomLog.info(
      locator,
      "GPS cubits successfully registered and accessible.",
    );
  } catch (e) {
    CustomLog.error(locator, "ERROR: GPS cubits not properly registered", e);
  }
}

/// Initialize GPS services after app is fully loaded
Future<void> initializeGpsServices() async {
  try {
    // Initialize GPS services only when needed
    locator<GpsDataRefreshService>().initialize();
    locator<GpsScreenManager>().initialize();
    CustomLog.info(locator, "GPS services initialized successfully");
  } catch (e) {
    CustomLog.error(locator, "ERROR: GPS services initialization failed", e);
  }
}
