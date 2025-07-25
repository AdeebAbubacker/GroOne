import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';
part 'profile_state.dart';

class ProfileCubit extends BaseCubit<ProfileState> {
  final ProfileRepository _repo;
  ProfileCubit(this._repo): super(ProfileState());

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
