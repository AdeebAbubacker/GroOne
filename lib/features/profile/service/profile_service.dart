import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/features/profile/model/blue_membership_response.dart';
import 'package:gro_one_app/features/profile/model/customer_settings_response.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/features/profile/model/kyc_document_response.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/primart_address_response.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/profile/model/profile_upload_response.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class ProfileService {
  final ApiService _apiService;
  final SecuredSharedPreferences _securedSharedPref;
  final UserInformationRepository _userInformationRepository;
  final AuthRepository _authRepository;
  ProfileService(this._apiService, this._securedSharedPref, this._userInformationRepository, this._authRepository);

  /// Fetch Profile Details Repo
  Future<Result<ProfileDetailModel>> getProfileDetails() async {
    try {
      final url = ApiUrls.getProfile + (await _userInformationRepository.getUserID() ?? "");
      final result = await _apiService.get(url);
      if (result is Success) {
        dynamic data = ProfileDetailModel.fromJson(result.value);
        // Save Blue Id
        if (data is ProfileDetailModel) {

          // Save user info data
          dynamic saveUserResult;
          saveUserResult = await _authRepository.saveUserInfoFromHome(data);

          if (saveUserResult is Success) {
            // Blue Membership Logic
            final customer = data.customer;
            final newBlueId = customer?.blueId;
            final storedBlueId = await _userInformationRepository.getBlueID();
            debugPrint("Service Blue Id : $newBlueId");

            if (newBlueId != null && newBlueId.isNotEmpty) {
              // Save Blue ID and popup flag if not stored before
              if (storedBlueId == null || storedBlueId.isEmpty) {
                debugPrint("🎉 First time Blue ID saved: $newBlueId");
                await _securedSharedPref.saveKey(AppString.sessionKey.blueId, newBlueId);
                await _securedSharedPref.saveBoolean(AppString.sessionKey.hasBlueIdPopupShown, true);
              }
            } else {
              // Clear Blue ID and popup flag if blueId is null
              debugPrint("🧹 Blue ID cleared");
              await _securedSharedPref.deleteKey(AppString.sessionKey.blueId);
              await _securedSharedPref.deleteKey(AppString.sessionKey.hasBlueIdPopupShown);
            }
            if(data.customer != null && data.customer!.companyType != null){
              await _securedSharedPref.saveInt(AppString.sessionKey.companyTypeId, data.customer!.companyType!.id);
              debugPrint("🎉 Company Type ID saved: ${data.customer!.companyType!.id}");
            }

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
      return Error(DeserializationError());
    }
  }


  /// fetch update profile repo
  Future<Result<ProfileUpdateResponse>> fetchUpdateProfileData(ProfileUpdateRequest request, {required userID}) async {
    try {
      final result = await _apiService.put(ApiUrls.getProfile + userID, body: request);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => ProfileUpdateResponse.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }


  /// fetch profile upload repo
  Future<Result<ProfileImageUploadResponse>> fetchProfileUploadData(ProfileImageUploadRequest request, {required String userId}) async {
    try {
      final result = await _apiService.post(ApiUrls.updateProfile+userId, body: request);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => ProfileImageUploadResponse.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }


  /// fetch master repo
  Future<Result<MasterResponse>> fetchGetMasterData({required String userId}) async {
    try {
      final result = await _apiService.get(ApiUrls.getMaster + userId);
      if (result is Success) {
        return await _apiService.getResponseStatus(result.value, (data) => MasterResponse.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// fetch documents
  Future<Result<KycDocumentResponse>> fetchDocuments({required String userId}) async {
    try {
      final url = ApiUrls.getKycDocuments+userId;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = KycDocumentResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// fetch membership benefits
  Future<Result<BlueMemberShipResponse>> fetchMembershipBenefit() async {
    try {
      final url = ApiUrls.getMembershipBenefit;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = BlueMemberShipResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// fetch address
  Future<Result<AddressResponse>> fetchAddress({required String userId}) async {
    try {
      final url = ApiUrls.getAddress+userId;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = AddressResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// set primary address
  Future<Result<SetPrimaryAddressResponse>> setPrimaryAddress({required String addressId}) async {
    try {
      final url = ApiUrls.setPrimaryAddress+addressId;
      final response = await _apiService.put(url, body: {"isDefault":true});
      if (response is Success) {
        final loads = SetPrimaryAddressResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// create address
  Future<Result<ProfileAddress>> createAddress({required AddressRequest request}) async {
    try {
      final url = ApiUrls.createAddress;
      final response = await _apiService.post(url, body: request.toJson());
      if (response is Success) {
        final loads = ProfileAddress.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// update address
  Future<Result<ProfileAddress>> updateAddress({required String addressId, required AddressRequest request}) async {
    try {
      final url = ApiUrls.updateAddress+addressId;
      final response = await _apiService.put(url, body: request.toJson());
      if (response is Success) {
        final loads = ProfileAddress.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// delete address
  Future<Result<void>> deleteAddress({required String addressId}) async {
    try {
      final url = ApiUrls.deleteAddress+addressId;
      final response = await _apiService.delete(url);
      if (response is Success) {
        return Success(null);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// fetch customer settings
  Future<Result<CustomerSettingsResponse>> fetchCustomerSettings({required String userId}) async {
    try {
      final url = ApiUrls.getCustomerSettings+userId;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = CustomerSettingsResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// update customer settings
  Future<Result<void>> updateCustomerSettings({required String userId, required UpdateSettingsRequest request}) async {
    try {
      final url = ApiUrls.updateCustomerSettings+userId;
      final response = await _apiService.patch(url, body: request.toJson());
      if (response is Success) {
        return Success(null);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }


  /// Log out repo
  Future<Result<LogOutModel>> fetchLogOutData() async {
    try {
      final url = ApiUrls.logout;
      final result = await _apiService.post(url, body: {"customerId" : (await _userInformationRepository.getUserID() ?? "")});
      if (result is Success) {
        final logOutModel= LogOutModel.fromJson(result.value);
        return  Success(logOutModel);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }


}
