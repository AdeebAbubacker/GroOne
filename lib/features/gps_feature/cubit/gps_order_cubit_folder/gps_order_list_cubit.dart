import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_order_list_models.dart';

// Events
abstract class GpsOrderListEvent {}

class GetGpsOrderList extends GpsOrderListEvent {
  final String customerId;
  final int page;
  final int limit;

  GetGpsOrderList({
    required this.customerId,
    this.page = 1,
    this.limit = 10,
  });
}

// States
abstract class GpsOrderListState {}

class GpsOrderListInitial extends GpsOrderListState {}

class GpsOrderListLoading extends GpsOrderListState {}

class GpsOrderListLoaded extends GpsOrderListState {
  final GpsOrderListResponse orderList;
  final bool isRefresh;

  GpsOrderListLoaded(this.orderList, {this.isRefresh = false});
}

class GpsOrderListError extends GpsOrderListState {
  final String message;

  GpsOrderListError(this.message);
}

// Cubit
class GpsOrderListCubit extends Cubit<GpsOrderListState> {
  final GpsOrderApiRepository _repository;
  bool _isClosed = false;

  GpsOrderListCubit(this._repository) : super(GpsOrderListInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(GpsOrderListInitial());
  }

  Future<void> getOrderList({
    required String customerId,
    int page = 1,
    int limit = 10,
    bool isRefresh = false,
  }) async {
    if (_isClosed) {
      return;
    }

    if (isRefresh) {
      emit(GpsOrderListLoading());
    } else if (state is! GpsOrderListLoaded) {
      emit(GpsOrderListLoading());
    }

    try {
      final result = await _repository.getGpsCustomerOrdersList(
        customerId: customerId,
        page: page,
        limit: limit,
      );

      if (_isClosed) return; // Check again after async operation

      if (result is Success<GpsOrderListResponse>) {
        emit(GpsOrderListLoaded(result.value, isRefresh: isRefresh));
      } else if (result is Error<GpsOrderListResponse>) {
        final errorMessage = result.type.toString();
        emit(GpsOrderListError(errorMessage));
      } else {
        emit(GpsOrderListError('Unknown error occurred'));
      }
    } catch (e) {
      if (!_isClosed) {
        emit(GpsOrderListError(e.toString()));
      }
    }
  }

  void refreshOrderList(String customerId) {
    if (!_isClosed) {
      getOrderList(customerId: customerId, isRefresh: true);
    }
  }
} 