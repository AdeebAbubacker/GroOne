class CustomerSettingsResponse {
  CustomerSettingsResponse({
    required this.loadUpdates,
    required this.systemUpdates,
    required this.paymentAlerts,
    required this.offersPromotions,
    required this.language,
    required this.enableAppLock,
    required this.termsConditions,
    required this.privacyPolicy,
  });

  final String loadUpdates;
  final String systemUpdates;
  final String paymentAlerts;
  final String offersPromotions;
  final String language;
  final String enableAppLock;
  final String termsConditions;
  final String privacyPolicy;

  CustomerSettingsResponse copyWith({
    String? loadUpdates,
    String? systemUpdates,
    String? paymentAlerts,
    String? offersPromotions,
    String? language,
    String? enableAppLock,
    String? termsConditions,
    String? privacyPolicy,
  }) {
    return CustomerSettingsResponse(
      loadUpdates: loadUpdates ?? this.loadUpdates,
      systemUpdates: systemUpdates ?? this.systemUpdates,
      paymentAlerts: paymentAlerts ?? this.paymentAlerts,
      offersPromotions: offersPromotions ?? this.offersPromotions,
      language: language ?? this.language,
      enableAppLock: enableAppLock ?? this.enableAppLock,
      termsConditions: termsConditions ?? this.termsConditions,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
    );
  }

  factory CustomerSettingsResponse.fromJson(Map<String, dynamic> json){
    return CustomerSettingsResponse(
      loadUpdates: json["load_updates"] ?? "",
      systemUpdates: json["system_updates"] ?? "",
      paymentAlerts: json["payment_alerts"] ?? "",
      offersPromotions: json["offers_promotions"] ?? "",
      language: json["language"] ?? "",
      enableAppLock: json["enable_app_lock"] ?? "",
      termsConditions: json["terms_conditions"] ?? "",
      privacyPolicy: json["privacy_policy"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "load_updates": loadUpdates,
    "system_updates": systemUpdates,
    "payment_alerts": paymentAlerts,
    "offers_promotions": offersPromotions,
    "language": language,
    "enable_app_lock": enableAppLock,
    "terms_conditions": termsConditions,
    "privacy_policy": privacyPolicy,
  };

}
