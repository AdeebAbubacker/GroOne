import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/load_provider/lp_bottom_navigation/lp_bottom_navigation.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/global_variables.dart';

class ApiService {
  final Duration _timeout = const Duration(
    seconds: 30,
  ); // General timeout for all requests
  final Dio _dio;
  final SecuredSharedPreferences _secureSharedPrefs;
  // late DioCacheManager _cacheManager;
  ApiService(this._dio, this._secureSharedPrefs) {
    // CacheConfig cacheConfig = CacheConfig(baseUrl: ApiUrls.baseUrl);
    // _cacheManager = DioCacheManager(cacheConfig);
    // _dio.interceptors.add(_cacheManager.interceptor);
    _dio.options.connectTimeout = _timeout;
    _dio.options.receiveTimeout = _timeout;
  }

  /// Header
  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    Map<String, String> headers = {
      'Content-Type': isMultipart ? 'multipart/form-data' : 'application/json',
      'Accept': 'application/json',
    };
    try {
      String? refreshToken = await _secureSharedPrefs.get(
        AppString.sessionKey.accessToken,
      );
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final authHeader = 'Bearer $refreshToken';
        headers['Authorization'] = authHeader;
      }
    } catch (e) {
      CustomLog.error(this, "Error getting authentication token", e);
    }
    return headers;
  }

  /// Check if token is available
  Future<bool> hasValidToken() async {
    try {
      String? token = await _secureSharedPrefs.get(
        AppString.sessionKey.accessToken,
      );
      final hasToken = token != null && token.isNotEmpty;
      CustomLog.debug(this, "🔐 Token availability check: $hasToken");
      if (hasToken) {
        CustomLog.debug(
          this,
          "🔐 Token value: '${token!.substring(0, 10)}...'",
        );
      }
      return hasToken;
    } catch (e) {
      CustomLog.error(this, "Error checking token availability", e);
      return false;
    }
  }

  /// Get
  Future<Result<dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParams,
    bool forceRefresh = false,
    CancelToken? cancelToken,
    Map<String, String>? customHeaders,
  }) async {
    dynamic prettyHeader = const JsonEncoder.withIndent(
      '  ',
    ).convert(await _getHeaders());
    CustomLog.debug(
      this,
      "\nMethod : Get, \nURL : $url, \nHeader : $prettyHeader, ${queryParams != null ? "\nQueryParams : $queryParams" : ""}",
    );
    try {
      final headers = customHeaders ?? await _getHeaders();
      final response = await _dio.get(
        url,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        options: Options(
          headers: headers,
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );
      return await _handleBodyResponse(response);
    } on DioError catch (dioError) {
      return await _handleDioError(dioError);
    } catch (exception) {
      CustomLog.error(this, "Generic HTTP call error", exception);
      return Error(GenericError());
    }
  }

  /// Post
  Future<Result<dynamic>> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? customHeaders,
  }) async {
    Object prettyBodyString;
    if (queryParams != null) {
      prettyBodyString = const JsonEncoder.withIndent(
        '  ',
      ).convert(queryParams);
    } else {
      prettyBodyString = const JsonEncoder.withIndent('  ').convert(body);
    }
    dynamic prettyHeader = const JsonEncoder.withIndent(
      '  ',
    ).convert(await _getHeaders());
    CustomLog.debug(
      this,
      "\nMethod: Post \nURL: $url, \nHeader: $prettyHeader, \nRequest: $prettyBodyString",
    );
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }
      final headers = customHeaders ?? await _getHeaders();
      final response = await _dio.post(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );
      return await _handleBodyResponse(response);
    } on DioError catch (dioError) {
      return await _handleDioError(dioError);
    } catch (exception) {
      CustomLog.error(this, "Generic HTTP call error", exception);
      return Error(GenericError());
    }
  }

  /// Put
  Future<Result<dynamic>> put(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? customHeaders,
  }) async {
    Object prettyBodyString;
    if (queryParams != null) {
      prettyBodyString = const JsonEncoder.withIndent(
        '  ',
      ).convert(queryParams);
    } else {
      prettyBodyString = const JsonEncoder.withIndent('  ').convert(body);
    }
    dynamic prettyHeader = const JsonEncoder.withIndent(
      '  ',
    ).convert(await _getHeaders());

    CustomLog.debug(
      this,
      "\nMethod: Put \nURL: $url \nRequest: $prettyBodyString \nHeader: $prettyHeader",
    );
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }
      final headers = customHeaders ?? await _getHeaders();
      final response = await _dio.put(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );
      return await _handleBodyResponse(response);
    } on DioError catch (dioError) {
      return await _handleDioError(dioError);
    } catch (exception) {
      CustomLog.error(this, "Generic HTTP call error", exception);
      return Error(GenericError());
    }
  }

  /// Patch
  Future<Result<dynamic>> patch(
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? customHeaders,
  }) async {
    Object prettyBodyString;
    if (queryParams != null) {
      prettyBodyString = const JsonEncoder.withIndent(
        '  ',
      ).convert(queryParams);
    } else {
      prettyBodyString = const JsonEncoder.withIndent('  ').convert(body);
    }
    CustomLog.debug(
      this,
      "\nMethod: patch \nURL: $url \nRequest: $prettyBodyString",
    );
    final headers = customHeaders ?? await _getHeaders();
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }
      final response = await _dio.patch(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: headers,
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );
      return await _handleBodyResponse(response);
    } on DioError catch (dioError) {
      return await _handleDioError(dioError);
    } catch (exception) {
      CustomLog.error(this, "Generic HTTP call error", exception);
      return Error(GenericError());
    }
  }

  // Delete
  Future<Result<dynamic>> delete(
    String url, {
    Map<String, String>? customHeaders,
  }) async {
    CustomLog.debug(this, "Method: Delete, \nURL: $url");
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }
      final headers = customHeaders ?? await _getHeaders();
      final response = await _dio.delete(
        url,
        options: Options(
          headers: headers,
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );
      return await _handleBodyResponse(response);
    } on DioError catch (dioError) {
      return await _handleDioError(dioError);
    } catch (exception) {
      CustomLog.error(this, "Generic HTTP call error", exception);
      return Error(GenericError());
    }
  }

  /// Multi parts
  Future<Result<dynamic>> multipart(
    String url,
    dynamic files, {
    Map<String, String>? fields,
    String? pathName,
    Map<String, String>? customHeaders,
  }) async {
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }
      final prettyFieldsString = const JsonEncoder.withIndent(
        '  ',
      ).convert(fields);
      CustomLog.debug(
        this,
        "\nMethod : Multipart \nURL : $url \nPath name : $pathName \nFiles : $files \nFields : $prettyFieldsString",
      );
      FormData formData = FormData();

      // Handling file upload (single or multiple)
      if (files != null) {
        if (files is List<File>) {
          for (var file in files) {
            if (await file.exists()) {
              formData.files.add(
                MapEntry(
                  pathName ?? "file",
                  await MultipartFile.fromFile(file.path),
                ),
              );
            } else {
              CustomLog.debug(this, "File not found: ${file.path}");
            }
          }
        } else if (files is File) {
          if (await files.exists()) {
            formData.files.add(
              MapEntry(
                pathName ?? "file",
                await MultipartFile.fromFile(files.path),
              ),
            );
          } else {
            CustomLog.debug(this, "File not found: ${files.path}");
          }
        } else {
          return Error(
            ErrorWithMessage(message: "Invalid file type provided."),
          );
        }
      } else {}
      // Adding extra form fields if provided
      if (fields != null && fields.isNotEmpty) {
        formData.fields.addAll(fields.entries);
      }
      final headers = customHeaders ?? await _getHeaders(isMultipart: true);
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );
      return await _handleBodyResponse(response);
    } on DioException catch (dioError) {
      return await _handleDioError(dioError);
    } catch (exception) {
      CustomLog.error(this, "HTTP call error during multipart", exception);
      return Error(ErrorWithMessage(message: "$exception"));
    }
  }

  /// Handle Body Response
  Future<Result<dynamic>> _handleBodyResponse(Response response) async {
    final prettyBodyString = const JsonEncoder.withIndent(
      '  ',
    ).convert(response.data);
    CustomLog.debug(
      this,
      "\nResponse status code: ${response.statusCode}, \nResponse data: ${response.data}",
    );
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(response.data);

      } else {
        return await _handleHttpError(response);
      }
    } on Exception catch (e) {
      CustomLog.error(this, "Error decoding data response: $e", null);
      return Error(GenericError());
    }
  }

  /// Handle HTTP Error
  Future<Result<dynamic>> _handleHttpError(Response? response) async {
    switch (response?.statusCode) {
      case 400:
        return Error(BadRequestError.fromApiResponse(response?.data));
      case 401:
        await _handleUnauthorizedError();
        final msg = response?.data?['error_description'];
        return Error(UnauthenticatedError(message: msg));
      case 403:
        final msg = response?.data?['message'];
        return Error(UnauthenticatedError(message: msg));
      case 404:
        return Error(NotFoundError.fromApiResponse(response?.data));
      case 409:
        final msg = response?.data?['message'];
        return Error(ConflictError(message: msg));
      case 498:
        final msg = response?.data?['message'];
        return Error(InvalidTokenError(message: msg));
      case 500:
        final msg = navigatorKey.currentState?.context.appText.errorMessage;
        return Error(InternalServerError(message: msg));
      case 501:
        final msg = navigatorKey.currentState?.context.appText.errorMessage;
        return Error(InternalServerError(message: msg));
      default:
        log("Unexpected status code: ${response?.statusCode}");
        return Error(GenericError());
    }
  }

  /// Handle unauthorized error by attempting token refresh first
  Future<void> _handleUnauthorizedError() async {
    try {
      CustomLog.debug(this, "🔐 Handling 401 Unauthorized error");

      final refreshToken = await _secureSharedPrefs.get(AppString.sessionKey.refreshToken);

      if (refreshToken == null || refreshToken.isEmpty) {
        CustomLog.debug(this, "No refresh token found, logging out");
        await _clearAuthAndRedirect();
        return;
      }

      // Call refresh token API using existing post() method for consistent handling
      final refreshResult = await post(
        ApiUrls.refreshToken,
        body: {
          "refresh_token": refreshToken,
        },
        customHeaders: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (refreshResult is Success) {
        final data = refreshResult.value['data'];

        if (data != null && data['access_token'] != null) {
          final newAccessToken = data['access_token'];
          final newRefreshToken = data['refresh_token'];

          await _secureSharedPrefs.saveKey(AppString.sessionKey.accessToken, newAccessToken);
          await _secureSharedPrefs.saveKey(AppString.sessionKey.refreshToken, newRefreshToken);

          CustomLog.debug(this, "🔐 Token refreshed successfully");
          return; // Future requests will now use the new token
        }
      }

      // If refresh failed → logout
      CustomLog.debug(this, "Token refresh failed, logging out");
      await _clearAuthAndRedirect();

    } catch (e) {
      CustomLog.error(this, "Error refreshing token", e);
      await _clearAuthAndRedirect();
    }
  }


  Future<void> _clearAuthAndRedirect() async {
    // Clear all authentication data
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.accessToken);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.refreshToken);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.userId);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.userRole);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.companyTypeId);
    clearAllBusinessDocs();




    if (appContext.mounted) {
        appContext.pushReplacement(AppRouteName.login, extra: {"showBackButton": false});
    }
    LpBottomNavigation.selectedIndexNotifier.value = 0;

  }

  Future<void> clearAllBusinessDocs() async {
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.gtsinNumber);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.panNumber);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.tanNumber);

    await _secureSharedPrefs.deleteKey(AppString.sessionKey.gstDocUrl);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.gstDocID);

    await _secureSharedPrefs.deleteKey(AppString.sessionKey.panDocUrl);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.panDocId);

    await _secureSharedPrefs.deleteKey(AppString.sessionKey.tanDocUrl);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.tanDocID);
    await _secureSharedPrefs.deleteKey(AppString.sessionKey.iskycAdarWebview);
  }



  /// Handle Dio Error
  Future<Result<dynamic>> _handleDioError(DioException error) async {
    CustomLog.error(
      this,
      "DIO HTTP call error,Status Code : ${error.response?.statusCode} response : ${error.response}",
      error,
    );
    switch (error.type) {
      case DioExceptionType.badResponse:
        return await _handleHttpError(error.response);
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Error(NetworkTimeoutError());
      default:
        return Error(ErrorWithMessage(message: error.response?.data));
    }
  }

  /// Get Response Result Status
  Future<Result<T>> getResponseStatus<T>(
    dynamic result,
    T Function(dynamic) fromJson,
  ) async {
    if (result[SUCCESS] == true || result[STATUS] == true) {
      final data = fromJson(result);
      return Success(data);
    } else if (result[SUCCESS] == false || result[STATUS] == false) {
      return Error(ErrorWithMessage(message: result[MESSAGE]));
    } else {
      return Error(ResponseStatusFailed());
    }
  }
}
