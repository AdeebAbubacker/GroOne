import 'dart:io';

import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/kavach/model/kavach_vehicle_document_upload_model.dart';
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/kyc/model/create_document_model.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/create_ticket_request.dart';
import 'package:gro_one_app/features/profile/api_request/delete_vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/driver_request.dart';
import 'package:gro_one_app/features/profile/api_request/license_vahan_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/profile_upload_request.dart';
import 'package:gro_one_app/features/profile/api_request/ticket_request.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_status_update_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_vahan_request.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/features/profile/model/blood_group_response.dart';
import 'package:gro_one_app/features/profile/model/blue_membership_response.dart';
import 'package:gro_one_app/features/profile/model/customer_settings_response.dart';
import 'package:gro_one_app/features/profile/model/delete_account_response.dart';
import 'package:gro_one_app/features/profile/model/driver_list_response.dart';
import 'package:gro_one_app/features/profile/model/driver_new_response.dart';
import 'package:gro_one_app/features/profile/model/faq_response.dart';
import 'package:gro_one_app/features/profile/model/get_master_response.dart';
import 'package:gro_one_app/features/profile/model/kyc_document_response.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/primart_address_response.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/profile_update_response.dart';
import 'package:gro_one_app/features/profile/model/profile_upload_response.dart';
import 'package:gro_one_app/features/profile/model/settings_response.dart';
import 'package:gro_one_app/features/profile/model/ticket_response.dart';
import 'package:gro_one_app/features/profile/model/upload_ticket_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_new_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_updated_status_model.dart';
import 'package:gro_one_app/features/profile/model/vehicle_verification_success.dart';
import 'package:gro_one_app/features/profile/model/verified_license_vahan_response.dart';
import 'package:gro_one_app/features/profile/model/verified_vehicle_vahan_response.dart';
import 'package:gro_one_app/features/profile/service/profile_service.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
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
  Future<Result<PaginatedAddressList>> fetchAddress({required String userId,String? search}) async {
    try {
      return await _profileService.fetchAddress(userId: userId,search: search);
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

    /// update vehicle
  Future<Result<VehicleNewModel>> updateVehicle({required String vehicleId, required VehicleRequest request}) async {
    try {
      return await _profileService.updateVehicle(vehicleId: vehicleId, request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
  
    /// update Status of vehicle
  Future<Result<VehcileUpdatedStatusModel>> updateVehicleStatus({required String vehicleId, required VehicleStatusUpdateRequest request}) async {
    try {
      return await _profileService.updateVehicleStatus(vehicleId: vehicleId, request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
  /// Get Vehicle
  Future<Result<PaginatedVehicleList>> fetchVehicle({required String userId,String? search,int? page, int? limit}) async {
    try {
      return await _profileService.fetchVehicle(userId: userId,search: search,page: page ?? 1,pageSize: limit ?? 10);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Delete Vehicle
Future<Result<bool>> deleteVehicle({
  required String vehicleId,
  required DeleteVehicleRequest request,
}) async {
  try {
    return await _profileService.deleteVehicle(
      vehicleId: vehicleId,
      request: request,
    );
  } catch (e) {
    return Error(ErrorWithMessage(message: e.toString()));
  }
}

  /// create new driver
  Future<Result<DriverNewModel>> createDriver({required DriverRequest request}) async {
    try {
      return await _profileService.createDriver(request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

   /// update driver
  Future<Result<DriverNewModel>> updateDriver({required String driverId, required DriverRequest request}) async {
    try {
      return await _profileService.updateDriver(driverId: driverId, request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }



  /// Get Driver
   /// Get Driver
  Future<Result<PaginatedDriverList>> fetchDriver({required String userId,String? search,int? page, int? limit}) async {
    try {
      return await _profileService.fetchDriver(customerId: userId,search: search,page: page ?? 1,pageSize: limit ?? 10);
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

  Future<Result<KavachVehicleDocumentUploadModel>> getUploadLicenseData(File file) async {
    try {
      return await _profileService.uploadLicenseData(file);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch GST upload data in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// fetch settings
  Future<Result<List<SettingsResponse>>> fetchSettings() async {
    try {
      return await _profileService.fetchSettings();
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

  /// Get Address
  Future<Result<FaqResponse>> fetchFaq({String search = ''}) async {
    try {
      return await _profileService.fetchFaq(search: search);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get Tickets
  Future<Result<TicketResponse>> fetchTickets({required String userId,required TicketRequest request}) async {
    try {
      return await _profileService.fetchTickets(userId: userId ,request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Create Ticket
  Future<Result<Ticket>> createTicket({required CreateTicketRequest request}) async {
    try {
      return await _profileService.createTicket(request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Verify License vahan
  Future<Result<VerifedLicenseVahanData>> verifyLicenseVahan({required LicenseVahanRequest request}) async {
    try {
      return await _profileService.verifyLicenseVahan(request: request);
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

  /// Deleet Account
  Future<Result<DeleteAccountModel>> deleteAccount() async {
    try {
      return await _profileService.deleteAccount();
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

  /// Upload Ticket
  Future<Result<UploadTicketResponse>> getUploadTicketData(File file) async {
    try {
      return await _profileService.fetchUploadTicketData(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: SUPPORT_TICKET,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload ticket document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Create Document Repo
  Future<Result<CreateDocumentModel>> getCreateDocumentData(CreateDocumentApiRequest request) async {
    try {
      final userId = await _userInformationRepository.getUserID();
      return await _profileService.createDocument(request.copyWith(createdBy: userId));
    } catch (e) {
      CustomLog.error(this, "Failed to get create document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
 
  /// fetch Blood Group
  Future<Result<List<BloodGroupResponseModel>>> fetchBloodGroup() async {
    try {
      return await _profileService.fetchBloodGroups();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// fetch License Category
  Future<Result<List<LicenseCategoryResponseModel>>> fetchLicenseCategory() async {
    try {
      return await _profileService.fetchLicenseCategory();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


    Future<Result<Map<String, dynamic>>> fetchVehicleData(String vehicleNumber) async {
    try {
      return await _profileService.fetchVehicleData(vehicleNumber);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch vehicle data in repository", e);
      return Error(GenericError());
    }
  }

     Future<Result<Map<String, dynamic>>> fetchLicenseData({required LicenseVahanRequest  licensereq}) async {
    try {
      return await _profileService.fetchLicenseExcistence(request: licensereq);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch vehicle data in repository", e);
      return Error(GenericError());
    }
  }
}
