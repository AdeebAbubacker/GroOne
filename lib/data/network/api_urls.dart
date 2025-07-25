import 'package:gro_one_app/data/network/env/environment_variable.dart';

class ApiUrls {
  ApiUrls._();

  /// Env
  static String get _fetchUrl => EnvironmentVariables.fetchBaseUrl;

  /// Map Key
  static String get fetchedMapKEY => EnvironmentVariables.fetchMapKey;




  /// Path
  static String get _path => "/api";
  static String get _load => "/load";
  static String get _settlement => "/load-settlement";
  static String get _v1 => "/v1";
  static String get _auth => "/auth";
  static String get _vp => "/vp";
  static String get _lp => "/lp";
  static String get _map => "/map-location";
  static String get _customer => "/customer";
  static String get _vpMaster => "/vp-master";
  static String get _rateDiscovery => "/ratediscovery";
  static String get _verification => "$_fetchUrl/external/api/v1/verification";
  static String get _kucDocUpload => "$_fetchUrl/external/api/v1/verification";
  static String get _fleet => "/fleet";
  static String get _credit => "/credit";
  static String get _vendor => "/vendor";
  static String get _document => "/document";
  static String get _notification => "/notification";
  static String get _loadDiscovery => "/load-discovery";
  static String get _loadExecution => "/load-execution";
  static String get _loadTracking => "/load-tracking";
  static String get _tracking => "/tracking";
  static String get _paymentBroker => "/payment-broker";

  /// Base URL
  static String get _baseUrl => _fetchUrl;
  static String get _baseUrlWithAuth => "$_baseUrl$_customer$_path$_v1$_auth";
  static String get _customerBaseUrl => "$_baseUrl$_customer$_path$_v1$_customer";
  static String get _mapBaseUrl => "$_baseUrl$_rateDiscovery$_path$_v1$_map";
  static String get _paymentBrokerBase => "$_fetchUrl$_paymentBroker$_path$_v1";
  static final String  baseUrl = _baseUrl;
  static final String  verification = _verification;

  /// Common Api
  static final String  upload = "$_fetchUrl$_document$_path$_v1/upload";
  static final String  language = "$_fetchUrl$_customer$_path$_v1/metadata/languages";
  static final String  updateProfile = "$_customerBaseUrl/profile-image/";
  static final String  logout = "$_fetchUrl$_customer$_path$_v1$_auth/logout";
  static final String  createDocument = "$_fetchUrl$_document$_path$_v1/documents";

  /// Onboarding
  static final String sendEmailOtp = "$_baseUrl$_customer$_path$_v1$_customer/create-customer/email-otp/send";
  static final String emailOTPCodeVerification = "$_baseUrl$_customer$_path$_v1$_customer/create-customer/email-otp/verify";
  static final String termsAndConditions = "$_fetchUrl$_customer$_path$_v1/metadata/terms-and-conditions";
  static final String privacyPolicy = "$_fetchUrl$_customer$_path$_v1/metadata/privacy-policies";
  static final String refreshToken = "$_fetchUrl$_customer$_path$_v1$_auth/refresh-token";


  /// VP Endpoints
  static final String createVpAccount = "$_customerBaseUrl$_vp/";
  static final String vpLoadList="$_baseUrl$_load$_path$_v1$_load$_vp/my-load";
  static final String vehicleDetails="$_baseUrl$_customer$_path$_v1/vehicle/";
  static final String driverDetails="$_baseUrl$_customer$_path$_v1/drivers";
  static final String vpRecentLoads="$_baseUrl$_load$_path$_v1$_load$_vp/recent-load";
  static final String vpAcceptLoad="$_baseUrl$_loadExecution$_path$_v1$_load/";
  static final String scheduleTrip="$_baseUrl$_load$_path$_v1/loads/schedule-trip";
  static final String truckPrefLane="$_baseUrl$_rateDiscovery$_path$_v1/lane";
  static final String getLoadById="$_baseUrl$_loadDiscovery$_path$_v1/load/";
  static final String getAllVpLoads="$_baseUrl$_loadDiscovery$_path$_v1$_load";
  static final String updateLoadStatus="$_baseUrl$_loadExecution$_path$_v1$_load/updateStatus";
  static final String loadDocument = "$_fetchUrl$_load$_path$_v1/loads/load-document";
  static final String viewDocument = "$_fetchUrl$_document$_path$_v1/documents/";
  static final String deleteLoadDocument = "$_fetchUrl$_load$_path$_v1/loads/load-document/";

