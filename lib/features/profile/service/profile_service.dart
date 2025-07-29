import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/kavach/model/kavach_vehicle_document_upload_model.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/delete_vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/driver_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/features/profile/model/blue_membership_response.dart';
import 'package:gro_one_app/features/profile/model/customer_settings_response.dart';
import 'package:gro_one_app/features/profile/model/driver_list_response.dart';
import 'package:gro_one_app/features/profile/model/driver_new_response.dart';
import 'package:gro_one_app/features/profile/model/driver_updated_response.dart';
import 'package:gro_one_app/features/profile/model/faq_response.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/features/profile/model/kyc_document_response.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/primart_address_response.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/profile/model/profile_upload_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_new_response.dart';
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
  Future<Result<PaginatedAddressList>> fetchAddress({required String userId}) async {
    try {
      final url = ApiUrls.getAddress+userId;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = PaginatedAddressList.fromJson(response.value);
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
  Future<Result<CustomerAddress>> createAddress({required AddressRequest request}) async {
    try {
      final url = ApiUrls.createAddress;
      final response = await _apiService.post(url, body: request.toJson());
      if (response is Success) {
        final loads = CustomerAddress.fromJson(response.value);
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
  Future<Result<CustomerAddress>> updateAddress({required String addressId, required AddressRequest request}) async {
    try {
      final url = ApiUrls.updateAddress+addressId;
      final response = await _apiService.put(url, body: request.toJson());
      if (response is Success) {
        final loads = CustomerAddress.fromJson(response.value);
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

//-----------------------------

  /// fetch vehicle
  Future<Result<PaginatedVehicleList>> fetchVehicle({required String userId,String? search}) async {
    try {
      final baseUrl = '${ApiUrls.getVehicleList}$userId';
      final url = (search != null && search.trim().isNotEmpty)
          ? '$baseUrl?search=$search'
          : baseUrl;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = PaginatedVehicleList.fromJson(response.value);
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

 
   /// create Vehicle
  Future<Result<VehicleNewModel>> createVehicle({required VehicleRequest request}) async {
    try {
      final url = ApiUrls.getVehicleList + "add";
      final response = await _apiService.post(url, body: request.toJson());
      if (response is Success) {
        final loads = VehicleNewModel.fromJson(response.value);
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
 
   /// update vehicle
  Future<Result<VehicleNewModel>> updateVehicle({required String vehicleId, required VehicleRequest request}) async {
    try {
      final url = ApiUrls.getVehicleList + vehicleId;
      final response = await _apiService.put(url, body: request.toJson());
      if (response is Success) {
        final loads = VehicleNewModel.fromJson(response.value);
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

  /// Delete vehicle
  Future<Result<bool>> deleteVehicle({
  required String vehicleId,
  required DeleteVehicleRequest request,
}) async {
  try {
    final url = ApiUrls.deleteVehicle + vehicleId;


    final result = await _apiService.put(
      url,
      body: request.toJson(),
    );

    if (result is Success) {
      print("delete success ${result.value.toString()}");
      return Success(true);
    } else if (result is Error) {
       print("delete error ${result.type.toString()}");
      return Error(result.type);
    } else {
       print("delete error GenericError");
      return Error(GenericError());
    }
  } catch (e) {
     print("delete error e");
    return Error(DeserializationError());
  }
}

 
  /// create Driver
  Future<Result<DriverNewModel>> createDriver({required DriverRequest request}) async {
    try {
      final url = ApiUrls.driverListUrl;
      final response = await _apiService.post(url, body: request.toJson());
      if (response is Success) {
        print("driver ${response.value.toString()}");
        final loads = DriverNewModel.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        print("driver ${response.toString()}");
        return Error(response.type);
      } else {
        print("driver GenericError");
        return Error(GenericError());
      }
    } catch (e) {
      print("driver e");
      return Error(DeserializationError());
    }
  }

  /// update driver
  Future<Result<DriverNewModel>> updateDriver({required String driverId, required DriverRequest request}) async {
    try {
       final url = '${ApiUrls.driverListUrl}/$driverId';
      final response = await _apiService.patch(url, body: request.toJson());
      if (response is Success) {
        final loads = DriverNewModel.fromJson(response.value);
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

/// fetch Driver
 Future<Result<PaginatedDriverList>> fetchDriver({required String customerId}) async {
  try {
    final url = "${ApiUrls.driverListUrl}?status=1&customerId=$customerId";
    final response = await _apiService.get(url);
    if (response is Success) {
      final loads = PaginatedDriverList.fromJson(response.value);
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

  /// delete Driver
  Future<Result<void>> deleteDriver({required String driverId}) async {
    try {
        final url = '${ApiUrls.driverListUrl}/$driverId';
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

  Future<Result<KavachVehicleDocumentUploadModel>> uploadLicenseData(File file) async {
    try {
      // Get user ID from secure storage
      final userId = await _securedSharedPref.get(AppString.sessionKey.userId);
      if (userId == null || userId.isEmpty) {
        CustomLog.error(this, "User ID not found in secure storage", null);
        return Error(ErrorWithMessage(message: 'User ID not found'));
      }

      final url = ApiUrls.documentUpload;

      // Prepare form fields with required parameters
      final fields = {
        'userId': userId,
        'fileType': 'driving_license',
        'documentType': 'vp_document',
      };

      final result = await _apiService.multipart(
        url,
        file,
        pathName: "file",
        fields: fields,
      );

      if (result is Success) {
        CustomLog.debug(this, "Upload API raw response: ${result.value}");
        
        try {
          final responseData = result.value;
          
          if (responseData is Map<String, dynamic>) {
            CustomLog.debug(this, "Response keys: ${responseData.keys.toList()}");
            CustomLog.debug(this, "Response URL: ${responseData['url']}");
            
            // The API response is directly the document upload data
            final documentResponse = KavachVehicleDocumentUploadModel.fromJson(responseData);
            CustomLog.debug(this, "Successfully parsed document upload response");
            return Success(documentResponse);
          } else {
            CustomLog.error(this, "Invalid upload response format - expected Map, got ${responseData.runtimeType}", null);
            return Error(DeserializationError());
          }
        } catch (e) {
          CustomLog.error(this, "Failed to parse upload response", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(result is Error ? result.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Upload error", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
  /// fetch FAQ
  Future<Result<FaqResponse>> fetchFaq() async {
    try {
      final url = ApiUrls.getFaq;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = FaqResponse.fromJson(response.value);
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
