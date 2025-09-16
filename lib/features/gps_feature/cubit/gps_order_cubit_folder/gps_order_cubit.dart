import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_create_order_response.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_payment_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';

import '../../models/gps_payment_status_response.dart';

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

class CheckGpsPaymentStatus extends GpsOrderEvent {
  final String requestId;
  CheckGpsPaymentStatus(this.requestId);
}


// States
abstract class GpsOrderState {}

class GpsOrderInitial extends GpsOrderState {}

class GpsOrderLoading extends GpsOrderState {}

class GpsOrderSuccess extends GpsOrderState {
  final String message;
  final String orderID;

  GpsOrderSuccess({required this.message, required this.orderID});
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

class GpsPaymentStatusSuccess extends GpsOrderState {
  final PaymentStatusResponse statusResponse;
  GpsPaymentStatusSuccess(this.statusResponse);
}

class GpsPaymentStatusFailure extends GpsOrderState {
  final String message;
  GpsPaymentStatusFailure(this.message);
}


// Cubit
class GpsOrderCubit extends Cubit<GpsOrderState> {
  final GpsOrderApiRepository _repository;
  final UserInformationRepository _userRepository;
  bool _isClosed = false;
  String? paymentRequestId;

  GpsOrderCubit(this._repository, this._userRepository) : super(GpsOrderInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(GpsOrderInitial());
  }

  Future<void> createOrder(GpsOrderRequest request) async {
    if (_isClosed) return;
    
    if (!_isClosed) {
      emit(GpsOrderLoading());
    }
    
    try {
      final result = await _repository.createGpsOrder(request);
      
      if (_isClosed) return;
      
      if (result is Success) {
        if (!_isClosed) {
            CreateOrderResponse response = result.value;
          emit(GpsOrderSuccess(message: 'Order created successfully',orderID: response.data!.orderUniqueId??''));
        }
      } else if (result is Error) {
        final errorMessage = result.type is ErrorWithMessage
            ? (result.type as ErrorWithMessage).message
            : 'Failed to create order';
        if (!_isClosed) {
          emit(GpsOrderError(errorMessage));
        }
      }
    } catch (e) {
      if (!_isClosed) {
        emit(GpsOrderError(e.toString()));
      }
    }
  }

  Future<void> getOrderSummary(GpsOrderSummaryRequest request) async {
    if (_isClosed) return;
    
    if (!_isClosed) {
      emit(GpsOrderSummaryLoading());
    }
    
    try {
      final result = await _repository.getGpsOrderSummary(request);
      
      if (_isClosed) return;
      
      if (result is Success<GpsOrderSummaryResponse>) {
        if (!_isClosed) {
          emit(GpsOrderSummaryLoaded(result.value));
        }
      } else if (result is Error<GpsOrderSummaryResponse>) {
        final errorMessage = result.type is ErrorWithMessage
            ? (result.type as ErrorWithMessage).message
            : 'Failed to get order summary';
        if (!_isClosed) {
          emit(GpsOrderSummaryError(errorMessage));
        }
      }
    } catch (e) {
      if (!_isClosed) {
        emit(GpsOrderSummaryError(e.toString()));
      }
    }
  }

  Future<void> initiatePayment(KavachInitiatePaymentRequest request) async {
    emit(GpsPaymentInitiating());
    try {
      final result = await _repository.initiatePayment(request);
      if (result is Success<OrderAddedSuccess>) {
        paymentRequestId = result.value.data?.data?.paymentRequestId;
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

  Future<void> checkPaymentStatus(String requestId) async {
    try {
      emit(GpsPaymentInitiating());
      final result = await _repository.checkPaymentStatus(requestId);

      if (result is Success<PaymentStatusResponse>) {
        final status = result.value.findData?.status;

        if (status == "Success") {
          emit(GpsPaymentStatusSuccess(result.value));
        } else {
          emit(GpsPaymentStatusFailure("Payment failed. Status: $status"));
        }
      } else if (result is Error<PaymentStatusResponse>) {
        final errorMessage = result.type is ErrorWithMessage
            ? (result.type as ErrorWithMessage).message
            : 'Failed to check payment status';
        emit(GpsPaymentStatusFailure(errorMessage));
      }
    } catch (e) {
      emit(GpsPaymentStatusFailure(e.toString()));
    }
  }



} 