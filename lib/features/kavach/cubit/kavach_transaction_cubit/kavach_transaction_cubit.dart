import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/model/result.dart';
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
    if (_isClosed) return;
    
    print('🔍 KavachTransactionsCubit: Starting fetchTransactions');
    if (!_isClosed) {
      emit(const KavachTransactionsLoading());
    }
    
    try {
      final result = await _repository.fetchTransactions();
      print('🔍 KavachTransactionsCubit: Repository result type: ${result.runtimeType}');
      
      if (_isClosed) return;
      
      if (result is Success<List<KavachTransactionModel>>) {
        print('🔍 KavachTransactionsCubit: Success - ${result.value.length} transactions');
        print('🔍 KavachTransactionsCubit: First transaction: ${result.value.isNotEmpty ? result.value.first.orderId : 'No transactions'}');
        if (!_isClosed) {
          emit(KavachTransactionsLoaded(result.value));
        }
      } else if (result is Error<List<KavachTransactionModel>>) {
        print('🔍 KavachTransactionsCubit: Error - ${result.type}');
        if (!_isClosed) {
          emit(KavachTransactionsError(result.type));
        }
      } else {
        print('🔍 KavachTransactionsCubit: Unknown result type: ${result.runtimeType}');
        if (!_isClosed) {
          emit(KavachTransactionsError(GenericError()));
        }
      }
    } catch (e) {
      print('🔍 KavachTransactionsCubit: Exception - $e');
      if (!_isClosed) {
        emit(KavachTransactionsError(GenericError()));
      }
    }
  }
}

