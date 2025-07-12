import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_transaction_model.dart';
import '../../repository/kavach_repository.dart';
part 'kavach_transaction_state.dart';

class KavachTransactionsCubit extends Cubit<KavachTransactionsState> {
  final KavachRepository _repository;

  KavachTransactionsCubit(this._repository)
      : super(const KavachTransactionsInitial());

  Future<void> fetchTransactions() async {
    emit(const KavachTransactionsLoading());
    try {
      final result = await _repository.fetchTransactions();
      if (result is Success<List<KavachTransactionModel>>) {
        emit(KavachTransactionsLoaded(result.value));
      } else if (result is Error<List<KavachTransactionModel>>) {
        emit(KavachTransactionsError(result.type));
      } else {
        emit(KavachTransactionsError(GenericError()));
      }
    } catch (e) {
      emit(KavachTransactionsError(GenericError()));
    }
  }
}

