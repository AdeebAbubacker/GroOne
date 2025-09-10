import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/repository/vp_all_load_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';

class LoadFilterCubit extends BaseCubit<LoadFilterState> {
  final VpLoadRepository _vpLoadRepository;

  LoadFilterCubit(this._vpLoadRepository) : super(LoadFilterState());

  // set vehicle type state
  void _setVehicleTypeState(UIState<List<TruckTypeModel>>? uiState) {
    emit(state.copyWith(truckTypeUIState: uiState));
  }

  // get vehicle type
  Future<void> getAllVehicleType() async {
    _setVehicleTypeState(UIState.loading());
    Result result = await _vpLoadRepository.getTruckTypeData();

    if (result is Success<List<TruckTypeModel>>) {
      _setVehicleTypeState(UIState.success(result.value));
    }
    if (result is Error) {
      _setVehicleTypeState(UIState.error(result.type));
    }
  }

  // set lanes  state
  void _setLanesState(UIState<TruckPrefLaneModel>? uiState, int? currentPage) {
    emit(state.copyWith(truckTypeLaneUIState: uiState,currentPage: currentPage));
  }

  // get prefer lanes

  Future<void> getPreferLens( {bool isInit=true,String? query}) async {

    if (isInit) {
      _setLanesState(UIState.loading(), 1);
    }


    final existingModel = state.truckTypeLaneUIState?.data;

    if (!isInit && existingModel != null) {
      final total = existingModel.data?.total ?? 0;
      final limit = existingModel.data?.limit ?? 0;
      List lanesItems = existingModel.data?.items ?? [];
      final currentPage = state.currentPage ?? 1;
      if (total <= (currentPage - 1) * limit && lanesItems.length >= total) {
        return; // stop calling API
      }
    }

    Result result = await _vpLoadRepository.getPrefTruckLaneData(
      query,
      page: state.currentPage ?? 1,
    );
    if (result is Success<TruckPrefLaneModel>) {
      List<Item> newLens = result.value.data?.items ?? [];
      List<Item> oldLanes = state.truckTypeLaneUIState?.data?.data?.items ?? [];
      TruckPrefLaneModel lanesModel = result.value;
      TruckPrefLaneModel newLanesModel = lanesModel.copyWith(
        data: lanesModel.data?.copyWith(items: [...oldLanes, ...newLens]),
      );
      _setLanesState(
        UIState.success(newLanesModel),
        (state.currentPage ?? 0) + 1,
      );
    }
    if (result is Error) {
      _setLanesState(UIState.error(result.type), null);
    }
  }

  // set commodity state
  void _setCommodityState(UIState<List<LoadCommodityListModel>>? uiState) {
    emit(state.copyWith(commodityResponseUIState: uiState));
  }

  // get commodity
  Future<void> getAllCommodityState() async {
    _setCommodityState(UIState.loading());
    Result result = await _vpLoadRepository.getLoadCommodityData();
    if (result is Success<List<LoadCommodityListModel>>) {
      _setCommodityState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCommodityState(UIState.error(result.type));
    }
  }

  /// set is filter applied
  void setIsFilterApplied({required bool value}) {
    emit(state.copyWith(isFilterApplied: value));

    if (value == false) {
      emit(
        state.copyWith(
          selectedTruckType: {},
          selectedCommodity: {},
          selectedLaneType: {},
        ),
      );
    }
  }

  /// select prefer lanes

  void selectPreferLanes(Item? selectedLanes){

    if(selectedLanes!=null){
      emit(state.copyWith(
        selectedPrefLanes: selectedLanes
      ));
    }

  }


  /// set truckTypeId
  void setCommodityData({int? commodityId, String? value}) {
    emit(
      state.copyWith(selectedCommodity: {"id": commodityId, "value": value}),
    );
  }

  /// set lens data
  void setLensData({int? leneId, String? value}) {
    emit(state.copyWith(selectedLaneType: {"id": leneId, "value": value}));
  }

  /// set truck data
  void setTruckTypeData({int? truckTypeId, String? value}) {
    emit(
      state.copyWith(selectedTruckType: {"id": truckTypeId, "value": value}),
    );
  }
}
