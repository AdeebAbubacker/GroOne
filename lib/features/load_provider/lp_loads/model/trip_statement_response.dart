import 'lp_load_get_by_id_response.dart' hide BankDetails;
import 'lp_load_memo_response.dart';

class TripStatementResponse {
  TripStatementResponse({
    required this.message,
    required this.data,
  });

  final String message;
  final TripDetails? data;

  TripStatementResponse copyWith({
    String? message,
    TripDetails? data,
  }) {
    return TripStatementResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory TripStatementResponse.fromJson(Map<String, dynamic> json){
    return TripStatementResponse(
      message: json["message"] ?? "",
      data: json["data"] == null ? null : TripDetails.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
  };

}

class TripDetails {
  TripDetails({
    required this.loadId,
    required this.transporter,
    required this.vehicleNumber,
    required this.memoNumber,
    required this.lane,
    required this.totalFreight,
    required this.handlingCharges,
    required this.netFreight,
    required this.advanceAmount,
    required this.advancePercentage,
    required this.balancePercentage,
    required this.balanceAmount,
    required this.detentions,
    required this.loadSettlement,
    required this.balanceToBePaid,
    required this.bankDetails,
    required this.truckSupplier,
  });

  final String loadId;
  final String transporter;
  final String vehicleNumber;
  final String memoNumber;
  final String lane;
  final String totalFreight;
  final String handlingCharges;
  final String netFreight;
  final String advanceAmount;
  final String advancePercentage;
  final String balancePercentage;
  final String balanceAmount;
  final String detentions;
  final LoadSettlement? loadSettlement;
  final String balanceToBePaid;
  final BankDetails? bankDetails;
  final TruckSupplier? truckSupplier;

  TripDetails copyWith({
    String? loadId,
    String? transporter,
    String? vehicleNumber,
    String? memoNumber,
    String? lane,
    String? totalFreight,
    String? handlingCharges,
    String? netFreight,
    String? advanceAmount,
    String? advancePercentage,
    String? balancePercentage,
    String? balanceAmount,
    String? detentions,
    LoadSettlement? loadSettlement,
    String? balanceToBePaid,
    BankDetails? bankDetails,
    TruckSupplier? truckSupplier,
  }) {
    return TripDetails(
      loadId: loadId ?? this.loadId,
      transporter: transporter ?? this.transporter,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      memoNumber: memoNumber ?? this.memoNumber,
      lane: lane ?? this.lane,
      totalFreight: totalFreight ?? this.totalFreight,
      handlingCharges: handlingCharges ?? this.handlingCharges,
      netFreight: netFreight ?? this.netFreight,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      balancePercentage: balancePercentage ?? this.balancePercentage,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      detentions: detentions ?? this.detentions,
      loadSettlement: loadSettlement ?? this.loadSettlement,
      balanceToBePaid: balanceToBePaid ?? this.balanceToBePaid,
      bankDetails: bankDetails ?? this.bankDetails,
      truckSupplier: truckSupplier ?? this.truckSupplier,
    );
  }

  factory TripDetails.fromJson(Map<String, dynamic> json){
    return TripDetails(
      loadId: json["loadId"] ?? "",
      transporter: json["transporter"] ?? "",
      vehicleNumber: json["vehicleNumber"] ?? "",
      memoNumber: json["memoNumber"] ?? "",
      lane: json["lane"] ?? "",
      totalFreight: json["totalFreight"] ?? "",
      handlingCharges: json["handlingCharges"] ?? "",
      netFreight: json["netFreight"] ?? "",
      advanceAmount: json["advanceAmount"] ?? "",
      advancePercentage: json["advancePercentage"] ?? "",
      balancePercentage: json["balancePercentage"] ?? "",
      balanceAmount: json["balanceAmount"] ?? "",
      detentions: json["detentions"] ?? "",
      loadSettlement: json["loadSettlement"] == null ? null : LoadSettlement.fromJson(json["loadSettlement"]),
      balanceToBePaid: json["balanceToBePaid"] ?? "",
      bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
      truckSupplier: json["truckSupplier"] == null ? null : TruckSupplier.fromJson(json["truckSupplier"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "loadId": loadId,
    "transporter": transporter,
    "vehicleNumber": vehicleNumber,
    "memoNumber": memoNumber,
    "lane": lane,
    "totalFreight": totalFreight,
    "handlingCharges": handlingCharges,
    "netFreight": netFreight,
    "advanceAmount": advanceAmount,
    "advancePercentage": advancePercentage,
    "balancePercentage": balancePercentage,
    "balanceAmount": balanceAmount,
    "detentions": detentions,
    "loadSettlement": loadSettlement,
    "balanceToBePaid": balanceToBePaid,
    "bankDetails": bankDetails,
    "truckSupplier": truckSupplier,
  };

}
