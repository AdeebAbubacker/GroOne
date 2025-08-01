import 'package:equatable/equatable.dart';

class PaymentState extends Equatable {
  final bool isLoading;
  final bool isPaymentLoading;
  final bool paymentStarted;
  final bool transactionCompleted;

  const PaymentState({
    this.isLoading = true,
    this.isPaymentLoading = false,
    this.paymentStarted = false,
    this.transactionCompleted = false,
  });

  PaymentState copyWith({
    bool? isLoading,
    bool? isPaymentLoading,
    bool? paymentStarted,
    bool? transactionCompleted,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      isPaymentLoading: isPaymentLoading ?? this.isPaymentLoading,
      paymentStarted: paymentStarted ?? this.paymentStarted,
      transactionCompleted: transactionCompleted ?? this.transactionCompleted,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isPaymentLoading, paymentStarted, transactionCompleted];
}
