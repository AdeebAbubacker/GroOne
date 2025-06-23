import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/repository/lp_all_loads_repository.dart';

part 'lp_load_state.dart';

class LpLoadCubit extends BaseCubit<LpLoadState> {
  final LpLoadRepository _repository;
  LpLoadCubit(this._repository) : super(LpLoadState());

  // Updates the UI state related to loading LP loads.
  void _setLoadUIState(UIState<List<LpLoadItem>>? uiState) {
    emit(state.copyWith(lpLoadResponse: uiState));
  }

  // Fetches the LP loads filtered by the given [type].
  Future<void> getLpLoadsByType({required int type, String search = ""}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchLoads(type: type, search: search);

    if (result is Success<List<LpLoadItem>>) {
      _setLoadUIState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadUIState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to load Memo Details.
  void _setLoadMemoState(UIState<LoadMemoData>? uiState) {
    emit(state.copyWith(lpLoadMemoDetails: uiState));
  }

  // Fetches the LP load Memo Details.
  Future<void> getLpLoadsMemoDetails({required int loadId}) async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchMemoDetails(loadId: loadId);

    if (result is Success<LoadMemoData>) {
      _setLoadMemoState(UIState.success(result.value));
    } else if (result is Error) {
      _setLoadMemoState(UIState.error(result.type));
    }
  }

  // update the selected tab
  void updateSelectedTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }


  // Updates the UI state related to load truck.
  void _setTruckTypeState(UIState<LoadTruckTypeListModel>? uiState) {
    emit(state.copyWith(lpLoadTruckTypes: uiState));
  }

  // Fetches the LP load truck Details.
  Future<void> getTruckType() async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchTruckTypeList();

    if (result is Success<LoadTruckTypeListModel>) {
      _setTruckTypeState(UIState.success(result.value));
    } else if (result is Error) {
      _setTruckTypeState(UIState.error(result.type));
    }
  }

  // Updates the UI state related to load truck.
  void _setRouteDetailsState(UIState<LpLoadRouteResponse>? uiState) {
    emit(state.copyWith(lpLoadRouteDetails: uiState));
  }

  // Fetches the LP load route Details.
  Future<void> getRouteDetails() async {
    _setLoadUIState(UIState.loading());

    Result result = await _repository.fetchRouteList();

    if (result is Success<LpLoadRouteResponse>) {
      _setRouteDetailsState(UIState.success(result.value));
    } else if (result is Error) {
      _setRouteDetailsState(UIState.error(result.type));
    }
  }

}
