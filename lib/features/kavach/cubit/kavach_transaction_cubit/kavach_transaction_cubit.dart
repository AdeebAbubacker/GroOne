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
        print('🔍 KavachTransactionsCubit: Success - ${result.value.length} transactions');
        emit(KavachTransactionsLoaded(result.value));
      } else if (result is Error<List<KavachTransactionModel>>) {
        print('🔍 KavachTransactionsCubit: Error - ${result.type}');
        emit(KavachTransactionsError(result.type));
      } else {
        print('🔍 KavachTransactionsCubit: Unknown result type');
        emit(KavachTransactionsError(GenericError()));
      }
    } catch (e) {
      print('🔍 KavachTransactionsCubit: Exception - $e');
      emit(KavachTransactionsError(GenericError()));
    }
  }
}