  /// Kyc
  static final String  submitKyc = "$_baseUrl$_customer$_path$_v1/kyc/";
  static final String  aadhaarSendOtp = "$_verification/aadhaar/send-otp";
  static final String  aadhaarVerifyOtp = "$_verification/aadhaar/verify-otp";
  static final String  panVerification = "$_verification/pan";
  static final String  gst = "$_kucDocUpload/gst";
  static final String  tan = "$_kucDocUpload/tan";
  static final String  pan = "$_kucDocUpload/pan";
  static final String  getCity = "$_baseUrl$_load$_path$_v1/location/city";
  static final String  getState = "$_baseUrl$_load$_path$_v1/location/state";
  static final String  bluIdFlg = "$_baseUrl$_customer$_path$_v1$_customer/blue-id-flg/update/";

  /// Map
  static final String mapAutoComplete = "$_mapBaseUrl/autocomplete";
  static final String verifyLocation = "$_mapBaseUrl/verify-location";

  /// LP Endpoints
  static final String  createLpAccount = _customerBaseUrl;
  static final String  login = "$_baseUrlWithAuth/customer-login";
  static final String  companyType = "$_baseUrl$_customer$_path$_v1/company-type";
  static final String  resendOtp = "$_baseUrlWithAuth/customer-login";
  static final String  getProfile = "$_customerBaseUrl/";
  static final String  getMaster = "$_fetchUrl$_customer$_path$_v1/lp-master/";
  static final String  lpLoadList= "$_baseUrl$_loadDiscovery$_path$_v1$_load/list";
  static final String  lpLoadMemo="$_baseUrl$_loadExecution$_path$_v1$_load";
  static final String  lpLoadById="$_baseUrl$_loadDiscovery$_path$_v1$_load";
  static final String  lpLoadSendOtp="$_baseUrl$_loadExecution$_path$_v1$_load/Esignmemo";
  static final String  lpLoadVerifyOtp="$_baseUrl$_loadExecution$_path$_v1$_load/verify-esign-otp";
  static final String  lpLoadRoute="$_baseUrl$_rateDiscovery$_path$_v1/lane";
  static final String  lpCreditCheck="$_baseUrl$_credit$_path$_v1/credit-limit/export";
  static final String  getMyLoad="$_baseUrl$_credit$_path$_v1/credit-limit/export";
  static final String  lpLoadAgree="$_baseUrl$_loadExecution$_path$_v1$_load/lp-agree";
  static final String  lpLoadVerifyAdvance="$_baseUrl$_loadExecution$_path$_v1$_load/verify-advance";
  static final String  lpLoadFeedback="$_baseUrl$_loadExecution$_path$_v1$_load/";
  static final String  lpLoadDocument ="$_baseUrl$_document$_path$_v1/documents/";
  static final String lpLoadAddConsignee = "$_baseUrl$_load$_path$_v1/consignee";
  static final String lppayment = "$_fetchUrl$_vendor$_path$_v1/payment/addCustomerPaymentOption";
  static final String lpCreateOrderBase = "$_paymentBrokerBase/order/pay";
  static final String  podCenter = "$_baseUrl$_loadDiscovery$_path$_v1$_load/podCenterList";

