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
  static String get _customer => "/customer";
  static String get _vpMaster => "/vp-master";
  static String get _rateDiscovery => "/ratediscovery";
  static String get _verification => "https://verification-service-uat.letsgro.co/api/v1/verification";
  static String get _fleet => "/fleet";


  // Base URL
  static String get _baseUrl => _fetchUrl;

  static String get _baseUrlWithAuth => "$_fetchUrl$_customer$_path$_v1$_auth$_customer";
  static String get _customerBaseUrl => "$_baseUrl$_customer$_path$_v1$_customer";

  static final String  baseUrl = _baseUrl;
  static final String  verification = _verification;

  // http://34.54.198.251/customer/api/v1/customer/profile-image/2

  // Common Api
  static final String  upload = "$_fetchUrl$_customer$_path$_v1/upload";
  static final String  updateProfile = "$_customerBaseUrl/profile-image/";
  static final String  logout = "$_fetchUrl$_customer$_path$_v1$_auth/logout";

  /// VP Endpoints
  static final String createVpAccount = "$_customerBaseUrl$_vp/";
  static final String vpLoadList="$_baseUrl$_load$_path$_v1$_load$_vp/my-load";
  static final String vehicleDetails="$_baseUrl$_customer$_path$_v1$_vpMaster/vehicle/";
  static final String driverDetails="$_baseUrl$_customer$_path$_v1$_vpMaster/driver/";
  static final String vpRecentLoads="$_baseUrl$_load$_path$_v1$_load$_vp/recent-load";
  static final String vpAcceptLoad="$_baseUrl$_load$_path$_v1$_load/";

  static final String scheduleTrip="$_baseUrl$_load$_path$_v1$_load/schedule-trip";

  //submit Kyc
  static final String  submitKyc = "$_baseUrl$_customer$_path$_v1/kyc/";

  /// LP Endpoints
  static final String  createLpAccount = "$_customerBaseUrl$_lp/";
  static final String  login = "$_baseUrlWithAuth/login";
  static final String  companyType = "$_baseUrl$_customer$_path$_v1/company-type";
  static final String  resendOtp = "$_baseUrlWithAuth/resend-otp";
  static final String  aadhaarSendOtp = "$_verification/aadhaar/send-otp";
  static final String  aadhaarVerifyOtp = "$_verification/aadhaar/verify-otp";
  static final String  gst = "$_verification/gst";
  static final String  tan = "$_verification/tan";
  static final String  pan = "$_verification/pan";
  static final String  getProfile = "$_customerBaseUrl/";
  static final String  getMaster = "$_fetchUrl$_customer$_path$_v1/lp-master/";


  /// Load Creation
  static String get _loadBaseUrl => "$_baseUrl$_load$_path$_v1/";

  // Load Form pick list
  static final String  loadCommodity = "${_loadBaseUrl}commodity";
  static final String  loadTruckType = "${_loadBaseUrl}truck-type/";
  static final String  truckType = "${loadTruckType}distinct/types";
  static final String  getRateDiscoveryPrice = "$baseUrl$_rateDiscovery$_path$_v1/rate-discovery";

  // Load
  static final String  createLoad = "$_baseUrl$_load$_path$_v1$_load";
  static final String  getLoads = "$_loadBaseUrl$_load$_customer/";
  static final String  loadDetail = "$_loadBaseUrl$_load/";
  static final String  updateLoad = "$_loadBaseUrl/";

  //Kavach
  // https://gro-devapi.letsgro.co/fleet/api/v1/orders/customer-orders/list
  static String  kavachOrdersList = "$_baseUrl$_fleet$_path$_v1/orders/customer-orders/list";
}
