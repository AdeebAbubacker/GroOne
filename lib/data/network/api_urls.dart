import 'package:gro_one_app/data/network/env/environment_variable.dart';

class ApiUrls {
  ApiUrls._();

  // http://34.54.198.251/customer/api/v1/customer/vp/4

  // Env
  static String get _fetchUrl => EnvironmentVariables.fetchBaseUrl;
  static String get _path => "/api";
  static String get _load => "/load";
  static String get _v1 => "/v1";
  static String get _auth => "/auth";
  static String get _vp => "/vp";
  static String get _lp => "/lp";
  static String get _customer => "/customer";
  static String get _verification => "https://verification-service-uat.letsgro.co/api/v1/verification";

  // Base URL
  static String get _baseUrl => "$_fetchUrl$_path$_v1";
  static String get _baseUrlWithAuth => "$_fetchUrl$_path$_v1$_auth$_customer";

  static final String  baseUrl = _baseUrl;
  static final String  verification = _verification;

  // Common Api
  static String  upload = "$baseUrl/upload";

  /// VP Endpoints
  static String  createVpAccount = "$baseUrl$_customer$_vp/";

 //submit Kyc
  static String  submitKyc = "$baseUrl/kyc/";


  /// LP Endpoints
  static String  createLpAccount = "$baseUrl$_customer$_lp/";

  static String  login = "$_baseUrlWithAuth/login";
  static String  companyType = "$baseUrl/company-type";
  static String  resendOtp = "$_baseUrlWithAuth/resend-otp";
  static String  aadhaarSendOtp = "$_verification/aadhaar/send-otp";
  static String  aadhaarVerifyOtp = "$_verification/aadhaar/verify-otp";
  static String  gst = "$_verification/gst";
  static String  tan = "$_verification/tan";
  static String  pan = "$_verification/pan";
  static String  getProfile = "$baseUrl$_customer/";
  static String  getMaster = "$baseUrl/lp-master/";


  // Load Creation
  static final String  _loadCreationBaseUrl = "http://34.54.198.251/load/api/v1/";

  // Load Form pick list
  static final String  loadCommodity = "${_loadCreationBaseUrl}commodity";
  static final String  loadTruckType = "${_loadCreationBaseUrl}truck-type";

  // Load
  static final String  createLoad = "$_loadCreationBaseUrl/load";
  static final String  getLoads = "$_loadCreationBaseUrl/load/$_customer/";
  static final String  loadDetail = "$_loadCreationBaseUrl/load/";
  static final String  updateLoad = "$_loadCreationBaseUrl/load/";


}
