import 'dart:async';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/LPGetLoadModel.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/destination_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/pick_up_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';


class LPHomeCubit extends BaseCubit<LPHomeState> {
  final LpHomeRepository _repo;
  LPHomeCubit(this._repo) : super(LPHomeState());

  Timer? _matchTimer;

  @override
  Future<void> close() {
    _matchTimer?.cancel();
    return super.close();
  }

  // Kyc Timer
  Future<void> startKycSuccessTimer() async {
    emit(state.copyWith(showSuccessKyc: true));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(showSuccessKyc: false));
  }

  // Set Destination
  void setDestination(DestinationModel? destination) {
    emit(state.copyWith(
      destination: destination != null ? UIState.success(destination) : UIState.initial(),
    ));
  }

  // Set Pick up
  void setPickup(PickUpModel? pickup) {
    emit(state.copyWith(
      pickup: pickup != null ? UIState.success(pickup) : UIState.initial(),
    ));
  }

  // Clear Pickup & Destination
  void clearPickUpAndDestination() {
    emit(state.copyWith(
      pickup: null,
      destination: null,
      locationId: null,
      laneId: null,
    ));
  }


  // Set Location Id
  void setLocationDetailId(num? id){
    emit(state.copyWith(locationId: id ?? 0));
  }

  // Set Lane Id
  void setLaneId(num? id){
    emit(state.copyWith(laneId: id ?? 0));
  }

  // Select Weight
  void selectWeight(LoadWeightData weight) {
    emit(state.copyWith(selectedWeight: weight));
  }

  // Get Blue Id
  Future<String?> getBlueId() async {
    Result<String> getBlueId = await _repo.getBlueId();
    if (getBlueId is Success<String>) {
      emit(state.copyWith(blueId: getBlueId.value));
      return getBlueId.value;
    } else {
      return null;
    }
  }


  // call this once for every load‑card you need
  void _emitMatching(String createdAtString) {
    final text = LpHomeHelper.getMatchingTime(createdAtString);
    emit(state.copyWith(matchingText: text));
  }
  void startMatchingTimer(String createdAtString) {
    _matchTimer?.cancel();
    _emitMatching(createdAtString);
    _matchTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _emitMatching(createdAtString),
    );
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


  // Fetch Rate Discovery Api Call
  void _setRateDiscoveryUIState(UIState<RateDiscoveryModel>? uiState){
    emit(state.copyWith(rateDiscoveryUIState: uiState));
  }
  Future<void> fetchRateDiscovery(RateDiscoveryApiRequest request) async {
    _setRateDiscoveryUIState(UIState.loading());
    dynamic result = await _repo.getRateDiscoveryData(request);
    if (result is Success<RateDiscoveryModel>) {
      _setRateDiscoveryUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setRateDiscoveryUIState(UIState.error(result.type));
    }
  }


  // Fetch Weight Api Call
  void _setLoadWeightUIState(UIState<LoadWeightModel>? uiState){
    emit(state.copyWith(loadWeightUIState: uiState));
  }
  Future<void> fetchLoadWeight() async {
    _setLoadWeightUIState(UIState.loading());
    dynamic result = await _repo.getLoadWeightData();
    if (result is Success<LoadWeightModel>) {
      _setLoadWeightUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setLoadWeightUIState(UIState.error(result.type));
    }
  }


  // Fetch Profile Detail Api Call
  void _setProfileDetailUIState(UIState<ProfileDetailModel>? uiState){
    emit(state.copyWith(profileDetailUIState: uiState));
  }
  Future<void> fetchProfileDetail() async {
    _setProfileDetailUIState(UIState.loading());
    dynamic result = await _repo.getUserDetails();
    if (result is Success<ProfileDetailModel>) {

      _setProfileDetailUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setProfileDetailUIState(UIState.error(result.type));
    }
  }


  // Fetch Get Load Api Call
  void _setGetLoadListUIState(UIState<LpGetLoadModel>? uiState){
    emit(state.copyWith(getLoadListUIState: uiState));
  }
  Future<void> fetchGetLoadList() async {
    _setGetLoadListUIState(UIState.loading());
    dynamic result = await _repo.getLoads();
    if (result is Success<LpGetLoadModel>) {
      _setGetLoadListUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setGetLoadListUIState(UIState.error(result.type));
    }
  }


  // Reset Auto Complete UI State
  void resetAutoCompleteState(){
    emit(state.copyWith(autoCompleteUIState: resetUIState<AutoCompleteModel>(state.autoCompleteUIState)));
  }



  // Reset Complete UI State
  void resetState(){
    emit(state.copyWith(
      recentRouteState: resetUIState<RecentRoutesModel>(state.recentRouteUIState),
      autoCompleteUIState: resetUIState<AutoCompleteModel>(state.autoCompleteUIState),
      verifyLocationUIState: resetUIState<VerifyLocationModel>(state.verifyLocationUIState),
      loadWeightUIState: resetUIState<LoadWeightModel>(state.loadWeightUIState),
      rateDiscoveryUIState: resetUIState<RateDiscoveryModel>(state.rateDiscoveryUIState),
      truckTypeState: resetUIState<LoadTruckTypeListModel>(state.truckTypeUIState),
      profileDetailUIState: resetUIState<ProfileDetailModel>(state.profileDetailUIState),
    ));
  }


}
