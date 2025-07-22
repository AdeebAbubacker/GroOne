import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_payment_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';
import 'package:gro_one_app/utils/custom_log.dart';

// Events
abstract class GpsOrderEvent {}

class CreateGpsOrder extends GpsOrderEvent {
  final GpsOrderRequest request;

  CreateGpsOrder(this.request);
}

class GetGpsOrderSummary extends GpsOrderEvent {
  final GpsOrderSummaryRequest request;

  GetGpsOrderSummary(this.request);
}

class InitiateGpsPayment extends GpsOrderEvent {
  final KavachInitiatePaymentRequest request;

  InitiateGpsPayment(this.request);
}

// States
abstract class GpsOrderState {}

class GpsOrderInitial extends GpsOrderState {}

class GpsOrderLoading extends GpsOrderState {}

class GpsOrderSuccess extends GpsOrderState {
  final String message;

  GpsOrderSuccess(this.message);
}

class GpsOrderError extends GpsOrderState {
  final String message;

  GpsOrderError(this.message);
}

class GpsOrderSummaryLoading extends GpsOrderState {}

class GpsOrderSummaryLoaded extends GpsOrderState {
  final GpsOrderSummaryResponse summary;

  GpsOrderSummaryLoaded(this.summary);
}

class GpsOrderSummaryError extends GpsOrderState {
  final String message;

  GpsOrderSummaryError(this.message);
}

class GpsPaymentInitiating extends GpsOrderState {}

class GpsPaymentSuccess extends GpsOrderState {
  final OrderAddedSuccess paymentResponse;

  GpsPaymentSuccess(this.paymentResponse);
}

class GpsPaymentFailure extends GpsOrderState {
  final String message;

  GpsPaymentFailure(this.message);
}

// Cubit
class GpsOrderCubit extends Cubit<GpsOrderState> {
  final GpsOrderApiRepository _repository;
  final UserInformationRepository _userRepository;

  GpsOrderCubit(this._repository, this._userRepository) : super(GpsOrderInitial());

  Future<void> createOrder(GpsOrderRequest request) async {
    emit(GpsOrderLoading());
    try {
      final result = await _repository.createGpsOrder(request);
      if (result is Success) {
        emit(GpsOrderSuccess('Order created successfully'));
      } else if (result is Error) {
        final errorMessage = result.type is ErrorWithMessage
            ? (result.type as ErrorWithMessage).message
            : 'Failed to create order';
        emit(GpsOrderError(errorMessage));
      }
    } catch (e) {
      emit(GpsOrderError(e.toString()));
    }
  }

  Future<void> getOrderSummary(GpsOrderSummaryRequest request) async {
    emit(GpsOrderSummaryLoading());
    try {
      final result = await _repository.getGpsOrderSummary(request);
      if (result is Success<GpsOrderSummaryResponse>) {
        emit(GpsOrderSummaryLoaded(result.value));
      } else if (result is Error<GpsOrderSummaryResponse>) {
        final errorMessage = result.type is ErrorWithMessage
            ? (result.type as ErrorWithMessage).message
            : 'Failed to get order summary';
        emit(GpsOrderSummaryError(errorMessage));
      }
    } catch (e) {
      emit(GpsOrderSummaryError(e.toString()));
    }
  }

  Future<void> initiatePayment(KavachInitiatePaymentRequest request) async {
    emit(GpsPaymentInitiating());
    try {
      final result = await _repository.initiatePayment(request);
      if (result is Success<OrderAddedSuccess>) {
        emit(GpsPaymentSuccess(result.value));
      } else if (result is Error<OrderAddedSuccess>) {
        final errorMessage = result.type is ErrorWithMessage
            ? (result.type as ErrorWithMessage).message
            : 'Failed to initiate payment';
        emit(GpsPaymentFailure(errorMessage));
      }
    } catch (e) {
      emit(GpsPaymentFailure(e.toString()));
    }
  }

  Future<String?> getUserId() async {
    return await _userRepository.getUserID();
  }
} 