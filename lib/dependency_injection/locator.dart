import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/choose_language_screen/bloc/language_bloc.dart';
import 'package:gro_one_app/features/choose_role_screen/bloc/role_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/bloc/lp_create_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/repository/create_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/service/create_service.dart';
import 'package:gro_one_app/features/load_provider/lp_location_screens/lp_select_pick_point/bloc/lp_map_select_pick_point_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_location_screens/lp_select_pick_point/repository/lp_map_select_pick_point_repository.dart';
import 'package:gro_one_app/features/login/bloc/login_bloc.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/login_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/login/service/login_service.dart';
import 'package:gro_one_app/features/otp_verification/bloc/otp_bloc.dart';
import 'package:gro_one_app/features/otp_verification/repository/otp_repository.dart';
import 'package:gro_one_app/features/otp_verification/service/otp_service.dart';
import 'package:gro_one_app/features/splash/splash_repository.dart';
import 'package:gro_one_app/features/splash/splash_service.dart';
import 'package:gro_one_app/features/splash/splash_view_mode.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/upload_rc_truck_file/upload_rc_truck_file_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/service/vp_creation_service.dart';
import 'package:gro_one_app/helpers/analytics_helper.dart';
import 'package:gro_one_app/service/location_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';


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
    locator.registerLazySingleton(() => OtpService(locator<ApiService>()));
    locator.registerLazySingleton(() => VpCreationService(locator<ApiService>()));
    locator.registerLazySingleton(() => LpCreateService(locator<ApiService>()));


    // Repository
    locator.registerLazySingleton(() => SplashRepository(locator<SplashService>()));
    locator.registerLazySingleton(() => AuthRepository(locator<SecuredSharedPreferences>(), locator<ApiService>()));
    locator.registerLazySingleton(() => UserInformationRepository(locator<SecuredSharedPreferences>()));
    locator.registerLazySingleton(() => LoginInRepository(locator<LoginInService>()));
    locator.registerLazySingleton(() => OtpRepository(locator<OtpService>(), locator<AuthRepository>()));
    locator.registerLazySingleton(() => VpCreationRepository(locator<VpCreationService>(), locator<AuthRepository>()));
    locator.registerLazySingleton(() => LpCreateRepository(locator<LpCreateService>()));
    locator.registerLazySingleton(() => LpMapSelectPickPointRepository(locator<LocationService>()));

    // View Model
    locator.registerLazySingleton(() => SplashViewModel(locator<SplashRepository>(), locator<AuthRepository>()));


    // Bloc
    locator.registerFactory(() => LanguageBloc());
    locator.registerFactory(() => RoleBloc());
    locator.registerFactory(() => LoginBloc(locator<LoginInRepository>()));
    locator.registerFactory(() => OtpBloc(locator<OtpRepository>()));
    locator.registerFactory(() => VpCreationBloc(locator<VpCreationRepository>(), locator<UserInformationRepository>()));
    locator.registerFactory(() => UploadRcTruckFileBloc(locator<VpCreationRepository>()));
    locator.registerFactory(() => LpCreateBloc(locator<LpCreateRepository>()));
    locator.registerFactory(() => LpMapSelectPickPointBloc(locator<LpMapSelectPickPointRepository>()));


    CustomLog.info(locator, "All instances registered.");
  } catch (e) {
    CustomLog.error(locator, "ERROR : All instances are not registered.", e);
  }

}