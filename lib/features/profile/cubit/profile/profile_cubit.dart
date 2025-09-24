import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/kavach/model/kavach_truck_length_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_vehicle_document_upload_model.dart';
import 'package:gro_one_app/features/kavach/repository/kavach_repository.dart';
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/kyc/model/create_document_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/repository/lp_all_loads_repository.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_status_update_request.dart';
import 'package:gro_one_app/features/profile/model/blood_group_response.dart';
import 'package:gro_one_app/features/profile/model/delete_account_response.dart';
import 'package:gro_one_app/features/profile/model/issue_category_response.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';
import 'package:gro_one_app/features/profile/model/ticket_message_response.dart';
import 'package:gro_one_app/features/profile/model/upload_ticket_response.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/create_ticket_request.dart';
import 'package:gro_one_app/features/profile/api_request/delete_vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/driver_request.dart';
import 'package:gro_one_app/features/profile/api_request/ticket_request.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/features/profile/model/blue_membership_response.dart';
import 'package:gro_one_app/features/profile/model/customer_settings_response.dart';
import 'package:gro_one_app/features/profile/model/faq_response.dart';
import 'package:gro_one_app/features/profile/model/driver_list_response.dart';
import 'package:gro_one_app/features/profile/model/driver_new_response.dart';
import 'package:gro_one_app/features/profile/model/kyc_document_response.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/primart_address_response.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/settings_response.dart';
import 'package:gro_one_app/features/profile/model/ticket_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_new_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_updated_status_model.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import '../../../load_provider/lp_loads/model/lp_load_get_by_id_response.dart' hide CustomerAddress;
part 'profile_state.dart';

enum TicketStatus { pending, completed }

class ProfileCubit extends BaseCubit<ProfileState> {
  final ProfileRepository _repo;
  final LpHomeRepository _lpHomeRepository;
  final LpLoadRepository _lpLoadRepository;
  final KavachRepository kavachRepository;

  ProfileCubit(this._repo, this._lpHomeRepository, this._lpLoadRepository, this.kavachRepository)
    : super(ProfileState());

  // Save Has Blue ID
  Future<void> saveHasShowBluePopup(bool value) async {
    await _repo.saveHasShowBluePopup(value);
  }

  // Get Show Blue Popup
  Future<bool> getHasShowBluePopup() async {
    return await _repo.getHasShowBluePopup();
  }

