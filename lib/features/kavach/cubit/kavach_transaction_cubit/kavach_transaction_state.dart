part of 'kavach_transaction_cubit.dart';

abstract class KavachTransactionsState extends Equatable {
  const KavachTransactionsState();

  @override
  List<Object?> get props => [];
}

class KavachTransactionsInitial extends KavachTransactionsState {
  const KavachTransactionsInitial();
}

class KavachTransactionsLoading extends KavachTransactionsState {
  const KavachTransactionsLoading();
}

class KavachTransactionsLoaded extends KavachTransactionsState {
  final List<KavachOrderListPayment> transactions;

  const KavachTransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class KavachTransactionsError extends KavachTransactionsState {
  final ErrorType message;

  const KavachTransactionsError(this.message);

  @override
  List<Object?> get props => [message];
}
