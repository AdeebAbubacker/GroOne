import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/fastag/model/fastag_list_response.dart';
import 'package:gro_one_app/features/fastag/repository/fastag_repository.dart';
import 'fasttag_order_list_state.dart';

class FastagOrderListCubit extends Cubit<FastagState1> {
  final FastagRepository _repository;

  FastagOrderListCubit(this._repository) : super(FastagState1.initial());

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
      debugPrint('checkkkk$list');
      // Only trigger navigation if this is the first load & list is empty
      if (isInitialLoad && list.isEmpty) {
        debugPrint('erwerwe');
        emit(state.copyWith(fastagListUIState: UIState.success(result.value)));
        return;
      } else {
        debugPrint('erwerwe111');
        emit(state.copyWith(fastagListUIState: UIState.success(result.value)));
      }
    } else if (result is Error<FastagListResponse>) {
      emit(state.copyWith(fastagListUIState: UIState.error(result.type)));
    }
  }
}
