class UpdateSettingsRequest {
  UpdateSettingsRequest({
    this.loadUpdates,
    this.systemUpdates,
    this.paymentAlerts,
    this.offersPromotions,
    this.language,
    this.enableAppLock,
  });

  final String? loadUpdates;
  final String? systemUpdates;
  final String? paymentAlerts;
  final String? offersPromotions;
  final String? language;
  final String? enableAppLock;

  UpdateSettingsRequest copyWith({
    String? loadUpdates,
    String? systemUpdates,
    String? paymentAlerts,
    String? offersPromotions,
    String? language,
    String? enableAppLock,
  }) {
    return UpdateSettingsRequest(
      loadUpdates: loadUpdates ?? this.loadUpdates,
      systemUpdates: systemUpdates ?? this.systemUpdates,
      paymentAlerts: paymentAlerts ?? this.paymentAlerts,
      offersPromotions: offersPromotions ?? this.offersPromotions,
      language: language ?? this.language,
      enableAppLock: enableAppLock ?? this.enableAppLock,
    );
  }

  factory UpdateSettingsRequest.fromJson(Map<String, dynamic> json){
    return UpdateSettingsRequest(
      loadUpdates: json["load_updates"] ?? "",
      systemUpdates: json["system_updates"] ?? "",
      paymentAlerts: json["payment_alerts"] ?? "",
      offersPromotions: json["offers_promotions"] ?? "",
      language: json["language"] ?? "",
      enableAppLock: json["enable_app_lock"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "load_updates": loadUpdates,
    "system_updates": systemUpdates,
    "payment_alerts": paymentAlerts,
    "offers_promotions": offersPromotions,
    "language": language,
    "enable_app_lock": enableAppLock,
  };

}
