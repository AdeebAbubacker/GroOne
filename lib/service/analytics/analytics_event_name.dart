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
  static const String FLEET_PRODUCT_CATALOG_EDITED = "fleet_product_catalog_edited";

  static const String FLEET_CREDIT_ORDER_APPROVED = "fleet_credit_order_approved";
  static const String FLEET_ORDER_CREATED = "fleet_order_created";

  static const String FLEET_DISPATCH_INITIATED = "fleet_dispatch_initiated";
  static const String FLEET_DISPATCH_IMEI_MAPPED = "fleet_dispatch_imei_mapped";

  static const String FLEET_SEND_PAYMENT_LINK = "fleet_send_payment_link";
  static const String FLEET_ASSIGN_FITTER = "fleet_assign_fitter";
  static const String FLEET_ACTIVATE_FITTER = "fleet_activate_fitter";

  static const String FLEET_ORDER_CANCELLED = "fleet_order_cancelled";

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



  static const String MP_KYC_APPROVED = "mp_kyc_approved";
  static const String MP_CREDIT_CHECKED = "mp_credit_checked";

  static const String MP_ADDRESS_BOOK_UPDATED = "mp_address_book_updated";

  static const String MP_LOAD_CREATED = "mp_load_created";
  static const String MP_LOAD_EDITED = "mp_load_edited";
  static const String MP_LOAD_NEGOTIATED = "mp_load_negotiated";
  static const String MP_LOAD_ASSIST_BOOKED = "mp_load_assist_booked";

  static const String MP_DOC_UPLOADED = "mp_doc_uploaded"; // loading doc + POD
  static const String MP_DOC_APPROVED = "mp_doc_approved";
  static const String MP_PAYMENT_ADV_DONE = "mp_payment_advance_done";
  static const String MP_PAYMENT_POD_DONE = "mp_payment_pod_done";

  static const String MP_HOLD_UNLOADING = "mp_hold_unloading";
  static const String MP_RELEASE_UNLOADING = "mp_release_unloading";
  static const String MP_MANUAL_LOCATION_UPDATE = "mp_manual_location_update";

  static const String MP_DAMAGE_UPDATE = "mp_damage_update";
  static const String MP_DAMAGE_APPROVED = "mp_damage_approved";

  static const String MP_COURIER_AWB_UPDATED = "mp_courier_awb_updated";
  static const String MP_FINAL_ERP_APPROVAL = "mp_final_erp_approval";

  static const String MP_RATE_MASTER_UPDATED = "mp_rate_master_updated";
  static const String MP_MARGIN_MASTER_UPDATED = "mp_margin_master_updated";
  static const String MP_PLATFORM_FEE_UPDATED = "mp_platform_fee_updated";

  static const String MP_CUSTOMER_INFO_EDITED = "mp_customer_info_edited";
  static const String MP_ORDER_INFO_EDITED = "mp_order_info_edited";

  static const String MP_VEHICLE_MASTER_UPDATED = "mp_vehicle_master_updated";
  static const String MP_DRIVER_UPDATED = "mp_driver_updated";

  static const String MP_USER_ADDED = "mp_user_added"; // BRM, ZC, etc.
}
