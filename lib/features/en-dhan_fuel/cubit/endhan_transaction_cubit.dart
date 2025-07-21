import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/endhan_transaction_model.dart';
import 'package:gro_one_app/features/en-dhan_fuel/service/endhan_transaction_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:intl/intl.dart';

// Events
abstract class EndhanTransactionEvent {}

class FetchEndhanTransactions extends EndhanTransactionEvent {
  final DateTime fromDate;
  final DateTime toDate;

  FetchEndhanTransactions({
    required this.fromDate,
    required this.toDate,
  });
}

// States
abstract class EndhanTransactionState {}

class EndhanTransactionInitial extends EndhanTransactionState {}

class EndhanTransactionLoading extends EndhanTransactionState {}

class EndhanTransactionLoaded extends EndhanTransactionState {
  final List<EndhanTransactionModel> transactions;

  EndhanTransactionLoaded(this.transactions);
}

class EndhanTransactionEmpty extends EndhanTransactionState {}

class EndhanTransactionError extends EndhanTransactionState {
  final String message;

  EndhanTransactionError(this.message);
}

// Cubit
class EndhanTransactionCubit extends Cubit<EndhanTransactionState> {
  final EndhanTransactionService _service;
  final UserInformationRepository _userRepository;
  bool _isClosed = false;

  EndhanTransactionCubit(this._service, this._userRepository) 
      : super(EndhanTransactionInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(EndhanTransactionInitial());
  }

  Future<void> fetchTransactions({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    if (_isClosed) return;
    
    if (!_isClosed) {
      emit(EndhanTransactionLoading());
    }
    
    try {
      // Get customer ID
      final customerId = await _userRepository.getUserID();
      CustomLog.debug(this, "Customer ID: $customerId");
      
      if (_isClosed) return;
      
      if (customerId == null || customerId.isEmpty) {
        // Show empty state instead of error
        if (!_isClosed) {
          emit(EndhanTransactionEmpty());
        }
        return;
      }

      // Format dates to yyyyMMdd format
      final fromDateStr = DateFormat('yyyyMMdd').format(fromDate);
      final toDateStr = DateFormat('yyyyMMdd').format(toDate);

      CustomLog.debug(this, "Fetching transactions from $fromDateStr to $toDateStr for customer: $customerId");

      final result = await _service.getTransactions(
        customerId: customerId,
        fromDate: fromDateStr,
        toDate: toDateStr,
      );

      if (_isClosed) return;

      if (result is Success<EndhanTransactionResponse>) {
        final response = result.value;
        if (response.transactions?.isNotEmpty ?? false) {
          if (!_isClosed) {
            emit(EndhanTransactionLoaded(response.transactions!));
          }
        } else {
          if (!_isClosed) {
            emit(EndhanTransactionEmpty());
          }
        }
      } else if (result is Error<EndhanTransactionResponse>) {
        // Show empty state instead of error
        if (!_isClosed) {
          emit(EndhanTransactionEmpty());
        }
      }
    } catch (e) {
      CustomLog.error(this, "Error in fetchTransactions", e);
      // Show empty state instead of error
      if (!_isClosed) {
        emit(EndhanTransactionEmpty());
      }
    }
  }

  void resetState() {
    if (!_isClosed) {
      emit(EndhanTransactionInitial());
    }
  }
} 