  /// Load
  static String get _loadBaseUrl => "$_baseUrl$_load$_path$_v1";
  static final String  loadCommodity = "$_loadBaseUrl/commodities";
  static final String  loadTruckType = "$_loadBaseUrl/truck-types";
  static final String  truckType = "$loadTruckType/distinct/types";
  static final String  getRateDiscoveryPrice = "$baseUrl$_rateDiscovery$_path$_v1/rate-discovery/fetch-rate";
  static final String  getRecentRoute = "$baseUrl$_loadDiscovery$_path$_v1$_load/distinct-source-destination";
  static final String getWeight = "$_baseUrl$_rateDiscovery$_path$_v1/weightage";
  static final String  createLoad = "$_baseUrl$_load$_path$_v1/loads";
  static final String  getLoads = "$baseUrl$_loadDiscovery$_path$_v1$_load$_customer/";
  static final String  loadDetail = "$_loadBaseUrl$_load/";
  static final String  updateLoad = "$_loadBaseUrl/";
  static final String  damage = "$_loadBaseUrl/damage";
  static final String  updateDamage = "$_loadBaseUrl/damage/";
  static final String  deleteDamage = "$_loadBaseUrl/damage/";
  static final String  submitPod = "$_loadBaseUrl/pod";

  /// Settlement
  static String get _settlementBaseUrl => "$_baseUrl$_settlement$_path$_v1";
  static final String  submitSettlement = "$_settlementBaseUrl/settlement";

  //Kavach
  static String  kavachOrdersList = "$_baseUrl$_fleet$_path$_v1/orders/customer-orders/list";
  static String get kavachProductList => "$_baseUrl$_fleet$_path$_v1/product/list";
  static String get kavachVehicleDetails => "$_baseUrl$_customer$_path$_v1/vehicle";
  static String get kavachAddressList => "$_baseUrl$_customer$_path$_v1/address";
  static String get kavachAvailableStock => "$_baseUrl$_fleet$_path$_v1/stocks/available-stock";
  static String get kavachCreateOrder => "$_baseUrl$_fleet$_path$_v1/orders/create";
  static String get choosePreference => '$_baseUrl$_fleet$_path$_v1/masters';
  static String  kavachVehicle = "$_baseUrl$_customer$_path$_v1/vehicle/add";
  static String  kavachFetchCommodities = "$_baseUrl$_load$_path$_v1/commodities";
  static String  kavachAddress = "$_baseUrl$_customer$_path$_v1/address";
  static String  kavachTruckType = "$_loadBaseUrl/truck-types/types";
  static String  kavachTruckSubType = "$_loadBaseUrl/truck-types/sub-types";
  static String  kavachVehicleVerification = "$verification/vehicle";
  static final String kavachPayment = "$_fetchUrl$_vendor$_path$_v1/payment/addCustomerPaymentOption";
  //static final String  kavachtruckType = "$loadTruckType/truck-types/distinct/types";

  /// En-Dhan
  static final String enDhanKycUpload = "$_fetchUrl$_vendor$_path$_v1/dtplus/customerDocument";
  static String enDhanKycCheck(String customerId) => "$_fetchUrl$_vendor$_path$_v1/dtplus/customerDocument/$customerId";

  // En-Dhan Card APIs
  static String enDhanCards(String customerId) => "$_fetchUrl$_vendor$_path$_v1/dtplus/card/$customerId";
  static String enDhanCardBalance(String customerId) => "$_fetchUrl$_vendor$_path$_v1/dtplus/cardBalance/$customerId";

  // En-Dhan Customer Creation and Master Data APIs
  static final String enDhanCreateCustomer = "$_fetchUrl$_vendor$_path$_v1/dtplus/createCustomer";
  static final String enDhanStates = "$_fetchUrl$_vendor$_path$_v1/dtplus/state";
  static final String enDhanDistricts = "$_fetchUrl$_vendor$_path$_v1/dtplus/district/";
  static final String enDhanZonal = "$_fetchUrl$_vendor$_path$_v1/dtplus/zonal";
  static final String enDhanRegional = "$_fetchUrl$_vendor$_path$_v1/dtplus/regional/";
  static final String enDhanVehicleTypes = "$_fetchUrl$_vendor$_path$_v1/dtplus/vehicleType";
  static final String enDhanTransaction = "$_fetchUrl$_vendor$_path$_v1/dtplus/getTransaction";

