import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/kavach/model/kavach_truck_length_model.dart';
import 'package:gro_one_app/features/kavach/repository/kavach_repository.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/features/profile/model/blue_membership_response.dart';
import 'package:gro_one_app/features/profile/model/customer_settings_response.dart';
import 'package:gro_one_app/features/profile/model/driver_list_response.dart';
import 'package:gro_one_app/features/profile/model/kyc_document_response.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/primart_address_response.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_new_response.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';
part 'profile_state.dart';

class ProfileCubit extends BaseCubit<ProfileState> {
  final ProfileRepository _repo;
  final VpCreationRepository _vprepository;
  final KavachRepository kavachRepository;
  ProfileCubit(this._repo,this._vprepository,this.kavachRepository): super(ProfileState());

  // Save Has Blue ID
  Future<void> saveHasShowBluePopup(bool value) async {
    await _repo.saveHasShowBluePopup(value);
  }

  // Get Show Blue Popup
  Future<bool> getHasShowBluePopup() async {
    return  await _repo.getHasShowBluePopup();
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


  // Fetch Profile Detail Api Call
  void _setProfileDetailUIState(UIState<ProfileDetailModel>? uiState){
    emit(state.copyWith(profileDetailUIState: uiState));
  }
  Future<void> fetchProfileDetail({Object? instance}) async {
    userId = await _repo.getUserId();
    CustomLog.debug(instance ?? this, "Profile Detail Api Call : UserId $userId");
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
  void _setLogoutUIState(UIState<LogOutModel>? uiState){
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

  // Fetch Document from api call
  void _setFetchDocumentUIState(UIState<KycDocumentResponse>? uiState){
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
  void _setMembershipBenefitUIState(UIState<BlueMemberShipResponse>? uiState){
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

  // Fetch address from api call
  void _setFetchAddressUIState(UIState<PaginatedAddressList>? uiState){
    emit(state.copyWith(addressState: uiState));
  }

  Future<void> fetchAddress({bool isLoading = true}) async {
    if(isLoading) _setFetchAddressUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchAddress(userId: userId ?? '');
    if (result is Success<PaginatedAddressList>) {
      _setFetchAddressUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchAddressUIState(UIState.error(result.type));
    }
  }

  // Fetch address from api call
  void _setPrimaryAddressUIState(UIState<SetPrimaryAddressResponse>? uiState){
    emit(state.copyWith(primaryAddressState: uiState));
  }

  Future<void> setPrimaryAddress({required String addressId}) async {

    dynamic result = await _repo.setPrimaryAddress(addressId: addressId ?? '');
    if (result is Success<SetPrimaryAddressResponse>) {
      _setPrimaryAddressUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setPrimaryAddressUIState(UIState.error(result.type));
    }
  }

  // Fetch address from api call
  void _setCreateAddressUIState(UIState<CustomerAddress>? uiState){
    emit(state.copyWith(createAddressState: uiState));
  }

  Future<void> createAddress({required AddressRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.createAddress(request: request.copyWith(customerId: userId));
    if (result is Success<CustomerAddress>) {
      _setCreateAddressUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateAddressUIState(UIState.error(result.type));
    }
  }

  Future<void> updateAddress({required String addressId, required AddressRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateAddress(addressId: addressId,request: request.copyWith(customerId: userId));
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
      _setFetchAddressUIState(UIState.error(result.type));
    }
     return result;
  }

  // Fetch address from api call
  void _setCustomerSettingsUIState(UIState<CustomerSettingsResponse>? uiState){
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
 
    // Fetch address from api call
  void _setCreateVehicleUIState(UIState<VehicleNewModel>? uiState){
    emit(state.copyWith(createVehicleState: uiState));
  }

  Future<void> createVehicle({required VehicleRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.createVehicle(request: request.copyWith(customerId: userId));
    if (result is Success<VehicleNewModel>) {
      _setCreateVehicleUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateVehicleUIState(UIState.error(result.type));
    }
  }

   // Fetch vehicle from api call
  void _setFetchVehicleUIState(UIState<PaginatedVehicleList>? uiState){
    emit(state.copyWith(vehicleState: uiState));
  }

  Future<void> fetchVehicle({bool isLoading = true}) async {
    if(isLoading) _setFetchVehicleUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchVehicle(userId: userId ?? '');
    if (result is Success<PaginatedVehicleList>) {
      _setFetchVehicleUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchVehicleUIState(UIState.error(result.type));
    }
  }

   // Fetch Truck type Api Call
  void _setTruckTypeUIState(UIState<List<TruckTypeModel>>? uiState){
    emit(state.copyWith(truckTypeUIState: uiState));
  }
  Future<void> fetchTruckType() async {
    _setTruckTypeUIState(UIState.loading());
    Result result = await _vprepository.getTruckTypeData();
    if (result is Success<List<TruckTypeModel>>) {
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


  Future<Result<void>> deleteVehicle({required String vehicleId}) async {

    Result<void> result = await _repo.deleteVehicle(vehicleId: vehicleId);

    if (result is Success) {
      fetchVehicle(isLoading: false);
    } else if (result is Error) {
      _setFetchVehicleUIState(UIState.error(result.type));
    }
     return result;
  }




  // Fetch deriver from api call
  void _setFetchDriverUIState(UIState<PaginatedDriverList>? uiState){
    emit(state.copyWith(driverState: uiState));
  }

 
  Future<void> fetchDriver({bool isLoading = true}) async {
    if(isLoading) _setFetchDriverUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchDriver(userId: userId ?? '');
    if (result is Success<PaginatedDriverList>) {
      _setFetchDriverUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchDriverUIState(UIState.error(result.type));
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

  Future<Result<void>> updateCustomerSettings({required UpdateSettingsRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateCustomerSettings(userId: userId ?? '', request: request);

    if (result is Success) {
      fetchCustomerSettings();
    } else if (result is Error) {
      _setFetchAddressUIState(UIState.error(result.type));
    }
     return result;
  }


  // Reset State
  void resetState(){
    emit(state.copyWith(
      logoutUIState: resetUIState<LogOutModel>(state.logoutUIState),
      profileDetailUIState: resetUIState<ProfileDetailModel>(state.profileDetailUIState),
    ));
  }

  void resetLogoutUIState(){
    emit(state.copyWith(
      logoutUIState: resetUIState<LogOutModel>(state.logoutUIState),
    ));
  }




}
