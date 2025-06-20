import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
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

  // update the selected tab
  void updateSelectedTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

}