  /// GPS
  static final String gpsDocumentUpload = ApiUrls.enDhanKycUpload;
  static String gpsKycCheck(String customerId) => "$_fetchUrl/customer/api/v1/kyc/$customerId";
  static String gpsKycUpload(String customerId) => "$_fetchUrl/customer/api/v1/kyc/$customerId";
  static final String gpsProductList = "$_fetchUrl$_fleet$_path$_v1/product/list";
  static final String gpsAddressList = "$_fetchUrl$_customer$_path$_v1/address";
  static final String gpsCreateOrder = "$_baseUrl$_fleet$_path$_v1/orders/create";
  static final String gpsOrderSummary = "$_baseUrl$_fleet$_path$_v1/orders/order-summary";
  static final String gpsCustomerOrdersList = "$_baseUrl$_fleet$_path$_v1/orders/customer-orders/list";

  // Document Upload API
  static final String documentUpload = "$_fetchUrl/document/api/v1/upload";

  // User Management API
  static final String getAllUsers = "$_fetchUrl/user/api/v1/users/allUsers";

  /// Google Map
  static String  googleDirectionApi = "https://maps.googleapis.com/maps/api/directions/json";

  /// Tracking
  static String  trackingDistance = "$_baseUrl$_loadTracking$_path$_v1$_tracking/calculate-distance";

 /// Driver
 static final String driverLoadListBaseUrl =  "$_baseUrl$_loadDiscovery$_path$_v1$_load/driver/list?isDriver=true";
 static final String driverProfile = "$_baseUrl$_customer$_path$_v1/drivers/id/";
 static final String driverLoadById = "$_baseUrl$_loadDiscovery$_path$_v1/load/driver/";





  /// GPS Tracking
  static const String _gpsBase = "https://api.letsgro.co/api/v1/auth";
  static final String gpsFetchGeofences = "$_gpsBase/tc_geofences?__include=area&__include=attributes&__limit=10000";
  static final String gpsAddGeofence = "$_gpsBase/add_geo_fence";
  static final String gpsUpdateGeofence = "$_gpsBase/update_geo_fence";
  static final String gpsLinkUnlinkGeofenceDevice = "$_gpsBase/link_unlink_geo_fence_device";
  static String gpsFetchGeofencesForVehicle(String userId, String deviceId) =>
      "$_gpsBase/tc_geofences?__include=area&__include=attributes&__limit=10000&user_id=$userId&device_id=$deviceId";
  static String gpsFetchNotifications(String userId, int days, int limit) =>
      "$_gpsBase/last_500_user_events?days=$days&limit=$limit&user_id=$userId";
  static const String gpsFetchParkingMode = "$_gpsBase/parking_mode";
  static String gpsUpdateParkingMode(int id) => "$_gpsBase/parking_mode/$id";
  static const String getDeprecatedNotificationStatus = "$_gpsBase/get_deprecated_notification_status";
  static const String updateDeprecatedNotificationStatus = "$_gpsBase/update_deprecated_notification_status";
  static String gpsUpdateNotificationToggle(int id) => "$_gpsBase/user_config/$id";


  /// profile
  static final String getMembershipBenefit = "$_baseUrl$_customer$_path$_v1/metadata/membership-benefit";
  static final String createAddress = "$_baseUrl$_customer$_path$_v1/address/";
  static final String updateAddress = "$_baseUrl$_customer$_path$_v1/address/";
  static final String deleteAddress = "$_baseUrl$_customer$_path$_v1/address/";
  static final String getAddress = "$_baseUrl$_customer$_path$_v1/address/";
  static final String setPrimaryAddress = "$_baseUrl$_customer$_path$_v1/address/is-default/";
  static final String getKycDocuments = "$_baseUrl$_customer$_path$_v1/kyc/";
  static final String getCustomerSettings = "$_baseUrl$_customer$_path$_v1/settings/";
  static final String updateCustomerSettings = "$_baseUrl$_customer$_path$_v1/settings/";
}
