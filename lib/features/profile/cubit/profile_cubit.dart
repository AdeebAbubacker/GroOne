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
import 'package:gro_one_app/features/profile/api_request/vehicle_status_update_request.dart';
import 'package:gro_one_app/features/profile/model/upload_ticket_response.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/create_ticket_request.dart';
import 'package:gro_one_app/features/profile/api_request/delete_vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/driver_request.dart';
import 'package:gro_one_app/features/profile/api_request/license_vahan_request.dart';
import 'package:gro_one_app/features/profile/api_request/ticket_request.dart';
import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_vahan_request.dart';
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
import 'package:gro_one_app/features/profile/model/vehicle_verification_success.dart';
import 'package:gro_one_app/features/profile/model/verified_license_vahan_response.dart';
import 'package:gro_one_app/features/profile/model/verified_vehicle_vahan_response.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';
part 'profile_state.dart';

enum TicketStatus { pending, completed }

class ProfileCubit extends BaseCubit<ProfileState> {
  final ProfileRepository _repo;
  final VpCreationRepository _vprepository;
  final LpHomeRepository _lpHomeRepository;
  final KavachRepository kavachRepository;
  ProfileCubit(this._repo,this._vprepository,this._lpHomeRepository,this.kavachRepository): super(ProfileState());

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

