
class EnDhanBaseResponse<T> {
  final bool success;
  final String message;
  final T? data;

  const EnDhanBaseResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory EnDhanBaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return EnDhanBaseResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data!) : null,
    };
  }

  @override
  String toString() {
    return 'EnDhanBaseResponse{success: $success, message: $message, data: $data}';
  }
}

/// Card Creation Response
class EnDhanCardCreationModel {
  final String? cardId;
  final String? cardNumber;
  final String? cardHolderName;
  final String? cardType;
  final String? expiryDate;
  final double? balance;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const EnDhanCardCreationModel({
    this.cardId,
    this.cardNumber,
    this.cardHolderName,
    this.cardType,
    this.expiryDate,
    this.balance,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory EnDhanCardCreationModel.fromJson(Map<String, dynamic> json) {
    return EnDhanCardCreationModel(
      cardId: json['cardId'] as String?,
      cardNumber: json['cardNumber'] as String?,
      cardHolderName: json['cardHolderName'] as String?,
      cardType: json['cardType'] as String?,
      expiryDate: json['expiryDate'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cardId': cardId,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'cardType': cardType,
      'expiryDate': expiryDate,
      'balance': balance,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'EnDhanCardCreationModel{cardId: $cardId, cardNumber: $cardNumber, cardHolderName: $cardHolderName, cardType: $cardType, expiryDate: $expiryDate, balance: $balance, status: $status, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

/// Card Balance Response
class EnDhanCardBalanceModel {
  final String? cardId;
  final String? cardNumber;
  final double? availableBalance;
  final double? totalBalance;
  final String? currency;
  final String? lastUpdated;

  const EnDhanCardBalanceModel({
    this.cardId,
    this.cardNumber,
    this.availableBalance,
    this.totalBalance,
    this.currency,
    this.lastUpdated,
  });

  factory EnDhanCardBalanceModel.fromJson(Map<String, dynamic> json) {
    return EnDhanCardBalanceModel(
      cardId: json['cardId'] as String?,
      cardNumber: json['cardNumber'] as String?,
      availableBalance: (json['availableBalance'] as num?)?.toDouble(),
      totalBalance: (json['totalBalance'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      lastUpdated: json['lastUpdated'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cardId': cardId,
      'cardNumber': cardNumber,
      'availableBalance': availableBalance,
      'totalBalance': totalBalance,
      'currency': currency,
      'lastUpdated': lastUpdated,
    };
  }

  @override
  String toString() {
    return 'EnDhanCardBalanceModel{cardId: $cardId, cardNumber: $cardNumber, availableBalance: $availableBalance, totalBalance: $totalBalance, currency: $currency, lastUpdated: $lastUpdated}';
  }
}

/// Fuel Purchase Response
class EnDhanFuelPurchaseModel {
  final String? transactionId;
  final String? cardId;
  final double? amount;
  final String? fuelType;
  final String? stationId;
  final String? stationName;
  final String? vehicleNumber;
  final String? odometerReading;
  final String? transactionDate;
  final String? status;

  const EnDhanFuelPurchaseModel({
    this.transactionId,
    this.cardId,
    this.amount,
    this.fuelType,
    this.stationId,
    this.stationName,
    this.vehicleNumber,
    this.odometerReading,
    this.transactionDate,
    this.status,
  });

  factory EnDhanFuelPurchaseModel.fromJson(Map<String, dynamic> json) {
    return EnDhanFuelPurchaseModel(
      transactionId: json['transactionId'] as String?,
      cardId: json['cardId'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      fuelType: json['fuelType'] as String?,
      stationId: json['stationId'] as String?,
      stationName: json['stationName'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      odometerReading: json['odometerReading'] as String?,
      transactionDate: json['transactionDate'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'cardId': cardId,
      'amount': amount,
      'fuelType': fuelType,
      'stationId': stationId,
      'stationName': stationName,
      'vehicleNumber': vehicleNumber,
      'odometerReading': odometerReading,
      'transactionDate': transactionDate,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'EnDhanFuelPurchaseModel{transactionId: $transactionId, cardId: $cardId, amount: $amount, fuelType: $fuelType, stationId: $stationId, stationName: $stationName, vehicleNumber: $vehicleNumber, odometerReading: $odometerReading, transactionDate: $transactionDate, status: $status}';
  }
}

/// Transaction History Response
class EnDhanTransactionHistoryModel {
  final List<EnDhanTransaction>? transactions;
  final int? totalCount;
  final int? currentPage;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  const EnDhanTransactionHistoryModel({
    this.transactions,
    this.totalCount,
    this.currentPage,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory EnDhanTransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    return EnDhanTransactionHistoryModel(
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) => EnDhanTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int?,
      currentPage: json['currentPage'] as int?,
      totalPages: json['totalPages'] as int?,
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'transactions': transactions?.map((e) => e.toJson()).toList(),
      'totalCount': totalCount,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  @override
  String toString() {
    return 'EnDhanTransactionHistoryModel{transactions: $transactions, totalCount: $totalCount, currentPage: $currentPage, totalPages: $totalPages, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage}';
  }
}

/// Individual Transaction Model
class EnDhanTransaction {
  final String? transactionId;
  final String? cardId;
  final String? cardNumber;
  final double? amount;
  final String? fuelType;
  final String? stationId;
  final String? stationName;
  final String? vehicleNumber;
  final String? odometerReading;
  final String? transactionDate;
  final String? status;
  final String? description;

  const EnDhanTransaction({
    this.transactionId,
    this.cardId,
    this.cardNumber,
    this.amount,
    this.fuelType,
    this.stationId,
    this.stationName,
    this.vehicleNumber,
    this.odometerReading,
    this.transactionDate,
    this.status,
    this.description,
  });

  factory EnDhanTransaction.fromJson(Map<String, dynamic> json) {
    return EnDhanTransaction(
      transactionId: json['transactionId'] as String?,
      cardId: json['cardId'] as String?,
      cardNumber: json['cardNumber'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      fuelType: json['fuelType'] as String?,
      stationId: json['stationId'] as String?,
      stationName: json['stationName'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      odometerReading: json['odometerReading'] as String?,
      transactionDate: json['transactionDate'] as String?,
      status: json['status'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'transactionId': transactionId,
      'cardId': cardId,
      'cardNumber': cardNumber,
      'amount': amount,
      'fuelType': fuelType,
      'stationId': stationId,
      'stationName': stationName,
      'vehicleNumber': vehicleNumber,
      'odometerReading': odometerReading,
      'transactionDate': transactionDate,
      'status': status,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'EnDhanTransaction{transactionId: $transactionId, cardId: $cardId, cardNumber: $cardNumber, amount: $amount, fuelType: $fuelType, stationId: $stationId, stationName: $stationName, vehicleNumber: $vehicleNumber, odometerReading: $odometerReading, transactionDate: $transactionDate, status: $status, description: $description}';
  }
} 