import 'dart:developer';
import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../data/storage/secured_shared_preferences.dart';
import '../../../utils/app_string.dart';
import '../../en-dhan_fuel/model/document_upload_response.dart';


import 'dart:io';

import '../model/fastag_list_response.dart';

class FastagService {
  final ApiService _apiService;
  final SecuredSharedPreferences _secureSharedPrefs;

  FastagService(this._apiService, this._secureSharedPrefs);

  Future<Result<DocumentUploadResponse>> uploadDocument(File file) async {
    final userId = await _secureSharedPrefs.get(AppString.sessionKey.userId);
    if (userId == null || userId.isEmpty) {
      return Error(ErrorWithMessage(message: 'User ID not found'));
    }

    final url = ApiUrls.documentUpload;
    final fields = {
      'userId': userId,
      'fileType': 'rc_book',
      'documentType': 'fastag_document',
    };

    final result = await _apiService.multipart(url, file, pathName: "file", fields: fields);

    if (result is Success) {
      final data = DocumentUploadResponse.fromJson(result.value);
      return Success(data);
    } else if (result is Error) {
      return Error(result.type);
    } else {
      return Error(GenericError());
    }
  }

  Future<Result<bool>> addVehicleRequest({
    required String referralCode,
    required String addressName,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String contactNo,
    required List<Map<String, String>> vehicles,
  }) async {
    try {

      final customerId   = await _secureSharedPrefs.get(AppString.sessionKey.userId);
      if (customerId == null || customerId.isEmpty) {
        return Error(ErrorWithMessage(message: 'Customer ID not found'));
      }

      final body = {
        "customerId": customerId,
        "referralCode": referralCode,
        "addressName": addressName,
        "address": address,
        "city": city,
        "state": state,
        "pincode": pincode,
        "contactNo": contactNo,
        "Vehicles": vehicles,
      };

      final response = await _apiService.post(
        ApiUrls.fastagAddVehicle,
        body: body,
      );


      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
              (data) => data['success'] == true,
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  // Future<Result<FastagListResponse>> getFastagList({String searchTerm = ''}) async {
  //   try {
  //     final customerId = await _secureSharedPrefs.get(AppString.sessionKey.userId);
  //     if (customerId == null || customerId.isEmpty) {
  //       return Error(ErrorWithMessage(message: 'Customer ID not found'));
  //     }
  //
  //     String url = 'https://gro-uat-api.letsgro.co/vendor/api/v1/fast-tag/card/$customerId';
  //     // Append searchTerm if not empty
  //     if (searchTerm.isNotEmpty) {
  //       url += '?searchTerm=${Uri.encodeComponent(searchTerm)}';
  //     }
  //
  //     final response = await _apiService.get(url);
  //
  //     if (response is Success) {
  //       final data = FastagListResponse.fromJson(response.value);
  //       return Success(data);
  //     } else {
  //       return Error(response is Error ? response.type : GenericError());
  //     }
  //   } catch (e) {
  //     return Error(ErrorWithMessage(message: e.toString()));
  //   }
  // }

  Future<Result<FastagListResponse>> getFastagList({String searchTerm = ''}) async {
    try {
      final customerId = await _secureSharedPrefs.get(AppString.sessionKey.userId);
      if (customerId == null || customerId.isEmpty) {
        return Error(ErrorWithMessage(message: 'Customer ID not found'));
      }

      // String url = 'https://gro-uat-api.letsgro.co/vendor/api/v1/fast-tag/card/$customerId';
      String url = ApiUrls.fastagOrderList(customerId);
      if (searchTerm.isNotEmpty) {
        url += '?searchTerm=${Uri.encodeComponent(searchTerm)}';
      }

      final response = await _apiService.get(url);

      if (response is Success) {
        final json = response.value;

        // If API says success = false but no data, treat it as empty list Success
        if (json is Map && json['success'] == false && (json['data'] == null || json['data'] == '')) {
          return Success(FastagListResponse(
            success: false,
            message: json['message'] ?? '',
            data: [], totalCount: 0,
          ));
        }

        final data = FastagListResponse.fromJson(json);
        return Success(data);
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}
