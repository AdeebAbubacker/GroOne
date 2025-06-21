import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/LPGetLoadModel.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_detail_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/create_load_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart' hide LocationResult;
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LpHomeService{
  final ApiService _apiService;
  final SecuredSharedPreferences _securedSharedPref;
  LpHomeService(this._apiService, this._securedSharedPref);

  /// Fetch Profile
  Future<Result<ProfileDetailModel>> getProfileDetails({required String id}) async {
    try {
      final url = ApiUrls.getProfile+id;
      final result = await _apiService.get(url);
      if (result is Success) {
        dynamic data = await _apiService.getResponseStatus(result.value, (data)=> ProfileDetailModel.fromJson(data));
        // Save Blue Id
        if (data is Success<ProfileDetailModel>) {
          if (data.value.data?.customer != null && data.value.data!.customer!.blueId.isNotEmpty) {
            await _securedSharedPref.saveKey(AppString.sessionKey.blueId, data.value.data!.customer!.blueId);
            CustomLog.debug(this, "Saved Blue Id: ${data.value.data!.customer!.blueId}");
          }
          return Success(data.value);
        }
        if (data is Error) {
          return Error(data.type);
        }
        return Error(GenericError());
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
  Future<Result<LpGetLoadModel>> getLoads({required String id}) async {
    try {
      final url = ApiUrls.getLoads+id;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> LpGetLoadModel.fromJson(data));
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
  Future<Result<RecentRoutesModel>> fetchRecentRouteData(String userId) async {
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


  /// Fetch Weight Load
  Future<Result<LoadWeightModel>> fetchLoadWeightData() async {
    try {
      final url = ApiUrls.getWeight;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> LoadWeightModel.fromJson(data));
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