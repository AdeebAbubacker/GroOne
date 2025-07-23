class AnalyticEventName {
  AnalyticEventName._();

  /// Common Keys
  static const String ITEM_NAME = "item_name";
  static const String ITEM_ID = "item_id";
  static const String CATEGORY = "category";

  /// General Actions
  static const String SUCCESS = "success";
  static const String FAILURE = "failure";

  /// Fleet Events
  static const String FLEET_PRODUCT_CATALOG_CREATED = "fleet_product_catalog_created";


  /// Marketplace Events
  // Onboarding
  static const String ONBOARD_MOBILE_ENTERED = "onboard_mobile_entered";
  static const String ONBOARD_OTP_SENT = "onboard_otp_sent";
  static const String ONBOARD_OTP_VERIFIED = "onboard_otp_verified";
  static const String ONBOARD_OTP_FAILED = "onboard_otp_failed";
  static const String ONBOARD_ROLE_SELECTED = "onboard_role_selected";
  // vp
  static const String ONBOARD_VP_FORM_SUBMITTED = "onboard_vp_form_submitted";
  // Lp
  static const String ONBOARD_LP_FORM_SUBMITTED = "onboard_lp_form_submitted";


}
