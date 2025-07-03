class EnDhanBaseResponse<T> {
  final bool success;
  final String message;
  final T data;

  const EnDhanBaseResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EnDhanBaseResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return EnDhanBaseResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT(json['data']),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': toJsonT(data),
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

// State response models
class EnDhanStateResponse {
  final List<EnDhanState> document;

  const EnDhanStateResponse({required this.document});

  factory EnDhanStateResponse.fromJson(Map<String, dynamic> json) {
    return EnDhanStateResponse(
      document: (json['data']?['document'] as List<dynamic>?)
          ?.map((e) => EnDhanState.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class EnDhanState {
  final int id;
  final String name;

  const EnDhanState({required this.id, required this.name});

  factory EnDhanState.fromJson(Map<String, dynamic> json) {
    return EnDhanState(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

// Zonal response models
class EnDhanZonalResponse {
  final List<EnDhanZonal> document;

  const EnDhanZonalResponse({required this.document});

  factory EnDhanZonalResponse.fromJson(Map<String, dynamic> json) {
    return EnDhanZonalResponse(
      document: (json['data']?['document'] as List<dynamic>?)
          ?.map((e) => EnDhanZonal.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class EnDhanZonal {
  final int id;
  final String zoneName;

  const EnDhanZonal({required this.id, required this.zoneName});

  factory EnDhanZonal.fromJson(Map<String, dynamic> json) {
    return EnDhanZonal(
      id: json['id'] ?? 0,
      zoneName: json['zone_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'zone_name': zoneName,
  };
}

// District response models
class EnDhanDistrictResponse {
  final List<EnDhanDistrict> document;

  const EnDhanDistrictResponse({required this.document});

  factory EnDhanDistrictResponse.fromJson(Map<String, dynamic> json) {
    return EnDhanDistrictResponse(
      document: (json['data']?['document'] as List<dynamic>?)
          ?.map((e) => EnDhanDistrict.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class EnDhanDistrict {
  final int id;
  final int stateId;
  final String districtName;

  const EnDhanDistrict({
    required this.id,
    required this.stateId,
    required this.districtName,
  });

  factory EnDhanDistrict.fromJson(Map<String, dynamic> json) {
    return EnDhanDistrict(
      id: json['id'] ?? 0,
      stateId: json['state_id'] ?? 0,
      districtName: json['district_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'state_id': stateId,
    'district_name': districtName,
  };
}

// Regional response models
class EnDhanRegionalResponse {
  final List<EnDhanRegional> document;

  const EnDhanRegionalResponse({required this.document});

  factory EnDhanRegionalResponse.fromJson(Map<String, dynamic> json) {
    return EnDhanRegionalResponse(
      document: (json['data']?['document'] as List<dynamic>?)
          ?.map((e) => EnDhanRegional.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class EnDhanRegional {
  final int id;
  final int zoneId;
  final String regionName;

  const EnDhanRegional({
    required this.id,
    required this.zoneId,
    required this.regionName,
  });

  factory EnDhanRegional.fromJson(Map<String, dynamic> json) {
    return EnDhanRegional(
      id: json['id'] ?? 0,
      zoneId: json['zone_id'] ?? 0,
      regionName: json['region_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'zone_id': zoneId,
    'region_name': regionName,
  };
}

// Vehicle Type response models
class EnDhanVehicleTypeResponse {
  final List<String> document;

  const EnDhanVehicleTypeResponse({required this.document});

  factory EnDhanVehicleTypeResponse.fromJson(Map<String, dynamic> json) {
    return EnDhanVehicleTypeResponse(
      document: (json['data']?['document'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }
}

// Customer Creation Response
class EnDhanCustomerCreationResponse {
  final bool success;
  final String message;
  final dynamic data;

  const EnDhanCustomerCreationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EnDhanCustomerCreationResponse.fromJson(Map<String, dynamic> json) {
    return EnDhanCustomerCreationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}

/// Card List Response
class EnDhanCardListModel {
  final bool success;
  final String message;
  final List<EnDhanCardModel>? data;

  const EnDhanCardListModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory EnDhanCardListModel.fromJson(Map<String, dynamic> json) {
    print('🔍 EnDhanCardListModel.fromJson called with: $json');
    List<EnDhanCardModel>? cardList;
    
    // Handle the actual API response structure
    if (json['document'] != null && json['document'] is List) {
      print('🔍 Found document field with list: ${json['document']}');
      // API returns data in 'document' field
      cardList = (json['document'] as List).map((item) => EnDhanCardModel.fromJson(item)).toList();
    } else if (json['data'] != null) {
      print('🔍 Found data field: ${json['data']}');
      if (json['data'] is List) {
        print('🔍 Data is a list, parsing ${(json['data'] as List).length} items');
        // If data is a list, parse each item as a card
        cardList = (json['data'] as List).map((item) => EnDhanCardModel.fromJson(item)).toList();
      } else if (json['data'] is Map<String, dynamic>) {
        // If data is a map, it might contain a list field or be a single card
        final dataMap = json['data'] as Map<String, dynamic>;
        
        // Check if this is an error response
        if (dataMap.containsKey('error') || dataMap.containsKey('status') || dataMap.containsKey('code')) {
          // This is an error response, return empty list
          cardList = [];
        } else if (dataMap.containsKey('document') && dataMap['document'] is List) {
          // If there's a 'document' field that's a list
          cardList = (dataMap['document'] as List).map((item) => EnDhanCardModel.fromJson(item)).toList();
        } else if (dataMap.containsKey('cards') && dataMap['cards'] is List) {
          // If there's a 'cards' field that's a list
          cardList = (dataMap['cards'] as List).map((item) => EnDhanCardModel.fromJson(item)).toList();
        } else if (dataMap.containsKey('data') && dataMap['data'] is List) {
          // If there's a nested 'data' field that's a list
          cardList = (dataMap['data'] as List).map((item) => EnDhanCardModel.fromJson(item)).toList();
        } else if (dataMap.containsKey('items') && dataMap['items'] is List) {
          // If there's an 'items' field that's a list
          cardList = (dataMap['items'] as List).map((item) => EnDhanCardModel.fromJson(item)).toList();
        } else {
          // If data is a single card object
          try {
            cardList = [EnDhanCardModel.fromJson(dataMap)];
          } catch (e) {
            // If parsing fails, return empty list
            cardList = [];
          }
        }
      } else if (json['data'] is String) {
        // If data is a string (error message), return empty list
        cardList = [];
      }
    }
    
    return EnDhanCardListModel(
      success: json['success'] ?? true, // Default to true since API doesn't return success field
      message: json['message'] ?? '',
      data: cardList ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'EnDhanCardListModel{success: $success, message: $message, data: $data}';
  }
}

/// Individual Card Model
class EnDhanCardModel {
  final String? cardId;
  final String? cardNumber;
  final String? vehicleNumber;
  final String? status;
  final double? amount;
  final String? mobile;
  final String? dateTime;
  final String? cardHolderName;
  final String? cardType;
  final String? expiryDate;
  final double? balance;
  final String? createdAt;
  final String? updatedAt;

  const EnDhanCardModel({
    this.cardId,
    this.cardNumber,
    this.vehicleNumber,
    this.status,
    this.amount,
    this.mobile,
    this.dateTime,
    this.cardHolderName,
    this.cardType,
    this.expiryDate,
    this.balance,
    this.createdAt,
    this.updatedAt,
  });

  factory EnDhanCardModel.fromJson(Map<String, dynamic> json) {
    return EnDhanCardModel(
      cardId: json['id']?.toString(), // API uses 'id'
      cardNumber: json['cardNo'] as String?, // API uses 'cardNo'
      vehicleNumber: json['vehicleNo'] as String?, // API uses 'vehicleNo'
      status: 'Active', // Default status since API doesn't provide it
      amount: null, // API doesn't provide amount
      mobile: json['cardMobileNo'] as String?, // API uses 'cardMobileNo'
      dateTime: json['createdAt'] as String?, // Use createdAt as dateTime
      cardHolderName: null, // API doesn't provide cardHolderName
      cardType: json['vehicleType'] as String?, // API uses 'vehicleType'
      expiryDate: null, // API doesn't provide expiryDate
      balance: null, // API doesn't provide balance
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cardId': cardId,
      'cardNumber': cardNumber,
      'vehicleNumber': vehicleNumber,
      'status': status,
      'amount': amount,
      'mobile': mobile,
      'dateTime': dateTime,
      'cardHolderName': cardHolderName,
      'cardType': cardType,
      'expiryDate': expiryDate,
      'balance': balance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'EnDhanCardModel{cardId: $cardId, cardNumber: $cardNumber, vehicleNumber: $vehicleNumber, status: $status, amount: $amount, mobile: $mobile, dateTime: $dateTime}';
  }
} 