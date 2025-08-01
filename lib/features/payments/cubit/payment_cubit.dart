import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(const PaymentState());

  void setLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  void setPaymentLoading(bool value) {
    emit(state.copyWith(isPaymentLoading: value));
  }

  void setPaymentStarted(bool value) {
    emit(state.copyWith(paymentStarted: value));
  }

  void setTransactionCompleted(bool value) {
    emit(state.copyWith(transactionCompleted: value));
  }

  void reset() {
    emit(const PaymentState());
  }
}
