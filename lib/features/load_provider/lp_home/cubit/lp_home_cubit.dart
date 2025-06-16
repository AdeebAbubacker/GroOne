import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/destination_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/pick_up_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';

class LPHomeCubit extends BaseCubit<LPHomeState> {
  final LpHomeRepository _repo;
  LPHomeCubit(this._repo) : super(LPHomeState());


  // Kyc Timer
  Future<void> startKycSuccessTimer() async {
    emit(state.copyWith(showSuccessKyc: true));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(showSuccessKyc: false));
  }

  void setDestination(DestinationModel? destination) {
    if (destination == null) return;
    emit(state.copyWith(destination: destination));
  }

  void setPickup(PickUpModel? pickup) {
    if (pickup == null) return;
    emit(state.copyWith(pickup: pickup));
  }

  void clearPickUpAndDestination() {
    emit(state.copyWith(destination: null));
    emit(state.copyWith(pickup: null));
  }



  // Fetch Truck Type
  void _setTruckTypeUIState(UIState<LoadTruckTypeListModel>? uiState){
    emit(state.copyWith(truckTypeState: uiState));
  }
  Future<void> fetchTruckTypes() async {
    _setTruckTypeUIState(UIState.loading());
    dynamic  result = await _repo.getTruckTypeData();
    if (result is Success<LoadTruckTypeListModel>) {
      _setTruckTypeUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setTruckTypeUIState(UIState.error(result.type));
    }
  }


  // Fetch Recent Route
  void _setRecentUIState(UIState<RecentRoutesModel>? uiState){
    emit(state.copyWith(recentRouteState: uiState));
  }
  Future<void> fetchRecentRoute() async {
    _setRecentUIState(UIState.loading());
    emit(state.copyWith(recentRouteState: UIState.loading()));
    dynamic result = await _repo.getRecentRouteData();
    if (result is Success<RecentRoutesModel?>) {
      _setRecentUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setRecentUIState(UIState.error(result.type));
    }
  }


  // Fetch Auto Complete Api Call
  void _setAutoCompleteUIState(UIState<AutoCompleteModel>? uiState){
    emit(state.copyWith(autoCompleteUIState: uiState));
  }
  Future<void> fetchAutoComplete(String input) async {
    _setAutoCompleteUIState(UIState.loading());
    dynamic result = await _repo.getAutoCompleteData(input);
    if (result is Success<AutoCompleteModel>) {
      _setAutoCompleteUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setAutoCompleteUIState(UIState.error(result.type));
    }
  }


  // Verify Location Api Call
  void _seVerifyLocationUIState(UIState<VerifyLocationModel>? uiState){
    emit(state.copyWith(verifyLocationUIState: uiState));
  }
  Future<void> verifyLocation(VerifyLocationApiRequest req) async {
    _seVerifyLocationUIState(UIState.loading());
    dynamic result = await _repo.getVerifyLocationData(req);
    if (result is Success<VerifyLocationModel>) {
      _seVerifyLocationUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _seVerifyLocationUIState(UIState.error(result.type));
    }
  }


  void resetAutoCompleteState(){
    emit(state.copyWith(autoCompleteUIState: resetUIState<AutoCompleteModel>(state.autoCompleteUIState)));
  }


  // Reset UI
  void resetState(){
    emit(state.copyWith(
      recentRouteState: resetUIState<RecentRoutesModel>(state.recentRouteUIState),
      autoCompleteUIState: resetUIState<AutoCompleteModel>(state.autoCompleteUIState),
      verifyLocationUIState: resetUIState<VerifyLocationModel>(state.verifyLocationUIState),
    ));
  }


}
