import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_logout_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/model/delete_account_response.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class DriverProfileService {
  final ApiService _apiService;
  final UserInformationRepository _userInformationRepository;
  final AuthRepository _authRepository;
  DriverProfileService(
    this._apiService,
    this._userInformationRepository,
    this._authRepository,
  );
  Future<Result<DriverProfileDetailsModel>> getDriverProfileDetails() async {
    try {
      final userId = await _userInformationRepository.getUserID();
      final url = "${ApiUrls.driverProfile}${userId ?? ""}";

      if (userId == null || userId.isEmpty) {
        return Error(InvalidInputError());
      }


      final result = await _apiService.get(url);
      if (result is Success) {
        dynamic data = DriverProfileDetailsModel.fromJson(result.value);
        // Save Blue Id
        if (data is DriverProfileDetailsModel) {
          // Save user info data
          dynamic saveUserResult;
          saveUserResult = await _authRepository.saveUserInfoFromDriverHome(
            data,
          );
          if (saveUserResult is Success) {
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
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Log out repo
  Future<Result<DriverlogoutModel>> fetchLogOutData() async {
    try {
      final url = ApiUrls.logout;
       String? deviceId = (await getDeviceInfo()).$2;
      final result = await _apiService.post(
        url,
        body: {"deviceId": deviceId},
      );
      if (result is Success) {
        final logOutModel = DriverlogoutModel.fromJson(result.value);
        return Success(logOutModel);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Delete Driver Account
  Future<Result<DeleteAccountModel>> deleteAccount() async {
    try {
      final customerId = await _userInformationRepository.getUserID() ?? "";
      final url = "${ApiUrls.deleteDriver}$customerId";

      final result = await _apiService.delete(url);

      if (result is Success) {
        final deleteAccountModel = DeleteAccountModel.fromJson(result.value);
        return Success(deleteAccountModel);
      } else if (result is Error) {
        CustomLog.error(
          this,
          "Delete account failed with API error type: ${result.type}",
          null,
        );
        return Error(result.type);
      } else {
        CustomLog.error(
          this,
          "Delete account failed with unknown result",
          null,
        );
        return Error(GenericError());
      }
    } catch (e, stackTrace) {
      // Catch any exception and log stack trace
      CustomLog.error(
        this,
        "Exception occurred while deleting account: $e",
        stackTrace,
      );
      return Error(DeserializationError());
    }
  }

    Future<(String? deviceType, String? id)> getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return ("android", androidInfo.id);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return ("IOS", iosInfo.identifierForVendor);
      }
      return ("", "");
    } catch (e) {
      debugPrint('❌ Error getting device info: $e');
      return ("", "");
    }
  }
}
