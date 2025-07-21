import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_logout_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/driver/driver_profile/repository/driver_profile_repository.dart';
import 'package:gro_one_app/features/profile/model/log_out_model.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';
part 'driver_profile_state.dart';

class DriverProfileCubit extends BaseCubit<DriverProfileState> {
  final DriverProfileRepository _repo;
  DriverProfileCubit(this._repo): super(DriverProfileState());

  


  // Fetch Profile Detail Api Call
  void _setProfileDetailUIState(UIState<DriverProfileDetailsModel>? uiState){
    emit(state.copyWith(profileDetailUIState: uiState));
  }
  Future<void> fetchProfileDetail() async {
    _setProfileDetailUIState(UIState.loading());
    dynamic result = await _repo.getUserDetails();
    if (result is Success<DriverProfileDetailsModel>) {
      _setProfileDetailUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setProfileDetailUIState(UIState.error(result.type));
    }
  }

   // Logout Api Call
  void _setLogoutUIState(UIState<DriverlogoutModel>? uiState){
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



}
