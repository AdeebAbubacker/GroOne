import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_order_list_model.dart';
import '../../model/kavach_transaction_model.dart';
import '../../repository/kavach_repository.dart';
part 'kavach_transaction_state.dart';

class KavachTransactionsCubit extends Cubit<KavachTransactionsState> {
  final KavachRepository _repository;
  bool _isClosed = false;

  KavachTransactionsCubit(this._repository)
      : super(const KavachTransactionsInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(const KavachTransactionsInitial());
  }

  Future<void> fetchTransactions() async {
    emit(const KavachTransactionsLoading());

    final result = await _repository.fetchCustomerOrders();

    if (result is Success<KavachOrderListResponse>) {
      // Flatten all payments
      final payments = result.value.orders
          .expand((order) => order.payments)
          .toList();

      emit(KavachTransactionsLoaded(payments));
    } else if (result is Error<KavachOrderListResponse>) {
      emit(KavachTransactionsError(result.type));
    } else {
      emit(KavachTransactionsError(GenericError()));
    }
  }


}

