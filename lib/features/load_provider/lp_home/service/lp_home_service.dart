import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/get_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_detail_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/create_load_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart' hide Result;
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LpHomeService{
  final ApiService _apiService;
  LpHomeService(this._apiService);

  /// Fetch Profile
  Future<Result<ProfileDetailModel>> getProfileDetails({required String id}) async {
    try {
      final url = ApiUrls.getProfile+id;
      final result = await _apiService.get(url);
      if (result is Success) {
        _apiService.clearCache();
        return  await _apiService.getResponseStatus(result.value, (data)=> ProfileDetailModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Gwt Load
  Future<Result<LPGetLoadModel>> getLoads({required String id}) async {
    try {
      final url = ApiUrls.getLoads+id;
      final result = await _apiService.get(url);
      if (result is Success) {
        _apiService.clearCache();
        return  await _apiService.getResponseStatus(result.value, (data)=> LPGetLoadModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Get Load Details
  Future<Result<LoadDetailResponse>> getLoadDetail({required String id}) async {
    try {
      final url = ApiUrls.loadDetail+id;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> LoadDetailResponse.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Fetch Load Commodity
  Future<Result<LoadCommodityListModel>> fetchLoadCommodityData() async {
    try {
      final url = ApiUrls.loadCommodity;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> LoadCommodityListModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Fetch Truck Type
  Future<Result<LoadTruckTypeListModel>> fetchTruckTypeData() async {
    try {
      final url = ApiUrls.loadTruckType;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> LoadTruckTypeListModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Fetch Recent Route
  Future<Result<RecentRoutesModel?>> fetchRecentRouteData(String userId) async {
    try {
      final url = ApiUrls.getRecentRoute;
      final result = await _apiService.get(url, queryParams: {'customerId': userId});
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> RecentRoutesModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Fetch Truck Type
  Future<Result<LoadTruckTypeListModel>> fetchRateDiscoveryPriceData() async {
    try {
      final url = ApiUrls.getRateDiscoveryPrice;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> LoadTruckTypeListModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Create Load
  Future<Result<CreateLoadModel>> fetchCreateLoadData(CreateLoadApiRequest request) async {
    try {
      final url = ApiUrls.createLoad;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> CreateLoadModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Fetch fetch rate discovery
  Future<Result<RateDiscoveryModel>> fetchRateDiscoveryData(RateDiscoveryApiRequest request) async {
    try {
      final url = ApiUrls.getRateDiscoveryPrice;
      final result = await _apiService.get(url, queryParams: request.toJson());
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> RateDiscoveryModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Fetch Map Auto Complete
  Future<Result<AutoCompleteModel>> fetchMapAutoCompleteData(String input) async {
    try {
      final url = ApiUrls.mapAutoComplete;
      final result = await _apiService.get(url, queryParams: {"input" : input});
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> AutoCompleteModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }


  /// Fetch Verify Location
  Future<Result<VerifyLocationModel>> fetchVerifyLocationData(VerifyLocationApiRequest request) async {
    try {
      final url = ApiUrls.verifyLocation;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> VerifyLocationModel.fromJson(data));
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }



}