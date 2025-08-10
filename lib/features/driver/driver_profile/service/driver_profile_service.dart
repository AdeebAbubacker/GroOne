import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_logout_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class DriverProfileService {
  final ApiService _apiService;
  final SecuredSharedPreferences _securedSharedPref;
  final UserInformationRepository _userInformationRepository;
  final AuthRepository _authRepository;
  DriverProfileService(this._apiService, this._securedSharedPref, this._userInformationRepository, this._authRepository);
  Future<Result<DriverProfileDetailsModel>> getDriverProfileDetails() async {
    try {
    final userId = await _userInformationRepository.getUserID();
    final url = "${ApiUrls.driverProfile}${userId ?? ""}";

     if (userId == null || userId.isEmpty) {
    return Error(InvalidInputError());
  }
//315bafa0-0d0d-4eb6-81d1-85f6e4b79e7c
    print("user id is  ${ _userInformationRepository.getUserID()}");
      final result = await _apiService.get(url);
      if (result is Success) {
        print(result.value.toString());
        dynamic data = DriverProfileDetailsModel.fromJson(result.value);
        // Save Blue Id
        if (data is DriverProfileDetailsModel) {

          // Save user info data
          dynamic saveUserResult;
          saveUserResult = await _authRepository.saveUserInfoFromDriverHome(data);

          if (saveUserResult is Success) {
            // Blue Membership Logic
            // final customer = data.data;
      
            // final storedBlueId = await _userInformationRepository.getBlueID();
            // debugPrint("Service Blue Id : $newBlueId");

            // if (newBlueId != null && newBlueId.isNotEmpty) {
            //   // Save Blue ID and popup flag if not stored before
            //   if (storedBlueId == null || storedBlueId.isEmpty) {
            //     debugPrint("🎉 First time Blue ID saved: $newBlueId");
            //     await _securedSharedPref.saveKey(AppString.sessionKey.blueId, newBlueId);
            //     await _securedSharedPref.saveBoolean(AppString.sessionKey.hasBlueIdPopupShown, true);
            //   }
            // } 
            // if(data.customer != null && data.customer!.companyType != null){
            //   await _securedSharedPref.saveInt(AppString.sessionKey.companyTypeId, data.customer!.companyType!.id);
            //   debugPrint("🎉 Company Type ID saved: ${data.customer!.companyType!.id}");
            // }

            return Success(data);
          }

          if (saveUserResult is Error) {
            return Error(saveUserResult.type);
          }

        }
        if (data is Error) {
          return Error(data.type);
        }
        return Error(GenericError());
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

   /// Log out repo
  Future<Result<DriverlogoutModel>> fetchLogOutData() async {
    try {
      final url = ApiUrls.logout;
      final customerId = await _userInformationRepository.getUserID();
      final result = await _apiService.post(url, body: { "customerId" : customerId ?? "","isDriver": true});
      if (result is Success) {
        final logOutModel= DriverlogoutModel.fromJson(result.value);
        return  Success(logOutModel);
      } else if (result is Error) { 
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog. error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }
}