  Future<void> fetchAddress({bool isLoading = true,String? search}) async {
    if(isLoading) _setFetchAddressUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchAddress(userId: userId ?? '',search: search);
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

  // Fetch settings from api call
  void _setSettingsUIState(UIState<List<SettingsResponse>>? uiState){
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
 
  // Check Vehicle Excistence
  void _setCheckVehicleExcistence(UIState<VehicleVerificationSuccess>? uiState){
    emit(state.copyWith(vehicleVerificationState: uiState));
  }

  Future<void> fetchVehicleExcistence({required String vehicleId}) async {
    _setCheckVehicleExcistence(UIState.loading());

    dynamic result = await _repo.fetchVehicleVerification(vehicleId: vehicleId);
    if (result is Success<VehicleVerificationSuccess>) {
      print("Vehicle already excist");
      _setCheckVehicleExcistence(UIState.success(result.value));
    }
    if (result is Error) {
      print("Vehicle not found excist");
      _setCheckVehicleExcistence(UIState.error(result.type));
    }
  }

   // Check License Excistence
  void _setCheckLicenseExcistence(UIState<LicenseVerificationSuccess>? uiState){
    emit(state.copyWith(licenseVerficationState: uiState));
  }
   Future<void> fetchLicenseExcistence({required String licenseNo}) async {
    _setCheckLicenseExcistence(UIState.loading());

    dynamic result = await _repo.fetchLicenseVerification(licenseNo: licenseNo);
    if (result is Success<LicenseVerificationSuccess>) {
      _setCheckLicenseExcistence(UIState.success(result.value));
    }
    if (result is Error) {
      _setCheckLicenseExcistence(UIState.error(result.type));
    }
  }

    // Create New vehicle from api call
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

   // Update Vehicle
  Future<void> updateVehicle({required String vehicleId, required VehicleRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateVehicle(vehicleId: vehicleId,request: request.copyWith(customerId: userId));
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

  Future<void> fetchVehicle({bool isLoading = true,String? search}) async {
    if(isLoading) _setFetchVehicleUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchVehicle(userId: userId ?? '',search: search);
    if (result is Success<PaginatedVehicleList>) {
      _setFetchVehicleUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchVehicleUIState(UIState.error(result.type));
    }
  }

   // Fetch Truck type Api Call
  void _setTruckTypeUIState(UIState<List<LoadTruckTypeListModel>>? uiState){
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


  Future<Result<void>> deleteVehicle({required String vehicleId, required DeleteVehicleRequest request}) async {

    Result<void> result = await _repo.deleteVehicle(vehicleId: vehicleId,request: request);

    if (result is Success) {
      fetchVehicle(isLoading: false);
    } else if (result is Error) {
      _setFetchVehicleUIState(UIState.error(result.type));
    }
     return result;
  }
  
  //   // Update vehicle status from api call
  void _setUpdateVehicleStatusUIState(UIState<VehcileUpdatedStatusModel>? uiState){
    emit(state.copyWith(vehicleStatusUpdate: uiState));
  }

  Future<void> vehicleupdateStatus({bool isLoading = true,String? vehicleId,required VehicleStatusUpdateRequest request}) async {
    if(isLoading) _setUpdateVehicleStatusUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateVehicleStatus(request: request, vehicleId: vehicleId ??"");
    if (result is Success<VehcileUpdatedStatusModel>) {
      _setUpdateVehicleStatusUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUpdateVehicleStatusUIState(UIState.error(result.type));
    }
  }

    // Create New driver from api call
  void _setCreateDriverUIState(UIState<DriverNewModel>? uiState){
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
  Future<void> updateDriver({required String driverId, required DriverRequest request}) async {
    userId = await _repo.getUserId();

    dynamic result = await _repo.updateDriver(driverId: driverId,request: request.copyWith(customerId: userId));
    if (result is Success<DriverNewModel>) {
      _setCreateDriverUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateDriverUIState(UIState.error(result.type));
    }
  }
 
  // Fetch deriver from api call
  void _setFetchDriverUIState(UIState<PaginatedDriverList>? uiState){
    emit(state.copyWith(driverState: uiState));
  }

 
  Future<void> fetchDriver({bool isLoading = true,String? search}) async {
    if(isLoading) _setFetchDriverUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchDriver(userId: userId ?? '',search: search);
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
  void _setFetchFaqUIState(UIState<FaqResponse>? uiState){
    emit(state.copyWith(faqUIState: uiState));
  }

  Future<void> fetchFaq({String search = '', bool isLoading = true}) async {
   if(isLoading) _setFetchFaqUIState(UIState.loading());

    dynamic result = await _repo.fetchFaq(search: search);
    if (result is Success<FaqResponse>) {
      _setFetchFaqUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setFetchFaqUIState(UIState.error(result.type));
    }
  }

  // Fetch tickets from api call
  void _setTicketsUIState(UIState<TicketResponse>? uiState){
    emit(state.copyWith(ticketState: uiState));
  }

  Future<void> fetchTickets({bool isLoading = true, required TicketRequest request}) async {
    if(isLoading) _setTicketsUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.fetchTickets(userId: userId ?? '',request: request);
    if (result is Success<TicketResponse>) {
      _setTicketsUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setTicketsUIState(UIState.error(result.type));
    }
  }

  // create ticket from api call
  void _setCreateTicketsUIState(UIState<Ticket>? uiState){
    emit(state.copyWith(createTicketState: uiState));
  }

  Future<void> createTicket({ required CreateTicketRequest request}) async {
    _setCreateTicketsUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.createTicket(request: request.copyWith(customerId: userId));
    if (result is Success<Ticket>) {
      _setCreateTicketsUIState(UIState.success(result.value));
      fetchTickets(request: TicketRequest());
    }
    if (result is Error) {
      _setCreateTicketsUIState(UIState.error(result.type));
    }
  }

  // Verfy License from vahan
  void _setVerifyvahanLicenseUIState(UIState<VerifedLicenseVahanData>? uiState){
    emit(state.copyWith(verifiedLicenseVahanState: uiState));
  }

  Future<void> verifyLicenseFromVahan({ required LicenseVahanRequest request}) async {
    _setVerifyvahanLicenseUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.verifyLicenseVahan(request: request);
    if (result is Success<VerifedLicenseVahanData>) {
      _setVerifyvahanLicenseUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setVerifyvahanLicenseUIState(UIState.error(result.type));
    }
  }

   // Verfy Vehicle from vahan
  void _setVerifyvahanVehicleUIState(UIState<VerifedVehicleVahanData>? uiState){
    emit(state.copyWith(verifiedVehicleVahanState: uiState));
  }

  Future<void> verifyVehcileFromVahan({ required VehicleVahanRequest request}) async {
    _setVerifyvahanVehicleUIState(UIState.loading());
    userId = await _repo.getUserId();

    dynamic result = await _repo.verifyVehcileVahan(request: request);
    if (result is Success<VerifedVehicleVahanData>) {
      _setVerifyvahanVehicleUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setVerifyvahanVehicleUIState(UIState.error(result.type));
    }
  }

  void updateTempTicketStatus(TicketStatus? status) {
    emit(state.copyWith(tempSelectedTicketStatus: status));
  }

  void applyTicketStatusFilter() {
    emit(state.copyWith(selectedTicketStatus: state.tempSelectedTicketStatus));
    fetchTickets(request: TicketRequest(ticketStatus: state.tempSelectedTicketStatus == TicketStatus.pending ? '1' : '2'));
  }

  void clearTicketStatusFilter() {
    emit(state.copyWith(
      selectedTicketStatus: null,
      tempSelectedTicketStatus: null,
    ));
    fetchTickets(request: TicketRequest());
  }

 void resetlicenseVahanVerificationState(){
  emit(state.copyWith(
    verifiedLicenseVahanState: resetUIState<VerifedLicenseVahanData>(state.verifiedLicenseVahanState)
  ));
}
  // // Upload Ticket File
  void _setUploadTicketUIState(UIState<UploadTicketResponse>? uiState){
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
  void _setCreateDocumentUIState(UIState<CreateDocumentModel>? uiState){
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


  Future<void> resetVehicleVerificationState() async {
  emit(state.copyWith(
    vehicleVerificationState: null,
    verifiedVehicleVahanState: null,
  ));
  // Optionally add a short delay if UI rebuild lags:
  await Future.delayed(Duration(milliseconds: 100));
}




  // Reset State
  void resetState(){
    emit(state.copyWith(
      logoutUIState: resetUIState<LogOutModel>(state.logoutUIState),
      profileDetailUIState: resetUIState<ProfileDetailModel>(state.profileDetailUIState),
      verifiedLicenseVahanState: resetUIState<VerifedLicenseVahanData>(state.verifiedLicenseVahanState)
    ));
  }

  void resetLogoutUIState(){
    emit(state.copyWith(
      logoutUIState: resetUIState<LogOutModel>(state.logoutUIState),
    ));
  }




}
