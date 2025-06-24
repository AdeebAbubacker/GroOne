import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';

class LpLoadService {
  final ApiService _apiService;
  LpLoadService(this._apiService);

  Future<Result<List<LpLoadItem>>> fetchLoads({
    required String customerId,
    required int type,
    String search = "",
    bool forceRefresh = false
  }) async {

    try {
      final url = ApiUrls.lpLoadList;
      final response = await _apiService.get(
        '$url?page=1&limit=20&search=$search&loadStatus=$type&customerId=$customerId',
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value['data']['data'] as List;
        final loads = data.map((e) => LpLoadItem.fromJson(e)).toList();
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


  Future<Result<LpLoadGetByIdResponse>> fetchLoadsById({
    required int loadId,
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
        final loads = LpLoadGetByIdResponse.fromJson(data);
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

  Future<Result<LoadMemoData>> fetchMemoDetails({required int loadId, bool forceRefresh = false}) async {

    try {
      final url = ApiUrls.lpLoadMemo;
      final response = await _apiService.get('$url/$loadId/memo', forceRefresh: forceRefresh);

      if (response is Success) {
        final data = response.value['data'];
        final loads = LoadMemoData.fromJson(data);
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

  Future<Result<LoadTruckTypeListModel>> fetchTruckTypeList() async {
    try {
      final url = ApiUrls.loadTruckType;
      final response = await _apiService.get(url);
      if (response is Success) {
        final loads = LoadTruckTypeListModel.fromJson(response.value);
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


  Future<Result<LpLoadMemoOtpResponse>> sendOtp({required String customerId}) async {
    try {
      final url = ApiUrls.lpLoadSendOtp;
      final response = await _apiService.get('$url/$customerId');
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

  Future<Result<LpLoadMemoOtpResponse>> verifyOtp({required String customerId, required String otp}) async {
    try {
      final url = ApiUrls.lpLoadVerifyOtp;
      final response = await _apiService.post(url, body: {"otp":otp, "customerId":customerId});

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

  Future<Result<LpLoadMemoOtpResponse>> applyFilter({required int fromRoute, required int toRoute, required String truckType, required String loadPostedDate}) async {
    try {
      final url = ApiUrls.lpLoadList;
      final response = await _apiService.get('$url?fromLocationId=$fromRoute&toLocationId=$toRoute&truckTypeId=$truckType&loadPostDate=$loadPostedDate');

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

  Future<Result<LpLoadCreditCheckResponse>> getCreditCheck({ required String customerId,}) async {
    try {
      final url = ApiUrls.lpCreditCheck;
      final response = await _apiService.get('$url/$customerId');

      if (response is Success) {
        final loads = LpLoadCreditCheckResponse.fromJson(response.value);
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

