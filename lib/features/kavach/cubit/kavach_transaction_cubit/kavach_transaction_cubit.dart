import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_order_list_model.dart';
import '../../repository/kavach_repository.dart';

part 'kavach_transaction_state.dart';

class KavachTransactionsCubit extends Cubit<KavachTransactionsState> {
  final KavachRepository _repository;

  KavachTransactionsCubit(this._repository)
    : super(const KavachTransactionsInitial());

  Future<void> fetchTransactions({
    int fleetProductId = 2,
    int pageNo = 1,
  }) async {
    emit(const KavachTransactionsLoading());

    final result = await _repository.fetchCustomerOrders(
      fleetProductId: fleetProductId,
      page: pageNo,
    );

    if (result is Success<KavachOrderListResponse>) {
      // Flatten all payments
      final payments =
          result.value.orders.expand((order) => order.payments).toList();

      emit(KavachTransactionsLoaded(payments, result.value.meta.totalPages));
    } else if (result is Error<KavachOrderListResponse>) {
      emit(KavachTransactionsError(result.type));
    } else {
      emit(KavachTransactionsError(GenericError()));
    }
  }
}
