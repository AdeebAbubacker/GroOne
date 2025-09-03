class EndhanTransactionModel {
  final String? terminalID;
  final String? merchantId;
  final String? merchantName;
  final String? stateName;
  final String? customerID;
  final String? batchIDROC;
  final String? accountNumber;
  final String? vehicleNo;
  final String? transactionID;
  final String? transactionDate;
  final String? transactionType;
  final String? product;
  final String? price;
  final String? volume;
  final String? serviceCharge;
  final String? amount;
  final String? balance;
  final String? odometerReading;
  final String? settlementStatus;
  final String? settlementTime;

  EndhanTransactionModel({
    this.terminalID,
    this.merchantId,
    this.merchantName,
    this.stateName,
    this.customerID,
    this.batchIDROC,
    this.accountNumber,
    this.vehicleNo,
    this.transactionID,
    this.transactionDate,
    this.transactionType,
    this.product,
    this.price,
    this.volume,
    this.serviceCharge,
    this.amount,
    this.balance,
    this.odometerReading,
    this.settlementStatus,
    this.settlementTime,
  });

  factory EndhanTransactionModel.fromJson(Map<String, dynamic> json) {
    return EndhanTransactionModel(
      terminalID: json['terminalID']?.toString() ?? '',
      merchantId: json['MerchantId']?.toString() ?? '',
      merchantName: json['merchantName']?.toString() ?? '',
      stateName: json['StateName']?.toString() ?? '',
      customerID: json['customerID']?.toString() ?? '',
      batchIDROC: json['batchIDROC']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      vehicleNo: json['vehicleNo']?.toString(),
      transactionID: json['TransactionID']?.toString() ?? '',
      transactionDate: json['transactionDate']?.toString() ?? '',
      transactionType: json['transactionType']?.toString() ?? '',
      product: json['product']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      volume: json['volume']?.toString() ?? '',
      serviceCharge: json['serviceCharge']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      balance: json['balance']?.toString() ?? '',
      odometerReading: json['odometerReading']?.toString() ?? '',
      settlementStatus: json['SettlementStatus']?.toString() ?? '',
      settlementTime: json['SettlementTime']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'terminalID': terminalID,
      'MerchantId': merchantId,
      'merchantName': merchantName,
      'StateName': stateName,
      'customerID': customerID,
      'batchIDROC': batchIDROC,
      'accountNumber': accountNumber,
      'vehicleNo': vehicleNo,
      'TransactionID': transactionID,
      'transactionDate': transactionDate,
      'transactionType': transactionType,
      'product': product,
      'price': price,
      'volume': volume,
      'serviceCharge': serviceCharge,
      'amount': amount,
      'balance': balance,
      'odometerReading': odometerReading,
      'SettlementStatus': settlementStatus,
      'SettlementTime': settlementTime,
    };
  }

  // Helper method to get status for UI
  String get status {
    switch (settlementStatus?.toUpperCase()) {
      case 'PT':
      case 'SUCCESS':
        return 'Success';
      case 'PENDING':
        return 'Pending';
      case 'FAILED':
      case 'FAILURE':
        return 'Failed';
      case 'COMPLETED':
        return 'Completed';
      default:
        return 'Completed';
    }
  }

  // Helper method to check if transaction is successful
  bool get isSuccess {
    final status = settlementStatus?.toUpperCase();
    return status == 'PT' || 
           status == 'SUCCESS' || 
           status == 'COMPLETED';
  }

  // Helper method to parse transaction date
  DateTime? get parsedTransactionDate {
    try {
      // Parse date format: "29/06/2023 20:25:23"
      final parts = transactionDate?.split(' ');
      if (parts?.isNotEmpty ?? false) {
        final dateParts = parts![0].split('/');
        if (dateParts.length == 3) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          
          if (parts.length >= 2) {
            final timeParts = parts[1].split(':');
            if (timeParts.length >= 2) {
              final hour = int.parse(timeParts[0]);
              final minute = int.parse(timeParts[1]);
              return DateTime(year, month, day, hour, minute);
            }
          }
          
          return DateTime(year, month, day);
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // Helper method to get formatted amount
  double get amountValue {
    try {
      return double.parse(amount??"");
    } catch (e) {
      return 0.0;
    }
  }
}

class EndhanTransactionResponse {
  final bool success;
  final String message;
  final List<EndhanTransactionModel>? transactions;

  EndhanTransactionResponse({
    required this.success,
    required this.message,
   this.transactions,
  });

  factory EndhanTransactionResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as Map<String, dynamic>?;

      final document = data?['document'] as List<dynamic>?;

      final transactions = document?.map((item) {
        if (item is Map<String, dynamic>) {
          return EndhanTransactionModel.fromJson(item);
        } else {
          return null;
        }
      }).whereType<EndhanTransactionModel>().toList() ?? [];

      return EndhanTransactionResponse(
        success: json['success'] ?? false,
        message: json['message']?.toString() ?? '',
        transactions: transactions,
      );
    } catch (e) {
      return EndhanTransactionResponse(
        success: false,
        message: 'Error parsing response: $e',
        transactions: [],
      );
    }
  }
}

class EndhanTransactionRequest {
  final String customerId;
  final String fromDate;
  final String toDate;

  EndhanTransactionRequest({
    required this.customerId,
    required this.fromDate,
    required this.toDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'fromDate': fromDate,
      'toDate': toDate,
    };
  }
} 