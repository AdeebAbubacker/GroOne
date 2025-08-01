import 'package:gro_one_app/features/profile/api_request/update_settings_request.dart';

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

extension CustomerSettingsMapper on CustomerSettingsResponse {
  static final valueExtractors = <String, String Function(CustomerSettingsResponse?)>{
    'language': (settings) => settings?.language ?? '',
    'load_updates': (settings) => settings?.loadUpdates ?? '',
    'system_updates': (settings) => settings?.systemUpdates ?? '',
    'payment_alerts': (settings) => settings?.paymentAlerts ?? '',
    'offers_promotions': (settings) => settings?.offersPromotions ?? '',
    'enable_app_lock': (settings) => settings?.enableAppLock ?? '',
  };

  static final requestBuilders = <String, UpdateSettingsRequest Function(String)>{
    'language': (val) => UpdateSettingsRequest(language: val),
    'load_updates': (val) => UpdateSettingsRequest(loadUpdates: val),
    'system_updates': (val) => UpdateSettingsRequest(systemUpdates: val),
    'payment_alerts': (val) => UpdateSettingsRequest(paymentAlerts: val),
    'offers_promotions': (val) => UpdateSettingsRequest(offersPromotions: val),
    'enable_app_lock': (val) => UpdateSettingsRequest(enableAppLock: val),
  };

  static String getValue(String key, CustomerSettingsResponse? data, String fallback) {
    return valueExtractors[key]?.call(data) ?? fallback;
  }

  static UpdateSettingsRequest? buildRequest(String key, String value) {
    return requestBuilders[key]?.call(value);
  }
}

