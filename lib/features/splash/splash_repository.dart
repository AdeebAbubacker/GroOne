

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/splash/splash_service.dart';

class SplashRepository {
  final SplashService _splashService;
  SplashRepository(this._splashService);

  // Check user login
  Future<Result<bool>> getIsUserLogin() async {
    return await _splashService.checkIsUserLogin();
  }

  // Check user type
  Future<Result<String>> getUserRole() async {
    return  await _splashService.checkUserRole();
  }

}