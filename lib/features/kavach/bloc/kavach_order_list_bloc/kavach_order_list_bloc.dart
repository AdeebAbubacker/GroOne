import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_order_list_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_order_list_event.dart';
import 'kavach_order_list_state.dart';

class KavachOrderListBloc extends Bloc<KavachOrderListEvent, KavachOrderListState> {
  final KavachRepository _repository;

  KavachOrderListBloc(this._repository) : super(KavachOrderListInitial()) {
    on<FetchKavachOrderList>(_onFetchOrders);
  }

  Future<void> _onFetchOrders(FetchKavachOrderList event, Emitter<KavachOrderListState> emit) async {
    final currentState = state;
    int nextPage = 1;

    if (event.isRefresh) {
      nextPage = 1;
    } else if (currentState is KavachOrderListLoaded) {
      if (currentState.hasReachedMax) return;
      nextPage = currentState.page + 1;
    }

    try {
      if (nextPage == 1) {
        emit(KavachOrderListLoading());
      }

      // final result = await _repository.fetchCustomerOrders(page: nextPage);
      final result = await _repository.fetchCustomerOrders(
        page: nextPage,
        status: event.status,
      );

      if (result is Success<KavachOrderListResponse>) {
        final response = result.value;
        final orders = response.orders;
        final hasReachedMax = nextPage >= response.meta.totalPages;

        if (currentState is KavachOrderListLoaded && !event.isRefresh) {
          emit(
            KavachOrderListLoaded(
              orders: currentState.orders + orders,
              hasReachedMax: hasReachedMax,
              page: nextPage,
            ),
          );
        } else {
          emit(KavachOrderListLoaded(
            orders: orders,
            hasReachedMax: hasReachedMax,
            page: nextPage,
          ));
        }
      } else if (result is Error) {
        emit(KavachOrderListError("Failed to fetch orders"));
      }
    } catch (e) {
      emit(KavachOrderListError("Unexpected error: $e"));
    }
  }
}
