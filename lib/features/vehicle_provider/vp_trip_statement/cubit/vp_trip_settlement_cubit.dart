import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/model/pod_center_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/repository/vp_trip_settlement_repository.dart';

part 'vp_trip_settlement_state.dart';

class VpTripSettlementCubit extends BaseCubit<VpTripSettlementState> {
  final VpTripSettlementRepository _repository;
  VpTripSettlementCubit(this._repository) : super(VpTripSettlementState());


  // Fetch Trip Settlement Api Call
  void _setTripSettlementUIState(UIState<PodCenterListModel>? uiState){
    emit(state.copyWith(tripSettlementUIState: uiState));
  }
  Future<void> fetchTripSettlement() async {
    _setTripSettlementUIState(UIState.loading());
    Result result = await _repository.getTripSettlementData();
    if (result is Success<PodCenterListModel>) {
      _setTripSettlementUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setTripSettlementUIState(UIState.error(result.type));
    }
  }

  void resetState(){
    emit(state.copyWith(
      tripSettlementUIState : resetUIState<PodCenterListModel>(state.tripSettlementUIState),
    ));
  }


}
