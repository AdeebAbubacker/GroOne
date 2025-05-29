import 'package:gro_one_app/data/network/env/environment_variable.dart';

class ApiUrls {
  ApiUrls._();

  // http://34.54.198.251/customer/api/v1/customer/vp/4
  // load service:
  // http://gro-devapi.letsgro.co/load
  //
  // customer service:
  // http://gro-devapi.letsgro.co/customer/api/vi/
  //
  // thirdparty service:
  // http://gro-devapi.letsgro.co/thirdparty
  //
  // freight service:
  // http://gro-devapi.letsgro.co/freight
  //
  // rate-discovery service:
  // http://gro-devapi.letsgro.co/ratediscovery/

  // http://34.54.198.251/customer/api/v1/auth/logout

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
  static String get _rateDiscovery => "/ratediscovery";
  static String get _verification => "https://verification-service-uat.letsgro.co/api/v1/verification";

  // Base URL
  static String get _baseUrl => _fetchUrl;

  static String get _baseUrlWithAuth => "$_fetchUrl$_customer$_path$_v1$_auth$_customer";
  static String get _customerBaseUrl => "$_baseUrl$_customer$_path$_v1$_customer";

  static final String  baseUrl = _baseUrl;
  static final String  verification = _verification;

  // http://34.54.198.251/customer/api/v1/customer/profile-image/2

  // Common Api
  static final String  upload = "$baseUrl/upload";
  static final String  updateProfile = "$_customerBaseUrl$_customer/profile-image/";
  static final String  logout = "$_customerBaseUrl$_auth/logout";

  /// VP Endpoints
  static final String  createVpAccount = "$_customerBaseUrl$_vp/";

  //submit Kyc
  static final String  submitKyc = "$_customerBaseUrl/kyc/";

  /// LP Endpoints
  static final String  createLpAccount = "$baseUrl$_customerBaseUrl$_lp/";
  static final String  login = "$_baseUrlWithAuth/login";
  static final String  companyType = "$_customerBaseUrl/company-type";
  static final String  resendOtp = "$_baseUrlWithAuth/resend-otp";
  static final String  aadhaarSendOtp = "$_verification/aadhaar/send-otp";
  static final String  aadhaarVerifyOtp = "$_verification/aadhaar/verify-otp";
  static final String  gst = "$_verification/gst";
  static final String  tan = "$_verification/tan";
  static final String  pan = "$_verification/pan";
  static final String  getProfile = "$_customerBaseUrl/";
  static final String  getMaster = "$_customerBaseUrl/lp-master/";

  /// Load Creation
  static String get _loadBaseUrl => "$_baseUrl$_load$_path$_v1/";

  // Load Form pick list
  static final String  loadCommodity = "${_loadBaseUrl}commodity";
  static final String  loadTruckType = "${_loadBaseUrl}truck-type";
  static final String  getRateDiscoveryPrice = "${_loadBaseUrl}rate-discovery";

  // Load
  static final String  createLoad = _loadBaseUrl;
  static final String  getLoads = "$_loadBaseUrl$_customer/";
  static final String  loadDetail = "$_loadBaseUrl/";
  static final String  updateLoad = "$_loadBaseUrl/";


}