  // Kyc Timer
  Future<void> startKycSuccessTimer(bool value) async {
    emit(state.copyWith(showSuccessKyc: value));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(showSuccessKyc: value));
  }

  // Get Blue Id
  Future<String?> fetchBlueId() async {
    Result<String> getBlueId = await _repo.getBlueId();
    if (getBlueId is Success<String>) {
      emit(state.copyWith(blueId: getBlueId.value));
      return getBlueId.value;
    } else {
      return null;
    }
  }

  // fetch company Type Id
  String? companyTypeId;
  Future<String?> fetchCompanyTypeId() async {
    companyTypeId = await _repo.getCustomerTypeId();
    CustomLog.debug(this, "Store Company Type Id: $companyTypeId");
    return companyTypeId;
  }

  // Get User Role
  int? userRole;
  Future<int?> fetchUserRole() async {
    userRole = await _repo.getUserRole();
    CustomLog.debug(this, "User Role Type : $userRole");
    return userRole;
  }



  // Get User Id
  String? userId;
  Future<String?> fetchUserId() async {
    userId = await _repo.getUserId();
    CustomLog.debug(this, "User Id : $userId");
    return userId;
  }

  void switchToVp(bool value){
    emit(state.copyWith(switchToVp: value));
  }

  // Fetch Profile Detail Api Call
  void _setProfileDetailUIState(UIState<ProfileDetailModel>? uiState) {
    emit(state.copyWith(profileDetailUIState: uiState));
  }

  Future<void> fetchProfileDetail({Object? instance}) async {
    userId = await _repo.getUserId();
    CustomLog.debug(
      instance ?? this,
      "Profile Detail Api Call : UserId $userId",
    );
    if (userId == null) {
      return;
    }
    _setProfileDetailUIState(UIState.loading());
    dynamic result = await _repo.getUserDetails();
    if (result is Success<ProfileDetailModel>) {
      _setProfileDetailUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setProfileDetailUIState(UIState.error(result.type));
    }
  }

  // Logout Api Call
  void _setLogoutUIState(UIState<LogOutModel>? uiState) {
    emit(state.copyWith(logoutUIState: uiState));
  }

  Future<void> logout() async {
    _setLogoutUIState(UIState.loading());
    dynamic result = await _repo.getLogOutData();
    dynamic isSignOut = await _repo.signOut();
    if (result is Success<LogOutModel> && isSignOut is Success<bool>) {
      _setLogoutUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setLogoutUIState(UIState.error(result.type));
    }
  }

  /// Set Delete Account UI State
  void _setDeleteAccountUIState(UIState<DeleteAccountModel>? uiState) {
    emit(state.copyWith(deleteAccountUIState: uiState));
  }

  Future<void> deleteAccount() async {
    _setDeleteAccountUIState(UIState.loading());
    final result = await _repo.deleteAccount();
    final isSignOut = await _repo.signOut();

    if (result is Success<DeleteAccountModel> && isSignOut is Success<bool>) {
      _setDeleteAccountUIState(UIState.success(result.value));
    }
    else if (result is Error<DeleteAccountModel>) {
      _setDeleteAccountUIState(UIState.error(result.type));
    } else {
      _setDeleteAccountUIState(UIState.error(GenericError()));
    }
  }

  // Fetch Document from api call
  void _setFetchDocumentUIState(UIState<KycDocumentResponse>? uiState) {
    emit(state.copyWith(documentState: uiState));
  }

  Future<void> fetchDocuments() async {
    _setFetchDocumentUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchDocuments(userId: userId ?? '');
    if (result is Success<KycDocumentResponse>) {
      _setFetchDocumentUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchDocumentUIState(UIState.error(result.type));
    }
  }

  // Fetch Membership Benefit from api call
  void _setMembershipBenefitUIState(UIState<BlueMemberShipResponse>? uiState) {
    emit(state.copyWith(memberShipState: uiState));
  }

  Future<void> fetchMembershipBenefit() async {
    _setMembershipBenefitUIState(UIState.loading());

    dynamic result = await _repo.fetchMembershipBenefit();
    if (result is Success<BlueMemberShipResponse>) {
      _setMembershipBenefitUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setMembershipBenefitUIState(UIState.error(result.type));
    }
  }



  // Address pagination state
  int _addressCurrentPage = 1;
  bool _addressIsLastPage = false;
  bool _addressIsLoadingMore = false;

  void _setFetchAddressUIState(UIState<PaginatedAddressList>? uiState) {
    emit(state.copyWith(addressState: uiState));
  }

  Future<void> fetchAddress({
    bool isLoading = true,
    String? search,
    bool loadMore = false,
  }) async {
    if (_addressIsLoadingMore && loadMore) return;
    if (!loadMore) {
      _addressIsLastPage = false;
    } else if (_addressIsLastPage) {
      return;
    }

    if (loadMore) {
      _addressIsLoadingMore = true;
      _addressCurrentPage++;
    } else {
      _addressCurrentPage = 1;
      _addressIsLastPage = false;
      if (isLoading) _setFetchAddressUIState(UIState.loading());
    }

    try {
      userId = await _repo.getUserId();
      final result = await _repo.fetchAddress(
        userId: userId ?? '',
        search: search,
        currentPage: _addressCurrentPage,
      );

      if (result is Success<PaginatedAddressList>) {
        final newList = result.value.addresses;

        if (loadMore) {
          final existing = state.addressState?.data?.addresses ?? [];
          final combined = [...existing, ...newList];
          _setFetchAddressUIState(
            UIState.success(result.value.copyWith(addresses: combined)),
          );
        } else {
          _setFetchAddressUIState(UIState.success(result.value));
        }
        _addressIsLastPage = (state.addressState?.data?.addresses.length ?? 0) >= result.value.total;
      } else if (result is Error<PaginatedAddressList>) {
        _setFetchAddressUIState(UIState.error(result.type));
      }
    } finally {
      _addressIsLoadingMore = false;
    }
  }


  // Fetch address from api call
  void _setPrimaryAddressUIState(UIState<SetPrimaryAddressResponse>? uiState) {
    emit(state.copyWith(primaryAddressState: uiState));
  }

  Future<void> setPrimaryAddress({required String addressId}) async {
    dynamic result = await _repo.setPrimaryAddress(addressId: addressId);
    if (result is Success<SetPrimaryAddressResponse>) {
      _setPrimaryAddressUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setPrimaryAddressUIState(UIState.error(result.type));
    }
  }

  // Fetch address from api call
  void _setCreateAddressUIState(UIState<CustomerAddress>? uiState) {
    emit(state.copyWith(createAddressState: uiState));
  }

  Future<void> createAddress({required AddressRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.createAddress(
      request: request.copyWith(customerId: userId),
    );
    if (result is Success<CustomerAddress>) {
      _setCreateAddressUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateAddressUIState(UIState.error(result.type));
    }
  }

  Future<void> updateAddress({
    required String addressId,
    required AddressRequest request,
  }) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateAddress(
      addressId: addressId,
      request: request.copyWith(customerId: userId),
    );
    if (result is Success<CustomerAddress>) {
      _setCreateAddressUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateAddressUIState(UIState.error(result.type));
    }
  }

  Future<Result<void>> deleteAddress({required String addressId}) async {
    Result<void> result = await _repo.deleteAddress(addressId: addressId);

    if (result is Success) {
      fetchAddress(isLoading: false);
    } else if (result is Error) {
      _setFetchAddressUIState(UIState.error(result.type),);
    }
    return result;
  }

  // Fetch settings from api call
  void _setSettingsUIState(UIState<List<SettingsResponse>>? uiState) {
    emit(state.copyWith(settingsState: uiState));
  }

  Future<void> fetchSettings() async {
    dynamic result = await _repo.fetchSettings();
    if (result is Success<List<SettingsResponse>>) {
      _setSettingsUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setSettingsUIState(UIState.error(result.type));
    }
  }

  // Fetch address from api call
  void _setCustomerSettingsUIState(UIState<CustomerSettingsResponse>? uiState) {
    emit(state.copyWith(customerSettingsState: uiState));
  }

  Future<void> fetchCustomerSettings() async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchCustomerSettings(userId: userId ?? '');
    if (result is Success<CustomerSettingsResponse>) {
      _setCustomerSettingsUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCustomerSettingsUIState(UIState.error(result.type));
    }
  }

  // Create New vehicle from api call
  void _setCreateVehicleUIState(UIState<VehicleNewModel>? uiState) {
    emit(state.copyWith(createVehicleState: uiState));
  }

  Future<void> createVehicle({required VehicleRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.createVehicle(
      request: request.copyWith(customerId: userId),
    );
    if (result is Success<VehicleNewModel>) {
      _setCreateVehicleUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateVehicleUIState(UIState.error(result.type));
    }
  }

  // Update Vehicle
  Future<void> updateVehicle({
    required String vehicleId,
    required VehicleRequest request,
  }) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateVehicle(
      vehicleId: vehicleId,
      request: request.copyWith(customerId: userId),
    );
    if (result is Success<VehicleNewModel>) {
      _setCreateVehicleUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateVehicleUIState(UIState.error(result.type));
    }
  }

  // Fetch deriver from api call
  void _setFetchVehicleUIState(UIState<PaginatedVehicleList>? uiState) {
    emit(state.copyWith(vehicleState: uiState));
  }

  int _currentVehiclePage = 1;
  bool _isLastVehiclePage = false;
  bool _isVehicleLoadingMore = false;
  Future<void> fetchVehicle({
    bool isLoading = true,
    String? search,
    bool loadMore = false,
  }) async {
    if (_isVehicleLoadingMore && loadMore) return;
    if (!loadMore) {
      _isLastVehiclePage = false;
    } else if (_isLastVehiclePage) {
      return;
    }

    if (loadMore) {
      _isVehicleLoadingMore = true;
      _currentVehiclePage++;
    } else {
      _currentVehiclePage = 1;
      _isLastVehiclePage = false;
      if (isLoading) _setFetchVehicleUIState(UIState.loading());
    }

    try {
      userId = await _repo.getUserId();
      final result = await _repo.fetchVehicle(
        userId: userId ?? '',
        search: search,
        page: _currentVehiclePage,
        limit: 10,
      );

      if (result is Success<PaginatedVehicleList>) {
        final newList = result.value.data;
        if (loadMore) {
          final existing = state.vehicleState?.data?.data ?? [];
          final combined = [...existing, ...newList];
          _setFetchVehicleUIState(
            UIState.success(result.value.copyWith(data: combined)),
          );
        } else {
          _setFetchVehicleUIState(UIState.success(result.value));
        }
        _isLastVehiclePage =
            result.value.pageMeta?.nextPage == null ||
            result.value.pageMeta?.pageCount == _currentVehiclePage;
      } else if (result is Error<PaginatedVehicleList>) {
        _setFetchVehicleUIState(UIState.error(result.type));
      }
    } finally {
      _isVehicleLoadingMore = false;
    }
  }

  // Fetch Truck type Api Call
  void _setTruckTypeUIState(UIState<List<LoadTruckTypeListModel>>? uiState) {
    emit(state.copyWith(truckTypeUIState: uiState));
  }

  Future<void> fetchTruckType() async {
    _setTruckTypeUIState(UIState.loading());
    Result result = await _lpHomeRepository.getTruckTypeData();
    if (result is Success<List<LoadTruckTypeListModel>>) {
      _setTruckTypeUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setTruckTypeUIState(UIState.error(result.type));
    }
  }

  // Fetch truck length
  Future<void> fetchTruckLengths(String type) async {
    emit(state.copyWith(truckTypeUIState: UIState.loading()));
    final result = await kavachRepository.fetchTruckLengths(type);
    if (result is Success<List<TruckLengthModel>>) {
      emit(state.copyWith(truckLengths: UIState.success(result.value)));
    } else if (result is Error<List<TruckLengthModel>>) {
      emit(state.copyWith(truckLengths: UIState.error(result.type)));
    } else {
      emit(state.copyWith(truckLengths: UIState.error(GenericError())));
    }
  }

  // Delete Vehicle
  Future<Result<void>> deleteVehicle({
    required String vehicleId,
    required DeleteVehicleRequest request,
  }) async {
    Result<void> result = await _repo.deleteVehicle(
      vehicleId: vehicleId,
      request: request,
    );

    if (result is Success) {
      fetchVehicle(isLoading: false);
    } else if (result is Error) {
      _setFetchVehicleUIState(UIState.error(result.type));
    }
    return result;
  }

  //   // Update vehicle status from api call
  void _setUpdateVehicleStatusUIState(
    UIState<VehcileUpdatedStatusModel>? uiState,
  ) {
    emit(state.copyWith(vehicleStatusUpdate: uiState));
  }

  Future<void> vehicleupdateStatus({
    bool isLoading = true,
    String? vehicleId,
    required VehicleStatusUpdateRequest request,
  }) async {
    if (isLoading) _setUpdateVehicleStatusUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateVehicleStatus(
      request: request,
      vehicleId: vehicleId ?? "",
    );
    if (result is Success<VehcileUpdatedStatusModel>) {
      _setUpdateVehicleStatusUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUpdateVehicleStatusUIState(UIState.error(result.type));
    }
  }

  // Create New driver from api call
  void _setCreateDriverUIState(UIState<DriverNewModel>? uiState) {
    emit(state.copyWith(createDriverState: uiState));
  }

  Future<void> createDriver({required DriverRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.createDriver(request: request);
    if (result is Success<DriverNewModel>) {
      _setCreateDriverUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateDriverUIState(UIState.error(result.type));
    }
  }

  // Update Driver
  Future<void> updateDriver({
    required String driverId,
    required DriverRequest request,
  }) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateDriver(
      driverId: driverId,
      request: request.copyWith(customerId: userId),
    );
    if (result is Success<DriverNewModel>) {
      _setCreateDriverUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateDriverUIState(UIState.error(result.type));
    }
  }

  // Fetch deriver from api call
  void _setFetchDriverUIState(UIState<PaginatedDriverList>? uiState) {
    emit(state.copyWith(driverState: uiState));
  }

  int _driverscurrentPage = 1;
  bool _driversisLastPage = false;
  bool _driversisLoadingMore = false;

  Future<void> fetchDriver({
    bool isLoading = true,
    String? search,
    bool loadMore = false,
  }) async {
    if (_driversisLoadingMore && loadMore) return;
    if (!loadMore) {
      _driversisLastPage = false;
    } else if (_driversisLastPage) {
      return;
    }

    if (_driversisLastPage) return;

    if (loadMore) {
      _driversisLoadingMore = true;
      _driverscurrentPage++;
    } else {
      _driverscurrentPage = 1;
      _driversisLastPage = false;
      if (isLoading) _setFetchDriverUIState(UIState.loading());
    }

    try {
      userId = await _repo.getUserId();
      final result = await _repo.fetchDriver(
        userId: userId ?? '',
        search: search,
        page: _driverscurrentPage,
        limit: 10,
      );

      if (result is Success<PaginatedDriverList>) {
        final newList = result.value.data;
        if (loadMore) {
          final existing = state.driverState?.data?.data ?? [];
          final combined = [...existing, ...newList];
          _setFetchDriverUIState(
            UIState.success(result.value.copyWith(data: combined)),
          );
        } else {
          _setFetchDriverUIState(UIState.success(result.value));
        }
        _driversisLastPage =
            result.value.pageMeta?.nextPage == null ||
            result.value.pageMeta?.pageCount == _currentVehiclePage;
      } else if (result is Error<PaginatedDriverList>) {
        _setFetchDriverUIState(UIState.error(result.type));
      }
    } finally {
      _driversisLoadingMore = false;
    }
  }

  Future<Result<void>> deleteDriver({required String driverId}) async {
    Result<void> result = await _repo.deleteDriver(driverId: driverId);

    if (result is Success) {
      fetchDriver(isLoading: false);
    } else if (result is Error) {
      _setFetchDriverUIState(UIState.error(result.type));
    }
    return result;
  }

  Future<Result<void>> updateCustomerSettings({
    required UpdateSettingsRequest request,
  }) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateCustomerSettings(
      userId: userId ?? '',
      request: request,
    );

    if (result is Success) {
      fetchCustomerSettings();
    } else if (result is Error) {
      _setFetchAddressUIState(UIState.error(result.type));
    }
    return result;
  }

  Future<void> uploadVehicleDoc(File file) async {
    emit(state.copyWith(vehicleDocUpload: UIState.loading()));
    final result = await kavachRepository.getUploadGstData(file);
    if (result is Success<KavachVehicleDocumentUploadModel>) {
      emit(state.copyWith(vehicleDocUpload: UIState.success(result.value)));
    } else if (result is Error<KavachVehicleDocumentUploadModel>) {
      emit(state.copyWith(vehicleDocUpload: UIState.error(result.type)));
    } else {
      emit(state.copyWith(vehicleDocUpload: UIState.error(GenericError())));
    }
  }

  Future<void> uploadLicenseDoc(File file) async {
    emit(state.copyWith(licenseDocUpload: UIState.loading()));
    final result = await _repo.getUploadLicenseData(file);
    if (result is Success<KavachVehicleDocumentUploadModel>) {
      emit(state.copyWith(licenseDocUpload: UIState.success(result.value)));
    } else if (result is Error<KavachVehicleDocumentUploadModel>) {
      emit(state.copyWith(licenseDocUpload: UIState.error(result.type)));
    } else {
      emit(state.copyWith(licenseDocUpload: UIState.error(GenericError())));
    }
  }

  // Fetch address from api call
  void _setFetchFaqUIState(UIState<FaqResponse>? uiState) {
    emit(state.copyWith(faqUIState: uiState));
  }

  // FAQ pagination variables
  int _faqCurrentPage = 1;
  bool _faqIsLastPage = false;
  bool _faqIsLoadingMore = false;

  Future<void> fetchFaq({
    bool isLoading = true,
    String? search,
    bool loadMore = false,
    int limit = 10,
  }) async {
    // Prevent multiple parallel calls for load more
    if (_faqIsLoadingMore && loadMore) return;

    // Reset when fresh load
    if (!loadMore) {
      _faqIsLastPage = false;
    } else if (_faqIsLastPage) {
      return;
    }

    if (loadMore) {
      _faqIsLoadingMore = true;
      _faqCurrentPage++;
    } else {
      _faqCurrentPage = 1;
      _faqIsLastPage = false;
      if (isLoading) _setFetchFaqUIState(UIState.loading());
    }

    try {
      final result = await _repo.fetchFaq(
        search: search,
        page: _faqCurrentPage,
        limit: limit,
      );

      if (result is Success<FaqResponse>) {
        final newFaqResponse = result.value;
        final newFaqList = newFaqResponse.data?.data ?? [];

        if (loadMore) {
          final existing = state.faqUIState?.data?.data?.data ?? [];
          final combined = [...existing, ...newFaqList];

          final updatedData = newFaqResponse.data?.copyWith(data: combined);

          _setFetchFaqUIState(
            UIState.success(newFaqResponse.copyWith(data: updatedData)),
          );
        } else {
          _setFetchFaqUIState(UIState.success(newFaqResponse));
        }

        _faqIsLastPage = newFaqResponse.data?.pageMeta?.nextPage == null;
      } else if (result is Error<FaqResponse>) {
        _setFetchFaqUIState(UIState.error(result.type));
      }
    } finally {
      _faqIsLoadingMore = false;
    }
  }

  // Fetch Blood Group from api call
  void _setFetchBloodGroupUIState(
    UIState<List<BloodGroupResponseModel>>? uiState,
  ) {
    emit(state.copyWith(bloodGroupResponseUIState: uiState));
  }

  Future<void> fetchBloodGroup({bool isLoading = true, String? search}) async {
    if (isLoading) _setFetchBloodGroupUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchBloodGroup();
    if (result is Success<List<BloodGroupResponseModel>>) {
      _setFetchBloodGroupUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchBloodGroupUIState(UIState.error(result.type));
    }
  }
  
  /// Fetch Issue category Group from api call
  void _setFetchIssueCategoryGroupUIState(
    UIState<List<IssueCategoryResponse>>? uiState,
  ) {
    print("data emitted from cubit ${uiState?.data?.length}");
    emit(state.copyWith(issueCategoryResponseUIState: uiState));
  }

  Future<void> fetchIssueCategoryGroup({bool isLoading = true, String? search}) async {
    if (isLoading) _setFetchIssueCategoryGroupUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchIssueCategoryGroups();
    if (result is Success<List<IssueCategoryResponse>>) {
      _setFetchIssueCategoryGroupUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchIssueCategoryGroupUIState(UIState.error(result.type));
    }
  }

  // Fetch Licnese category from api call
  void _setFetchLicneseUIState(
    UIState<List<LicenseCategoryResponseModel>>? uiState,
  ) {
    emit(state.copyWith(licneseCategoryResponseUIState: uiState));
  }

  Future<void> fetchLicenseCategory({
    bool isLoading = true,
    String? search,
  }) async {
    if (isLoading) _setFetchLicneseUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchLicenseCategory();
    if (result is Success<List<LicenseCategoryResponseModel>>) {
      _setFetchLicneseUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchLicneseUIState(UIState.error(result.type));
    }
  }

  // Fetch tickets from api call
  void _setTicketsUIState(UIState<TicketResponse>? uiState) {
    emit(state.copyWith(ticketState: uiState));
  }

  // Tickets pagination variables
  int _ticketCurrentPage = 1;
  bool _ticketIsLastPage = false;
  bool _ticketIsLoadingMore = false;

  Future<void> fetchTickets({
    required TicketRequest request,
    bool isLoading = true,
    bool loadMore = false,
    int limit = 10,
  }) async {
    // Prevent multiple parallel calls when loading more
    if (_ticketIsLoadingMore && loadMore) return;

    // Reset when fresh load
    if (!loadMore) {
      _ticketIsLastPage = false;
    } else if (_ticketIsLastPage) {
      return;
    }

    if (loadMore) {
      _ticketIsLoadingMore = true;
      _ticketCurrentPage++;
    } else {
      _ticketCurrentPage = 1;
      _ticketIsLastPage = false;
      if (isLoading) _setTicketsUIState(UIState.loading());
    }

    try {
      userId = await _repo.getUserId();

      final result = await _repo.fetchTickets(
        userId: userId ?? '',
        request: request.copyWith(page: _ticketCurrentPage, limit: limit),
      );

      if (result is Success<TicketResponse>) {
        final newResponse = result.value;
        final newTickets = newResponse.data;

        if (loadMore) {
          final existing = state.ticketState?.data?.data ?? [];
          final combined = [...existing, ...newTickets];

          _setTicketsUIState(
            UIState.success(newResponse.copyWith(data: combined)),
          );
        } else {
          _setTicketsUIState(UIState.success(newResponse));
        }
        _ticketIsLastPage = newResponse.pageMeta?.nextPage == null;
      } else if (result is Error<TicketResponse>) {
        _setTicketsUIState(UIState.error(result.type));
      }
    } finally {
      _ticketIsLoadingMore = false;
    }
  }

  // create ticket from api call
  void _setCreateTicketsUIState(UIState<Ticket>? uiState) {
    emit(state.copyWith(createTicketState: uiState));
  }

  Future<void> createTicket({required CreateTicketRequest request}) async {
    _setCreateTicketsUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.createTicket(
      request: request.copyWith(customerId: userId),
    );
    if (result is Success<Ticket>) {
      _setCreateTicketsUIState(UIState.success(result.value));
      fetchTickets(request: TicketRequest());
    }
    if (result is Error) {
      _setCreateTicketsUIState(UIState.error(result.type));
    }
  }

  // create ticket from api call
  void _setTicketMessageUIState(UIState<List<TicketMessageResponse>>? uiState) {
    emit(state.copyWith(ticketMessageState: uiState));
  }

  Future<void> fetchTicketMessages({required String ticketId, String? docId}) async {
    _setTicketMessageUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchTicketMessages(ticketId: ticketId);
    if (result is Success<List<TicketMessageResponse>>) {
      _setTicketMessageUIState(UIState.success(result.value));
      fetchTickets(request: TicketRequest());
      if(docId != '') {
        getDocumentById(docId: docId ?? '');
      }
    }
    if (result is Error) {
      _setTicketMessageUIState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to Document by ID.
  void _setDocumentByIdState(UIState<DocumentDetails>? uiState) {
    emit(state.copyWith(documentById: uiState));
  }

  // load Document by ID
  Future<void> getDocumentById({required String docId}) async {
    _setDocumentByIdState(UIState.loading());

    Result result = await _lpLoadRepository.getDocumentById(docId: docId);

    if (result is Success<DocumentDetails>) {
      _setDocumentByIdState(UIState.success(result.value));
    } else if (result is Error) {
      _setDocumentByIdState(UIState.error(result.type));
    }

  }

  void updateTempTicketStatus(TicketStatus? status) {
    emit(state.copyWith(tempSelectedTicketStatus: status));
  }

  void applyTicketStatusFilter() {
    emit(state.copyWith(selectedTicketStatus: state.tempSelectedTicketStatus));
    fetchTickets(
      request: TicketRequest(
        ticketStatus:
            state.tempSelectedTicketStatus == TicketStatus.pending ? '1' : '2',
      ),
    );
  }

  void clearTicketStatusFilter() {
    emit(
      state.copyWith(
        selectedTicketStatus: null,
        tempSelectedTicketStatus: null,
      ),
    );
    fetchTickets(request: TicketRequest());
  }

  // // Upload Ticket File
  void _setUploadTicketUIState(UIState<UploadTicketResponse>? uiState) {
    emit(state.copyWith(uploadTicketDocUIState: uiState));
  }

  Future<void> uploadTicketDoc(File file) async {
    _setUploadTicketUIState(UIState.loading());
    Result result = await _repo.getUploadTicketData(file);
    if (result is Success<UploadTicketResponse>) {
      _setUploadTicketUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadTicketUIState(UIState.error(result.type));
    }
  }

  // Create Document
  void _setCreateDocumentUIState(UIState<CreateDocumentModel>? uiState) {
    emit(state.copyWith(createDocumentUIState: uiState));
  }

  Future<void> createDocument(CreateDocumentApiRequest request) async {
    _setCreateDocumentUIState(UIState.loading());
    Result result = await _repo.getCreateDocumentData(request);
    if (result is Success<CreateDocumentModel>) {
      _setCreateDocumentUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateDocumentUIState(UIState.error(result.type));
    }
  }

  // Reset State
  void resetState() {
    emit(
      state.copyWith(
        logoutUIState: resetUIState<LogOutModel>(state.logoutUIState),
        deleteAccountUIState: resetUIState(state.deleteAccountUIState),
        profileDetailUIState: resetUIState<ProfileDetailModel>(
          state.profileDetailUIState,
        ),
      ),
    );
  }

  void resetLogoutUIState() {
    emit(
      state.copyWith(
        logoutUIState: resetUIState<LogOutModel>(state.logoutUIState),
      ),
    );
  }
}
