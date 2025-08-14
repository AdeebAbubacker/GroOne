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
}

class TripStatementData {
  final String? loadId;
  final String? transporter;
  final String? vehicleNumber;
  final String? memoNumber;
  final String? lane;
  final String? totalFreight;
  final String? handlingCharges;
  final String? netFreight;
  final String? advanceAmount;
  final String? advancePercentage;
  final String? balancePercentage;
  final String? balanceAmount;
  final String? detentions;
  final LoadSettlement? loadSettlement;
  final String? balanceToBeReceived;
  final LoadProvider? loadProvider;
  final String? totalTransportationCost;
  final String? platformFee;
  final String? advanceReceived;

  TripStatementData({
    this.loadId,
    this.transporter,
    this.vehicleNumber,
    this.memoNumber,
    this.lane,
    this.totalFreight,
    this.handlingCharges,
    this.netFreight,
    this.advanceAmount,
    this.advancePercentage,
    this.balancePercentage,
    this.balanceAmount,
    this.detentions,
    this.loadSettlement,
    this.balanceToBeReceived,
    this.loadProvider,
    this.totalTransportationCost,
    this.platformFee,
    this.advanceReceived,
  });

  factory TripStatementData.fromJson(Map<String, dynamic> json) {
    return TripStatementData(
      advanceReceived:      json['advanceReceived']?.toString()??"",
      totalTransportationCost:json['totalTransportationCost']?.toString()??"" ,
      platformFee:json['platformFee']?.toString()??"" ,
      loadId: json['loadId'] as String?,
      transporter: json['shipper'] as String?,
      vehicleNumber: json['vehicleNumber'] as String?,
      memoNumber: json['memoNumber'] as String?,
      lane: json['lane'] as String?,
      totalFreight: json['totalFreight'] as String?,
      handlingCharges: json['handlingCharges'] as String?,
      netFreight: json['netFreight'] as String?,
      advanceAmount: json['advanceAmount'] as String?,
      advancePercentage: json['advancePercentage'] as String?,
      balancePercentage: json['balancePercentage'] as String?,
      balanceAmount: json['balanceAmount'] as String?,
      detentions: json['detentions'].toString(),
      loadSettlement: json['loadSettlement'] != null
          ? LoadSettlement.fromJson(json['loadSettlement'])
          : null,
      balanceToBeReceived: json['balanceToBeReceived'] as String?,
      loadProvider: json['loadProvider'] != null
          ? LoadProvider.fromJson(json['loadProvider'])
          : null,
    );
  }
}

class LoadSettlement {
  final String? settlementId;
  final String? vehicleId;
  final String? loadId;
  final int? noOfDays;
  final int? amountPerDay;
  final int? loadingCharge;
  final int? unloadingCharge;
  final int? debitDamages;
  final int? debitShortages;
  final int? debitPenalities;
  final DateTime? createdAt;
  final String? updatedAt;
  final String? deletedAt;


  LoadSettlement({
    this.settlementId,
    this.vehicleId,
    this.loadId,
    this.noOfDays,
    this.amountPerDay,
    this.loadingCharge,
    this.unloadingCharge,
    this.debitDamages,
    this.debitShortages,
    this.debitPenalities,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,

  });

  factory LoadSettlement.fromJson(Map<String, dynamic> json) {
    return LoadSettlement(
      settlementId: json['settlementId'] as String?,
      vehicleId: json['vehicleId'] as String?,
      loadId: json['loadId'] as String?,
      noOfDays: json['noOfDays'] as int?,
      amountPerDay: json['amountPerDay'] as int?,

      loadingCharge: json['loadingCharge'] as int?,
      unloadingCharge: json['unloadingCharge'] as int?,
      debitDamages: json['debitDamages'] as int?,
      debitShortages: json['debitShortages'] as int?,
      debitPenalities: json['debitPenalities'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
    );
  }
}

class LoadProvider {
  final String? name;
  final String? destination;
  final DateTime? unloadingDate;

  LoadProvider({
    this.name,
    this.destination,
    this.unloadingDate,
  });

  factory LoadProvider.fromJson(Map<String, dynamic> json) {
    return LoadProvider(
      name: json['name'] as String?,
      destination: json['destination'] as String?,
        unloadingDate: json['unloadingDate'] != null ? DateTime.tryParse(json['unloadingDate']) : null,

    );
  }
}
