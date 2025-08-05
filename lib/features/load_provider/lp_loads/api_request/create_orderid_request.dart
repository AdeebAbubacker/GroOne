import 'package:gro_one_app/data/model/serializable.dart';


class CreateOrderIdRequest extends Serializable<CreateOrderIdRequest> {
  CreateOrderIdRequest({
    required this.memoid,
    required this.lpId,
    required this.lpName,
    required this.lpEmailId,
    required this.lpMobile,
    required this.vpId,
    required this.memoNumber,
    required this.netFreight,
    required this.advance,
    required this.advancePercentage,
    required this.balance,
    required this.balancePercentage,
    required this.vpAdvance,
    required this.vpAdvancePercentage,
    required this.vpBalance,
    required this.vpBalancePercentage,
    required this.amount,
    required this.type,
    required this.action,
    required this.vpAmount,
  });

  final String memoid;
  final String lpId;
  final String lpName;
  final String lpEmailId;
  final String lpMobile;
  final String vpId;
  final String memoNumber;
  final String netFreight;
  final String advance;
  final String advancePercentage;
  final String balance;
  final String balancePercentage;
  final String vpAdvance;
  final String vpAdvancePercentage;
  final String vpBalance;
  final String vpBalancePercentage;
  final String amount;
  final String type;
  final String action;
  final String vpAmount;

  CreateOrderIdRequest copyWith({
    String? memoid,
    String? lpId,
    String? lpName,
    String? lpEmailId,
    String? lpMobile,
    String? vpId,
    String? memoNumber,
    String? netFreight,
    String? advance,
    String? advancePercentage,
    String? balance,
    String? balancePercentage,
    String? vpAdvance,
    String? vpAdvancePercentage,
    String? vpBalance,
    String? vpBalancePercentage,
    String? amount,
    String? type,
    String? action,
    String? vpAmount,
  }) {
    return CreateOrderIdRequest(
      memoid: memoid ?? this.memoid,
      lpId: lpId ?? this.lpId,
      lpName: lpName ?? this.lpName,
      lpEmailId: lpEmailId ?? this.lpEmailId,
      lpMobile: lpMobile ?? this.lpMobile,
      vpId: vpId ?? this.vpId,
      memoNumber: memoNumber ?? this.memoNumber,
      netFreight: netFreight ?? this.netFreight,
      advance: advance ?? this.advance,
      advancePercentage: advancePercentage ?? this.advancePercentage,
      balance: balance ?? this.balance,
      balancePercentage: balancePercentage ?? this.balancePercentage,
      vpAdvance: vpAdvance ?? this.vpAdvance,
      vpAdvancePercentage: vpAdvancePercentage ?? this.vpAdvancePercentage,
      vpBalance: vpBalance ?? this.vpBalance,
      vpBalancePercentage: vpBalancePercentage ?? this.vpBalancePercentage,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      action: action ?? this.action,
      vpAmount: vpAmount ?? this.vpAmount,
    );
  }

  factory CreateOrderIdRequest.fromJson(Map<String, dynamic> json){
    return CreateOrderIdRequest(
      memoid: json["memoid"] ?? "",
      lpId: json["lpId"] ?? "",
      lpName: json["lpName"] ?? "",
      lpEmailId: json["lpEmailId"] ?? "",
      lpMobile: json["lpMobile"] ?? "",
      vpId: json["vpId"] ?? "",
      memoNumber: json["memoNumber"] ?? "",
      netFreight: json["netFreight"] ?? 0,
      advance: json["advance"] ?? 0,
      advancePercentage: json["advancePercentage"] ?? 0,
      balance: json["balance"] ?? 0,
      balancePercentage: json["balancePercentage"] ?? 0,
      vpAdvance: json["vpAdvance"] ?? 0,
      vpAdvancePercentage: json["vpAdvancePercentage"] ?? 0,
      vpBalance: json["vpBalance"] ?? 0,
      vpBalancePercentage: json["vpBalancePercentage"] ?? 0,
      amount: json["amount"] ?? 0,
      type: json["type"] ?? "",
      action: json["action"] ?? "",
      vpAmount: json["vpAmount"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "memoid": memoid,
    "lpId": lpId,
    "lpName": lpName,
    "lpEmailId": lpEmailId,
    "lpMobile": lpMobile,
    "vpId": vpId,
    "memoNumber": memoNumber,
    "netFreight": netFreight,
    "advance": advance,
    "advancePercentage": advancePercentage,
    "balance": balance,
    "balancePercentage": balancePercentage,
    "vpAdvance": vpAdvance,
    "vpAdvancePercentage": vpAdvancePercentage,
    "vpBalance": vpBalance,
    "vpBalancePercentage": vpBalancePercentage,
    "amount": amount,
    "type": type,
    "action": action,
    "vpAmount": vpAmount,
  };

}
