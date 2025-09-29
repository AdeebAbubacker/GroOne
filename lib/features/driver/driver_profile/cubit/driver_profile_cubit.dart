import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_logout_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/repository/driver_profile_repository.dart';
import 'package:gro_one_app/features/profile/model/delete_account_response.dart';
import 'package:gro_one_app/utils/custom_log.dart';
part 'driver_profile_state.dart';

class DriverProfileCubit extends BaseCubit<DriverProfileState> {
  final DriverProfileRepository _repo;
  DriverProfileCubit(this._repo) : super(DriverProfileState());

  // Get User Id
  String? userId;
  Future<String?> fetchUserId() async {
    userId = await _repo.getUserId();
    CustomLog.debug(this, "User Id : $userId");
    return userId;
  }

  // Fetch Profile Detail Api Call
  void _setProfileDetailUIState(UIState<DriverProfileDetailsModel>? uiState) {
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
    if (result is Success<DriverProfileDetailsModel>) {
      _setProfileDetailUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setProfileDetailUIState(UIState.error(result.type));
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
    if (result is Error) {
      final error = result as Error;
      _setDeleteAccountUIState(UIState.error(error.type));
    } else {
      _setDeleteAccountUIState(UIState.error(GenericError()));
    }
  }

  // Logout Api Call
  void _setLogoutUIState(UIState<DriverlogoutModel>? uiState) {
    emit(state.copyWith(logoutUIState: uiState));
  }

  Future<void> logout() async {
    _setLogoutUIState(UIState.loading());
    dynamic result = await _repo.getLogOutData();
    dynamic isSignOut = await _repo.signOut();
    if (result is Success<DriverlogoutModel> && isSignOut is Success<bool>) {
      _setLogoutUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setLogoutUIState(UIState.error(result.type));
    }
  }

  void resetLogoutUIState() {
    emit(
      state.copyWith(
        logoutUIState: resetUIState<DriverlogoutModel>(state.logoutUIState),
      ),
    );
  }

  void restState() {
    emit(
      state.copyWith(
        logoutUIState: resetUIState(state.logoutUIState),
        deleteAccountUIState: resetUIState(state.deleteAccountUIState),
      ),
    );
  }
}
