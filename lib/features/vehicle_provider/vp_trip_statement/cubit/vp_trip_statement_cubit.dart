import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/model/trip_statement_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/repository/vp_trip_settlement_repository.dart';

part 'vp_trip_statement_state.dart';

class VpTripStatementCubit extends BaseCubit<VpTripStatementState> {
  final VpTripStatementRepository _repository;
  VpTripStatementCubit(this._repository) : super(VpTripStatementState());


  // Fetch Trip Settlement Api Call
  void _setTripStatementUIState(UIState<TripStatementResponse>? uiState){
    emit(state.copyWith(tripSettlementUIState: uiState));
  }

  Future<void> fetchTripStatement(String? loadId) async {
    _setTripStatementUIState(UIState.loading());
    Result result = await _repository.getTripStatementData(loadId);
    if (result is Success<TripStatementResponse>) {
      _setTripStatementUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setTripStatementUIState(UIState.error(result.type));
    }
  }

  void resetState(){
    emit(state.copyWith(
      tripSettlementUIState : resetUIState<TripStatementResponse>(state.tripStatementUIState),
    ));
  }


}
