import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import '../model/endhan_transaction_model.dart';

class EndhanTransactionService {
  final ApiService _apiService;

  EndhanTransactionService(this._apiService);

  Future<Result<EndhanTransactionResponse>> getTransactions({
    required String customerId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final request = EndhanTransactionRequest(
        customerId: customerId,
        fromDate: fromDate,
        toDate: toDate,
      );

      CustomLog.debug(this, "En-Dhan Transaction Request: ${request.toJson()}");

      final result = await _apiService.post(
        '/vendor/api/v1/dtplus/getTransaction',
        body: request.toJson(),
      );

      if (result is Success) {
        try {
          final data = result.value as Map<String, dynamic>;
          CustomLog.debug(this, "API Response: $data");
          final transactionResponse = EndhanTransactionResponse.fromJson(data);
          
          if (transactionResponse.success) {
            CustomLog.debug(this, "En-Dhan Transaction Response: ${transactionResponse.transactions?.length} transactions");
            return Success(transactionResponse);
          } else {
            return Error(ErrorWithMessage(message: transactionResponse.message));
          }
        } catch (parseError) {
          CustomLog.error(this, "Error parsing transaction response", parseError);
          return Error(ErrorWithMessage(message: 'Error parsing response data'));
        }
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(ErrorWithMessage(message: 'Failed to fetch transactions'));
      }
    } catch (e) {
      final errorMessage = e?.toString() ?? 'Unknown error occurred';
      CustomLog.error(this, "Error fetching En-Dhan transactions", e);
      return Error(ErrorWithMessage(message: errorMessage));
    }
  }
} 