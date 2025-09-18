import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/destination_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/pick_up_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_event_api_request.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';


class LPHomeCubit extends BaseCubit<LPHomeState> {
  final LpHomeRepository _repo;
  LPHomeCubit(this._repo) : super(LPHomeState());

  Timer? _matchTimer;
  final securePrefs = locator<SecuredSharedPreferences>();
  @override
  Future<void> close() {
    _matchTimer?.cancel();
    return super.close();
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
      pickupLocationId: null,
      laneId: null,
    ));
  }


  // Set Location Id
  void setPickupLocationDetailId(int? id){
    emit(state.copyWith(pickupLocationId: id));
  }


  // Set Location Id
  void setDestinationLocationDetailId(int? id){
    emit(state.copyWith(destinationLocationId: id));
  }

  // Set Lane Id
  void setLaneId(num? id){
    emit(state.copyWith(laneId: id ?? 0));
  }

  // Select Weight
  void selectWeight(LoadWeightModel weight) {
    emit(state.copyWith(selectedWeight: weight));
  }


  // call this once for every load‑card you need
  void _emitMatching(String createdAtString) {
    try {
      final createdAt = DateTime.parse(createdAtString);
      final deadline = createdAt.add(const Duration(hours: 3)); // 3-hour countdown
      final text = LpHomeHelper.getMatchingTime(deadline.toIso8601String());
      emit(state.copyWith(matchingText: text));
    } catch (e) {
      emit(state.copyWith(matchingText: "--"));
    }
  }
  void startMatchingTimer(String createdAtString) {
    _matchTimer?.cancel();
    _emitMatching(createdAtString); // First call immediately
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
  void _setRecentUIState(UIState<RecentRoutesModel>? uiState, int page) {
    emit(
      state.copyWith(
        recentRouteState: uiState,
        recentPage: page,
      ),
    );
  }

  Future<void> fetchRecentRoute({
    bool isLoading = true,
    String? search,
    bool isInit = true,
  }) async {
    if (state.isFetchingRecent) return;

    emit(state.copyWith(isFetchingRecent: true));

    // reset when search changes
    if (search != null && search.trim().isNotEmpty) {
      _setRecentUIState(UIState.loading(), 1);
    } else if (isInit || isLoading) {
      if (isLoading) _setRecentUIState(UIState.loading(), 1);
    }
    final oldData = state.recentRouteState?.data?.data.data ?? [];
    final totalRecords = state.recentRouteState?.data?.data.total ?? 0;
    if (oldData.length >= totalRecords && totalRecords > 0) {
      emit(state.copyWith(isFetchingRecent: false));
      return;
    }
    final currentPage = state.recentPage ?? 1;

    final result = await _repo.getRecentRouteData(
      search,
      currentPage,
    );

    if (result is Success<RecentRoutesModel>) {
      final fetchedData = result.value;
      final oldObject = (search != null && search.trim().isNotEmpty)
          ? null 
          : state.recentRouteState?.data;

      final List<RecentRouteData> mergedList = [
        ...oldObject?.data.data ?? [],
        ...fetchedData.data.data,
      ];

      final modifiedData = RecentRoutesModel(
        message: fetchedData.message,
        data: fetchedData.data.copyWith(data: mergedList),
      );

      _setRecentUIState(
        UIState.success(modifiedData),
        currentPage + 1,
      );
    }

    if (result is Error<RecentRoutesModel>) {
      _setRecentUIState(UIState.error(result.type), currentPage);
    }

    emit(state.copyWith(isFetchingRecent: false));
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
  void _setLoadWeightUIState(UIState<List<LoadWeightModel>>? uiState){
    emit(state.copyWith(loadWeightUIState: uiState));
  }
  Future<void> fetchLoadWeight() async {
    _setLoadWeightUIState(UIState.loading());
    dynamic result = await _repo.getLoadWeightData();
    if (result is Success<List<LoadWeightModel>>) {
      _setLoadWeightUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setLoadWeightUIState(UIState.error(result.type));
    }
  }


  // Fetch Get Load Api Call
  void _setGetLoadListUIState(UIState<LpLoadResponse>? uiState){
    emit(state.copyWith(getLoadListUIState: uiState));
  }
  Future<void> fetchGetLoadList() async {
    _setGetLoadListUIState(UIState.loading());
    dynamic result = await _repo.getLoads();
    if (result is Success<LpLoadResponse>) {
      _setGetLoadListUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setGetLoadListUIState(UIState.error(result.type));
    }
  }

  // setBluId
  void _setBluIDFlagState(UIState uiState){
    emit(state.copyWith(isBluIdShown: uiState));
  }
  Future<void> setBluIDFlag() async {
    _setBluIDFlagState(UIState.loading());
    dynamic result = await _repo.setBluIDFlag();
    if (result is Success) {
      _setBluIDFlagState(UIState.success(result.value));
    }
    if (result is Error) {
      _setBluIDFlagState(UIState.error(result.type));
    }
  }


  // Reset Auto Complete UI State
  void resetAutoCompleteState(){
    emit(state.copyWith(autoCompleteUIState: resetUIState<AutoCompleteModel>(state.autoCompleteUIState)));
  }



  // Reset Complete UI State
  void resetState(){
    emit(state.copyWith(
      recentRouteState: resetUIState<RecentRoutesModel>(state.recentRouteState),
      autoCompleteUIState: resetUIState<AutoCompleteModel>(state.autoCompleteUIState),
      verifyLocationUIState: resetUIState<VerifyLocationModel>(state.verifyLocationUIState),
      loadWeightUIState: resetUIState<List<LoadWeightModel>>(state.loadWeightUIState),
      rateDiscoveryUIState: resetUIState<RateDiscoveryModel>(state.rateDiscoveryUIState),
      truckTypeState: resetUIState<LoadTruckTypeListModel>(state.truckTypeUIState),
      profileDetailUIState: resetUIState<ProfileDetailModel>(state.profileDetailUIState),
    ));
  }

  /// Create Event
  Future<void> createEvent(CreateEventApiRequest request) async {
    dynamic result = await _repo.createEvent(request);
    // No need to emit state for this API as it's just for tracking
    if (result is Success<String?>) {
      await securePrefs.deleteKey(AppString.sessionKey.eventId);
      final eventId = result.value;
      if (eventId != null && eventId.isNotEmpty) {
        // Store event_id in SharedPreferences
        try {
          await securePrefs.saveKey(AppString.sessionKey.eventId, eventId);
        } catch (e) {
          // Log error but don't show to user as it's not critical
        }
      }
    }
    if (result is Error) {
      // Log error but don't show to user as it's not critical
    }
  }

  /// update Event
  Future<void> updatedAppEvent({required String stage,String? entityId, Map<String, dynamic>? context}) async {
    final eventId = await securePrefs.get(AppString.sessionKey.eventId);
    dynamic result = await _repo.updatedAppEvent(stage: stage,eventId: eventId ??'',entityId: entityId,context: context);
    // No need to emit state for this API as it's just for tracking
    if (result is Success<String?>) {
    }
    if (result is Error) {
      // Log error but don't show to user as it's not critical
    }
  }


}
