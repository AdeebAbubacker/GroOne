class SettlementApiRequest {
  SettlementApiRequest({
    required this.vehicleId,
    required this.loadId,
    required this.noOfDays,
    required this.amountPerDay,
    required this.loadingCharge,
    required this.unloadingCharge,
  });

  final String vehicleId;
  final String loadId;
  final int noOfDays;
  final int amountPerDay;
  final int loadingCharge;
  final int unloadingCharge;

  SettlementApiRequest copyWith({
    String? vehicleId,
    String? loadId,
    int? noOfDays,
    int? amountPerDay,
    int? loadingCharge,
    int? unloadingCharge,
  }) {
    return SettlementApiRequest(
      vehicleId: vehicleId ?? this.vehicleId,
      loadId: loadId ?? this.loadId,
      noOfDays: noOfDays ?? this.noOfDays,
      amountPerDay: amountPerDay ?? this.amountPerDay,
      loadingCharge: loadingCharge ?? this.loadingCharge,
      unloadingCharge: unloadingCharge ?? this.unloadingCharge,
    );
  }

  factory SettlementApiRequest.fromJson(Map<String, dynamic> json){
    return SettlementApiRequest(
      vehicleId: json["vehicleId"] ?? "",
      loadId: json["loadId"] ?? "",
      noOfDays: json["noOfDays"] ?? 0,
      amountPerDay: json["amountPerDay"] ?? 0,
      loadingCharge: json["loadingCharge"] ?? 0,
      unloadingCharge: json["unloadingCharge"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "loadId": loadId,
    "noOfDays": noOfDays,
    "amountPerDay": amountPerDay,
    "loadingCharge": loadingCharge,
    "unloadingCharge": unloadingCharge,
  };

}
