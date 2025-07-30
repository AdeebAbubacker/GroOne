import '../../../load_provider/lp_loads/model/lp_load_memo_response.dart';

class TripStatementResponse {
  String? message;
  MemoDetails? memoDetails;


  TripStatementResponse.fromJson(Map<String,dynamic> json){
    message=json['message'];
    memoDetails=MemoDetails.fromJson(json['data']);
  }

}


class MemoDetails {
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
  final BankDetails? bankDetails;
  final TruckSupplier? truckSupplier;

  MemoDetails({
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
    this.bankDetails,
    this.truckSupplier,
  });

  factory MemoDetails.fromJson(Map<String, dynamic> json) {
    return MemoDetails(
      loadId: json['loadId'],
      transporter: json['transporter'],
      vehicleNumber: json['vehicleNumber'],
      memoNumber: json['memoNumber'],
      lane: json['lane'],
      totalFreight: json['totalFreight'],
      handlingCharges: json['handlingCharges'],
      netFreight: json['netFreight'],
      advanceAmount: json['advanceAmount'],
      advancePercentage: json['advancePercentage'],
      balancePercentage: json['balancePercentage'],
      balanceAmount: json['balanceAmount'],
      bankDetails: json['bankDetails'] != null
          ? BankDetails.fromJson(json['bankDetails'])
          : null,
      truckSupplier: json['truckSupplier'] != null
          ? TruckSupplier.fromJson(json['truckSupplier'])
          : null,
    );
  }
}



class TruckSupplier {
  final String? partnerName;
  final String? vehicleNumber;
  final String? panNumber;

  TruckSupplier({
    this.partnerName,
    this.vehicleNumber,
    this.panNumber,
  });

  factory TruckSupplier.fromJson(Map<String, dynamic> json) {
    return TruckSupplier(
      partnerName: json['partnerName'],
      vehicleNumber: json['vehicleNumber'],
      panNumber: json['panNumber'],
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
  final DateTime? updatedAt;
  final DateTime? deletedAt;

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
      settlementId: json['settlementId'],
      vehicleId: json['vehicleId'],
      loadId: json['loadId'],
      noOfDays: json['noOfDays'],
      amountPerDay: json['amountPerDay'],
      loadingCharge: json['loadingCharge'],
      unloadingCharge: json['unloadingCharge'],
      debitDamages: json['debitDamages'],
      debitShortages: json['debitShortages'],
      debitPenalities: json['debitPenalities'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
    );
  }
}

