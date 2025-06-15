import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/repository/lp_home_repository.dart';


class LPHomeCubit extends BaseCubit<LPHomeState> {
  final LpHomeRepository _truckRepo;
  LPHomeCubit(this._truckRepo) : super(LPHomeState());

  // Fetch Truck Type
  void _setTruckTypeUIState(UIState<LoadTruckTypeListModel>? uiState){
    emit(state.copyWith(truckTypeState: uiState));
  }
  Future<void> fetchTruckTypes() async {
    _setTruckTypeUIState(UIState.loading());
    Result  result = await _truckRepo.getTruckTypeData();
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
    Result result = await _truckRepo.getRecentRouteData();
    if (result is Success<RecentRoutesModel?>) {
      _setRecentUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setRecentUIState(UIState.error(result.type));
    }
  }

  // Kyc Timer
  Future<void> startKycSuccessTimer() async {
    emit(state.copyWith(showSuccessKyc: true));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(showSuccessKyc: false));
  }

  void setDestination(Map<String, dynamic>? destination) {
    emit(state.copyWith(destination: destination));
  }

  void setPickup(Map<String, dynamic>? pickup) {
    emit(state.copyWith(pickup: pickup));
  }

  void clearPickUpAndDestination() {
    emit(state.copyWith(destination: null));
    emit(state.copyWith(pickup: null));
  }


}
