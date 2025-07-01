class LpLoadAgreeResponse {
  LpLoadAgreeResponse({
    required this.success,
    required this.message,
    required this.lpLoadAgreeData,
  });

  final bool success;
  final String message;
  final LpLoadAgreeData? lpLoadAgreeData;

  LpLoadAgreeResponse copyWith({
    bool? success,
    String? message,
    LpLoadAgreeData? lpLoadAgreeData,
  }) {
    return LpLoadAgreeResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      lpLoadAgreeData: lpLoadAgreeData ?? this.lpLoadAgreeData,
    );
  }

  factory LpLoadAgreeResponse.fromJson(Map<String, dynamic> json){
    return LpLoadAgreeResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      lpLoadAgreeData: json["data"] == null ? null : LpLoadAgreeData.fromJson(json["data"]),
    );
  }

}

class LpLoadAgreeData {
  LpLoadAgreeData({
    required this.netFreight,
    required this.advance,
  });

  final int netFreight;
  final List<Advance> advance;

  LpLoadAgreeData copyWith({
    String? memoNumber,
    int? netFreight,
    List<Advance>? advance,
  }) {
    return LpLoadAgreeData(
      netFreight: netFreight ?? this.netFreight,
      advance: advance ?? this.advance,
    );
  }

  factory LpLoadAgreeData.fromJson(Map<String, dynamic> json){
    return LpLoadAgreeData(
      netFreight: json["netFreight"] ?? 0,
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
      amount: (json["amount"] ?? 0).toDouble(),

    );
  }

}
