import 'package:gro_one_app/data/network/env/environment_variable.dart';

class ApiUrls {
  ApiUrls._();

  /// <<< -- backend urls -- >>>

  /// Fleet service:
  // https://gro-devapi.letsgro.co/fleet

  /// load service:
  // https://gro-devapi.letsgro.co/load

  /// customer service:
  // https://gro-devapi.letsgro.co/customer

  /// thirdparty service:
  // https://gro-devapi.letsgro.co/thirdparty

  /// freight service:
  // https://gro-devapi.letsgro.co/freight

  /// rate-discovery service:
  // https://gro-devapi.letsgro.co/ratediscovery/

  /// Frontend admin service:
  // https://gro-devadmin.letsgro.co/

  // Env
  static String get _fetchUrl => EnvironmentVariables.fetchBaseUrl;

  // Path
  static String get _path => "/api";
  static String get _load => "/load";
  static String get _v1 => "/v1";
  static String get _auth => "/auth";
  static String get _vp => "/vp";
  static String get _lp => "/lp";
  static String get _map => "/map";
  static String get _customer => "/customer";
  static String get _vpMaster => "/vp-master";
  static String get _rateDiscovery => "/ratediscovery";
  static String get _verification => "https://verification-service-uat.letsgro.co/api/v1/verification";
  static String get _kucDocUpload => "https://verification-service-uat.letsgro.co/api/v1/verification";
  static String get _fleet => "/fleet";
  static String get _credit => "/credit";
  static String get _vendor => "/vendor";


  // Base URL
  static String get _baseUrl => _fetchUrl;

  static String get _baseUrlWithAuth => "$_baseUrl$_customer$_path$_v1$_auth$_customer";
  static String get _customerBaseUrl => "$_baseUrl$_customer$_path$_v1$_customer";
  static String get _mapBaseUrl => "$_baseUrl$_load$_path$_v1$_map";

  static final String  baseUrl = _baseUrl;
  static final String  verification = _verification;

  // http://34.54.198.251/customer/api/v1/customer/profile-image/2

  // Common Api
  static final String  upload = "$_fetchUrl$_customer$_path$_v1/upload";
  static final String  language = "$_fetchUrl$_customer$_path$_v1/language";
  static final String  updateProfile = "$_customerBaseUrl/profile-image/";
  static final String  logout = "$_fetchUrl$_customer$_path$_v1$_auth/logout";

  /// Onboarding
  static final String sendEmailOtp = "$_baseUrl$_customer$_path$_v1/email-otp/send";
  static final String resendEmailOtp = "$_baseUrl$_customer$_path$_v1/email-otp/resend";
  static final String emailOTPCodeVerification = "$_baseUrl$_customer$_path$_v1/email-otp/verify";


  /// VP Endpoints
  static final String createVpAccount = "$_customerBaseUrl$_vp/";
  static final String vpLoadList="$_baseUrl$_load$_path$_v1$_load$_vp/my-load";
  static final String vehicleDetails="$_baseUrl$_customer$_path$_v1$_vpMaster/vehicle/";
  static final String driverDetails="$_baseUrl$_customer$_path$_v1$_vpMaster/driver/";
  static final String vpRecentLoads="$_baseUrl$_load$_path$_v1$_load$_vp/recent-load";
  static final String vpAcceptLoad="$_baseUrl$_load$_path$_v1$_load/";
  static final String scheduleTrip="$_baseUrl$_load$_path$_v1$_load/schedule-trip";
  static final String truckPrefLane="$_baseUrl$_rateDiscovery$_path$_v1/lane";
  static final String getLoadById="$_baseUrl$_load$_path$_v1/load/";



  /// Kyc
  static final String  submitKyc = "$_baseUrl$_customer$_path$_v1/kyc/";
  static final String  aadhaarSendOtp = "$verification/aadhaar/send-otp";
  static final String  aadhaarVerifyOtp = "$verification/aadhaar/verify-otp";
  static final String  gst = "$_kucDocUpload/gst";
  static final String  tan = "$_kucDocUpload/tan";
  static final String  pan = "$_kucDocUpload/pan";
  static final String  getCity = "$_baseUrl$_customer$_path$_v1/kyc/city";
  static final String  getState = "$_baseUrl$_customer$_path$_v1/kyc/state";

