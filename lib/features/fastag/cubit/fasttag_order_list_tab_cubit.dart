import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/fastag/cubit/fasttag_order_list_tab_state.dart';
import 'package:gro_one_app/features/fastag/model/fastag_list_response.dart';
import 'package:gro_one_app/features/fastag/repository/fastag_repository.dart';

class FastagOrderListTabCubit extends Cubit<FastagOrderListTabState> {
  final FastagRepository _repository;

  FastagOrderListTabCubit(this._repository)
    : super(FastagOrderListTabState.initial());

  Future<void> fetchFastagList({
    String searchTerm = '',
    bool isInitialLoad = false,
    int page = 1,
  }) async {
    emit(state.copyWith(fastagListUIState: UIState.loading()));

    final result = await _repository.getFastagList(
      searchTerm: searchTerm,
      page: page,
    );

    if (result is Success<FastagListResponse>) {
      final list = result.value.data;

      // Only trigger navigation if this is the first load & list is empty
      if (isInitialLoad && list.isEmpty) {
        emit(state.copyWith(fastagListUIState: UIState.success(result.value)));
        return;
      } else {
        emit(state.copyWith(fastagListUIState: UIState.success(result.value)));
      }
    } else if (result is Error<FastagListResponse>) {
      emit(state.copyWith(fastagListUIState: UIState.error(result.type)));
    }
  }
}
