class TripStatementResponse {
  final String? message;
  final TripStatementData? data;

  TripStatementResponse({this.message, this.data});

  factory TripStatementResponse.fromJson(Map<String, dynamic> json) {
    return TripStatementResponse(
      message: json['message'] as String?,
      data: json['data'] != null
          ? TripStatementData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class TripStatementData {
  final String? loadId;
  final String? shipper;
  final String? vehicleNumber;
  final String? memoNumber;
  final String? lane;
  final String? totalTransportationCost;
  final String? advanceAmount;
  final String? advancePercentage;
  final String? damages;
  final String? shortages;
  final String? penalties;
  final String? platformFee;
  final int? platformFeeGstPercentage;
  final String? platformFeeWithGst;
  final String? loading;
  final String? unloading;
  final String? detentions;
  final String? advanceReceived;
  final String? balanceToBeReceived;
  final LoadProvider? loadProvider;

  TripStatementData({
    this.loadId,
    this.shipper,
    this.vehicleNumber,
    this.memoNumber,
    this.lane,
    this.totalTransportationCost,
    this.advanceAmount,
    this.advancePercentage,
    this.damages,
    this.shortages,
    this.penalties,
    this.platformFee,
    this.platformFeeGstPercentage,
    this.platformFeeWithGst,
    this.loading,
    this.unloading,
    this.detentions,

    this.advanceReceived,
    this.balanceToBeReceived,
    this.loadProvider,
  });

  factory TripStatementData.fromJson(Map<String, dynamic> json) {
    return TripStatementData(
      loadId: json['loadId'] as String?,
      shipper: json['shipper'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      memoNumber: json['memoNumber'] as String?,
      lane: json['lane'] as String?,
      totalTransportationCost: json['totalTransportationCost'] as String?,
      advanceAmount: json['advanceAmount'] as String?,
      advancePercentage: json['advancePercentage'] as String?,
      damages: json['damages'] as String?,
      shortages: json['shortages'] as String?,
      penalties: json['penalties'] as String?,
      platformFee: json['platformFee'] as String?,
      platformFeeGstPercentage: json['platformFeeGstPercentage'] as int?,
      platformFeeWithGst: json['platformFeeWithGst'] as String?,
      loading: json['loading'] as String?,
      unloading: json['unloading'] as String?,
      detentions: json['detentions'] as String?,

      advanceReceived: json['advanceReceived'] as String?,
      balanceToBeReceived: json['balanceToBeReceived'] as String?,
      loadProvider: json['loadProvider'] != null
          ? LoadProvider.fromJson(json['loadProvider'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loadId': loadId,
      'shipper': shipper,
      'vehicleNumber': vehicleNumber,
      'memoNumber': memoNumber,
      'lane': lane,
      'totalTransportationCost': totalTransportationCost,
      'advanceAmount': advanceAmount,
      'advancePercentage': advancePercentage,
      'damages': damages,
      'shortages': shortages,
      'penalties': penalties,
      'platformFee': platformFee,
      'platformFeeGstPercentage': platformFeeGstPercentage,
      'platformFeeWithGst': platformFeeWithGst,
      'loading': loading,
      'unloading': unloading,
      'detentions': detentions,
      'advanceReceived': advanceReceived,
      'balanceToBeReceived': balanceToBeReceived,
      'loadProvider': loadProvider?.toJson(),
    };
  }
}

class LoadProvider {
  final String? name;
  final String? destination;
  final DateTime? unloadingDate;

  LoadProvider({this.name, this.destination, this.unloadingDate});

  factory LoadProvider.fromJson(Map<String, dynamic> json) {
    return LoadProvider(
      name: json['name'] as String?,
      destination: json['destination'] as String?,
      unloadingDate: json['unloadingDate'] != null
          ? DateTime.tryParse(json['unloadingDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'destination': destination,
      'unloadingDate': unloadingDate?.toIso8601String(),
    };
  }
}