  /// Map
  static final String mapAutoComplete = "$_mapBaseUrl/autocomplete";
  static final String verifyLocation = "$_mapBaseUrl/verify-location";



  /// LP Endpoints
  static final String  createLpAccount = "$_customerBaseUrl$_lp/";
  static final String  login = "$_baseUrlWithAuth/login";
  static final String  companyType = "$_baseUrl$_customer$_path$_v1/company-type";
  static final String  resendOtp = "$_baseUrlWithAuth/resend-otp";
  static final String  getProfile = "$_customerBaseUrl/";
  static final String  getMaster = "$_fetchUrl$_customer$_path$_v1/lp-master/";
  static final String  lpLoadList="$_baseUrl$_load$_path$_v1$_load/list";
  static final String  lpLoadMemo="$_baseUrl$_load$_path$_v1$_load";
  static final String  lpLoadById="$_baseUrl$_load$_path$_v1$_load";
  static final String  lpLoadSendOtp="$_baseUrl$_load$_path$_v1$_load/Esignmemo";
  static final String  lpLoadVerifyOtp="$_baseUrl$_load$_path$_v1$_load/verify-esign-otp";
  static final String  lpLoadRoute="$_baseUrl$_load$_path$_v1/lanes";
  static final String  lpCreditCheck="$_baseUrl$_credit$_path$_v1/credit-limit/export";
  static final String  getMyLoad="$_baseUrl$_credit$_path$_v1/credit-limit/export";
  // https://gro-devapi.letsgro.co/load/api/v1/load/vp/load

  /// Load Creation
  static String get _loadBaseUrl => "$_baseUrl$_load$_path$_v1";

  // Load Form pick list
  static final String  loadCommodity = "$_loadBaseUrl/commodity";
  static final String  loadTruckType = "$_loadBaseUrl/truck-type/";
  static final String  truckType = "$loadTruckType/distinct/types";
  static final String  getRateDiscoveryPrice = "$baseUrl$_rateDiscovery$_path$_v1/rate-discovery/by-lane-truck-type";
  static final String  getRecentRoute = "$_loadBaseUrl$_load/distinct-source-destination";
  static final String getWeight = "$_baseUrl$_rateDiscovery$_path$_v1/weightage";

  // Load
  static final String  createLoad = "$_baseUrl$_load$_path$_v1$_load";
  static final String  getLoads = "$_loadBaseUrl$_load$_customer/";
  static final String  loadDetail = "$_loadBaseUrl$_load/";
  static final String  updateLoad = "$_loadBaseUrl/";

  //Kavach
  static String  kavachOrdersList = "$_baseUrl$_fleet$_path$_v1/orders/customer-orders/list";
  static String get kavachProductList => "$_baseUrl$_fleet$_path$_v1/product/list";
  static String get kavachVehicleDetails => "$_baseUrl$_customer$_path$_v1$_vpMaster/vehicle";
  static String get kavachAddressList => "$_baseUrl$_customer$_path$_v1/vas";
  static String get kavachAvailableStock => "$_baseUrl$_fleet$_path$_v1/stocks/available-stock";
  static String get kavachCreateOrder => "$_baseUrl$_fleet$_path$_v1/orders/create";
  static String get choosePreference => '$_baseUrl$_fleet$_path$_v1/masters';
  static String  kavachVehicle = "$_baseUrl$_customer$_path$_v1/vp-master/vehicle";
  static String  kavachFetchCommodities = "$_baseUrl$_load$_path$_v1/commodity";
  static String  kavachAddress = "$_baseUrl$_customer$_path$_v1/vas";
  static String  kavachTruckType = "$_baseUrl$_load$_path$_v1/truck-type/distinct/types";
  static String  kavachTruckSubType = "$_baseUrl$_load$_path$_v1/truck-type/sub-types";

  /// En-Dhan 
  //static final String enDhanKycUpload = "$_baseUrl$_vendor$_path$_v1/dtplus/customerDocument";
  static final String enDhanKycUpload = "https://gro-devapi.letsgro.co$_vendor$_path$_v1/dtplus/customerDocument";
 // static final String enDhanKycCheck = "$_baseUrl$_vendor$_path$_v1/dtplus/customerDocument";
  static final String enDhanKycCheck = "https://gro-devapi.letsgro.co$_vendor$_path$_v1/dtplus/customerDocument";
  
}
