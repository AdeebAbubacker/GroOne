import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/repository/vp_all_load_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';

class LoadFilterCubit extends BaseCubit<LoadFilterState>{

  final VpLoadRepository _vpLoadRepository;
  LoadFilterCubit(this._vpLoadRepository):super(LoadFilterState());


  // set vehicle type state
  void _setVehicleTypeState(UIState<List<TruckTypeModel>>? uiState){
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
  void _setLanesState(UIState<TruckPrefLaneModel>? uiState){
    emit(state.copyWith(truckTypeLaneUIState: uiState));
  }


  // get prefer lanes
  Future<void> getPreferLens() async {
    _setLanesState(UIState.loading());
    Result result = await _vpLoadRepository.getPrefTruckLaneData("",page: 1);
    if (result is Success<TruckPrefLaneModel>) {
      _setLanesState(UIState.success(result.value));
    }
    if (result is Error) {
      _setLanesState(UIState.error(result.type));
    }
  }



  // set commodity state
  void _setCommodityState(UIState<List<LoadCommodityListModel>>? uiState){
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


}