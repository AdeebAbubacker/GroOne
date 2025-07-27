import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/features/profile/model/blue_membership_response.dart';
import 'package:gro_one_app/features/profile/model/customer_settings_response.dart';
import 'package:gro_one_app/features/profile/model/driver_list_response.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/features/profile/model/kyc_document_response.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/primart_address_response.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/profile/model/profile_upload_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_new_response.dart';
import 'package:gro_one_app/features/profile/service/profile_service.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class ProfileRepository {
  final ProfileService _profileService;
  final AuthRepository _authRepository;
  final UserInformationRepository _userInformationRepository;
  final SecuredSharedPreferences _securedSharedPref;
  ProfileRepository(this._profileService, this._authRepository, this._securedSharedPref, this._userInformationRepository);

  /// Get User Details Repo
  Future<Result<ProfileDetailModel>> getUserDetails() async {
    try {
      return await _profileService.getProfileDetails();
    } catch (e) {

      CustomLog.error(this, "Failed to request get user details data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Resend Otp repo
  Future<Result<ProfileUpdateResponse>> updateProfileData(ProfileUpdateRequest request, {required String userId}) async {
    try {
      return await _profileService.fetchUpdateProfileData(request,userID: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request update profile data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// get master repo
  Future<Result<MasterResponse>> getMaster({required String userId}) async {
    try {
      return await _profileService.fetchGetMasterData(userId: userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request get master data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Upload Profile repo
  Future<Result<ProfileImageUploadResponse>> uploadProfile(ProfileImageUploadRequest request, {required String userId}) async {
    try {
      return await _profileService.fetchProfileUploadData(request,userId:userId);
    } catch (e) {
      CustomLog.error(this, "Failed to request upload profile data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get Documents
  Future<Result<KycDocumentResponse>> fetchDocuments({required String userId}) async {
    try {
      return await _profileService.fetchDocuments(userId: userId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get Membership Benefit
  Future<Result<BlueMemberShipResponse>> fetchMembershipBenefit() async {
    try {
      return await _profileService.fetchMembershipBenefit();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get Address
  Future<Result<PaginatedAddressList>> fetchAddress({required String userId}) async {
    try {
      return await _profileService.fetchAddress(userId: userId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// set primary address
  Future<Result<SetPrimaryAddressResponse>> setPrimaryAddress({required String addressId}) async {
    try {
      return await _profileService.setPrimaryAddress(addressId: addressId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// create new address
  Future<Result<CustomerAddress>> createAddress({required AddressRequest request}) async {
    try {
      return await _profileService.createAddress(request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// update address
  Future<Result<CustomerAddress>> updateAddress({required String addressId, required AddressRequest request}) async {
    try {
      return await _profileService.updateAddress(addressId: addressId, request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// delete address
  Future<Result<void>> deleteAddress({required String addressId}) async {
    try {
      return await _profileService.deleteAddress(addressId: addressId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
 
    /// create new vehicle
  Future<Result<VehicleNewModel>> createVehicle({required VehicleRequest request}) async {
    try {
      return await _profileService.createVehicle(request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get Vehicle
  Future<Result<PaginatedVehicleList>> fetchVehicle({required String userId}) async {
    try {
      return await _profileService.fetchVehicle(userId: userId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Delete Vehicle
Future<Result<bool>> deleteVehicle({
  required String vehicleId,
}) async {
  try {
    return await _profileService.deleteVehicle(
      vehicleId: vehicleId,
    );
  } catch (e) {
    return Error(ErrorWithMessage(message: e.toString()));
  }
}

  /// Get Driver
  Future<Result<PaginatedDriverList>> fetchDriver({required String userId}) async {
    try {
      return await _profileService.fetchDriver(customerId: userId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }  

  /// delete driver
  Future<Result<void>> deleteDriver({required String driverId}) async {
    try {
      return await _profileService.deleteDriver(driverId: driverId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  } 
  /// fetch customer settings
  Future<Result<CustomerSettingsResponse>> fetchCustomerSettings({required String userId}) async {
    try {
      return await _profileService.fetchCustomerSettings(userId: userId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// update customer settings
  Future<Result<void>> updateCustomerSettings({required String userId, required UpdateSettingsRequest request}) async {
    try {
      return await _profileService.updateCustomerSettings(userId: userId, request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }



  /// LogOut Repo
  Future<Result<LogOutModel>> getLogOutData() async {
    try {
      return await _profileService.fetchLogOutData();
    } catch (e) {
      CustomLog.error(this, "Failed to request logout data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Sign Out
  Future<Result<bool>> signOut() async {
    try {
      await _authRepository.signOut(); // Your logout logic here
      return Success(true);
    } catch (e) {
      return Error(GenericError());
    }
  }


  /// Clear Blue Id
  Future saveHasShowBluePopup(bool value) async {
    await _securedSharedPref.saveBoolean(AppString.sessionKey.hasBlueIdPopupShown, value);
  }

  /// Get Show Blue
  Future<bool> getHasShowBluePopup() async {
    return await _securedSharedPref.getBooleans(AppString.sessionKey.hasBlueIdPopupShown);
  }

  /// Get Show Blue
  Future<String?> getCustomerTypeId() async {
    return await _userInformationRepository.getCustomerTypeID();
  }

  /// Get Show Blue
  Future<String?> getUserId() async {
    return await _userInformationRepository.getUserID();
  }

  /// Get Show Blue
  Future<int?> getUserRole() async {
    return await _userInformationRepository.getUserRole();
  }

  /// Get Blue Id
  Future<Result<String>> getBlueId() async {
    try {
      dynamic blueId = await _userInformationRepository.getBlueID();
      CustomLog.debug(this, "Get Blue Id : $blueId");
      if (blueId == null) {
        return Error(ErrorWithMessage(message: "Blue Id is null"));
      }
      return Success(blueId);
    } catch (e) {
      CustomLog.error(this, "Failed to get blue id", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}
