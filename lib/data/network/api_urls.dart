import 'package:gro_one_app/data/network/env/environment_variable.dart';

class ApiUrls {
  ApiUrls._();

  // http://34.54.198.251/customer/api/v1/customer/vp/4

  // Env
  static String get _fetchUrl => EnvironmentVariables.fetchBaseUrl;
  static String get _path => "/api";
  static String get _v1 => "/v1";
  static String get _vp => "/vp";
  static String get _lp => "/lp";
  static String get _customer => "/customer";

  // Base URL
  static String get _baseUrl => "$_fetchUrl$_path$_v1$_customer";
  static String  baseUrl = _baseUrl;

  // VP Endpoints
  static String  createVpAccount = "$baseUrl$_vp/4";

  // LP Endpoints
  static String  createLpAccount = "$baseUrl$_lp/3";


}
