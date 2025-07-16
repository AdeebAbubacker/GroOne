class LpLoadAgreeResponse {
  LpLoadAgreeResponse({
    required this.memoNumber,
    required this.netFreight,
    required this.loadId,
    required this.customerId,
    required this.advance,
  });

  final String memoNumber;
  final int netFreight;
  final String loadId;
  final String customerId;
  final List<Advance> advance;

  LpLoadAgreeResponse copyWith({
    String? memoNumber,
    int? netFreight,
    String? loadId,
    String? customerId,
    List<Advance>? advance,
  }) {
    return LpLoadAgreeResponse(
      memoNumber: memoNumber ?? this.memoNumber,
      netFreight: netFreight ?? this.netFreight,
      loadId: loadId ?? this.loadId,
      customerId: customerId ?? this.customerId,
      advance: advance ?? this.advance,
    );
  }

  factory LpLoadAgreeResponse.fromJson(Map<String, dynamic> json){
    return LpLoadAgreeResponse(
      memoNumber: json["memoNumber"] ?? "",
      netFreight: json["netFreight"] ?? 0,
      loadId: json["loadId"] ?? "",
      customerId: json["customerId"] ?? "",
      advance: json["advance"] == null ? [] : List<Advance>.from(json["advance"]!.map((x) => Advance.fromJson(x))),
    );
  }

}

class Advance {
  Advance({
    required this.percentageId,
    required this.percentage,
    required this.amount,
  });

  final int percentageId;
  final String percentage;
  final double amount;

  Advance copyWith({
    int? percentageId,
    String? percentage,
    double? amount,
  }) {
    return Advance(
      percentageId: percentageId ?? this.percentageId,
      percentage: percentage ?? this.percentage,
      amount: amount ?? this.amount,
    );
  }

  factory Advance.fromJson(Map<String, dynamic> json){
    return Advance(
      percentageId: json["percentageId"] ?? 0,
      percentage: json["percentage"] ?? "",
      amount: (json["amount"] as num?)?.toDouble() ?? 0.0,
    );
  }

}
