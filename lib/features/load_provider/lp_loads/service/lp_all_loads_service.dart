import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_verify_advance_response.dart';

class LpLoadService {
  final ApiService _apiService;
  LpLoadService(this._apiService);

  Future<Result<LpLoadResponse>> fetchLoads({
    required LoadListApiRequest request,
    bool forceRefresh = false,
  }) async {

    try {
      final url = ApiUrls.lpLoadList;
      final response = await _apiService.get(
        url,
        queryParams: request.toJson(),
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value;
        final loads = LpLoadResponse.fromJson(data);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }


  Future<Result<LoadGetByIdResponse>> fetchLoadsById({
    required String loadId,
    bool forceRefresh = false
  }) async {

    try {
      final url = ApiUrls.lpLoadById;
      final response = await _apiService.get(
        '$url/$loadId',
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value;
        final loads = LoadGetByIdResponse.fromJson(data);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<LpLoadMemoResponse>> fetchMemoDetails({required String loadId, bool forceRefresh = false}) async {

    try {
      final url = ApiUrls.lpLoadMemo;
      final response = await _apiService.get('$url/$loadId/memo', forceRefresh: forceRefresh);

      if (response is Success) {
        final data = response.value;
        final loads = LpLoadMemoResponse.fromJson(data);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<List<LoadTruckTypeListModel>>> fetchTruckTypeList() async {
    try {
      final url = ApiUrls.loadTruckType;
      final response = await _apiService.get(url);
      if (response is Success) {
        final List<dynamic> list = response.value;
        final loads = list.map((e) => LoadTruckTypeListModel.fromJson(e)).toList();
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<LpLoadRouteResponse>> fetchRouteList() async {
    try {
      final url = ApiUrls.lpLoadRoute;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = LpLoadRouteResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }


  Future<Result<LpLoadMemoOtpResponse>> sendOtp({required String customerId, required String loadId}) async {
    try {
      final url = ApiUrls.lpLoadSendOtp;
      final response = await _apiService.get('$url/$customerId/$loadId');
      if (response is Success) {
        final loads = LpLoadMemoOtpResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<LpLoadMemoVerifyOtpResponse>> verifyOtp({required String customerId, required String otp, required String loadId}) async {
    try {
      final url = ApiUrls.lpLoadVerifyOtp;
      final response = await _apiService.post(url, body: {"otp":otp, "customerId":customerId, "loadId": loadId});

      if (response is Success) {
        final loads = LpLoadMemoVerifyOtpResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<CreditCheckApiResponse>> getCreditCheck({ required String customerId,}) async {
    try {
      final url = ApiUrls.lpCreditCheck;
      final response = await _apiService.get('$url/$customerId');

      if (response is Success) {
        final loads = CreditCheckApiResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<LpLoadCreditUpdateResponse>> updateCreditCheck({required String creditLimit, required String creditUsed, required String customerId}) async {
    try {
      final url = ApiUrls.lpCreditCheck;
      final response = await _apiService.put(url, body: {
        "creditLimit": creditLimit,
        "creditUsed": creditUsed,
        "updatedBy": customerId,
        "sourceType": "LOADPROVIDER"
      });

      if (response is Success) {
        final loads = LpLoadCreditUpdateResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<LpLoadAgreeResponse>> loadAgree({required String customerId, required String loadId}) async {
    try {
      final url = ApiUrls.lpLoadAgree;
      final response = await _apiService.post(url, body: {"loadId":loadId, "customerId":customerId});

      if (response is Success) {
        final loads = LpLoadAgreeResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  Future<Result<LpLoadVerifyAdvanceResponse>> verifyAdvance({required String customerId, required String loadId, required String percentageId}) async {
    try {
      final url = ApiUrls.lpLoadVerifyAdvance;
      final response = await _apiService.post(url, body: {"loadId":loadId, "customerId":customerId, 'percentageId': percentageId});

      if (response is Success) {
        final loads = LpLoadVerifyAdvanceResponse.fromJson(response.value);
        return Success(loads);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }
}

