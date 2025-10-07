import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/verify_location_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/auto_complete_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/location_address_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_detail_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/create_load_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/rate_discovery_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/verify_location.dart' hide LocationResult;
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_event_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/service/event_service.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';


class LpHomeService{
  final ApiService _apiService;
  final EventService _eventService;
  LpHomeService(this._apiService, this._eventService);


  /// Gwt Load
  Future<Result<LpLoadResponse>> getLoads({required String id}) async {
    try {
      final url = ApiUrls.lpLoadList;
      final result = await _apiService.get(url, queryParams: {'customerId' : id, 'limit' : 3});
      if (result is Success) {
        final data = LpLoadResponse.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
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
      return Error(DeserializationError());
    }
  }


  /// Fetch Load Commodity
 Future<Result<List<LoadCommodityListModel>>> fetchLoadCommodityData() async {
  try {
    final url = ApiUrls.loadCommodity;
    final result = await _apiService.get(url);

    if (result is Success) {
      final List<dynamic> jsonList = result.value;
      final loads = jsonList
          .map((e) => LoadCommodityListModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Success(loads);
    } else if (result is Error) {
      return Error(result.type);
    } else {
      return Error(GenericError());
    }
  } catch (e) {
    return Error(DeserializationError());
  }
}



  /// Fetch Truck Type
  Future<Result<List<LoadTruckTypeListModel>>> fetchTruckTypeData() async {
    try {
      final url = ApiUrls.loadTruckType;
      final result = await _apiService.get(url);
      if (result is Success) {
        final List<dynamic> list = result.value;
        final loads = list.map((e) => LoadTruckTypeListModel.fromJson(e)).toList();
        return Success(loads);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }


  /// Fetch Recent Route
  Future<Result<RecentRoutesModel>> fetchRecentRouteData(String userId, {String? search, int? currentPage,}) async {
    try {
      final url = ApiUrls.getRecentRoute;
      final result = await _apiService.get(url, queryParams: {'customerId': userId, 'search' : search, 'limit' : 10, 'page': currentPage});
      if (result is Success) {
        final data = RecentRoutesModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
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
      return Error(DeserializationError());
    }
  }


  /// Create Load
  Future<Result<CreateLoadModel>> fetchCreateLoadData(CreateLoadApiRequest request) async {
    try {
      final url = ApiUrls.createLoad;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        final data = CreateLoadModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }


  /// Fetch fetch rate discovery
  Future<Result<RateDiscoveryModel>> fetchRateDiscoveryData(RateDiscoveryApiRequest request) async {
    try {
      final url = ApiUrls.getRateDiscoveryPrice;
      final result = await _apiService.get(url, queryParams: request.toJson());
      if (result is Success) {
        final data = RateDiscoveryModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }


  /// Fetch Map Auto Complete
  Future<Result<AutoCompleteModel>> fetchMapAutoCompleteData(String input) async {
    try {
      final url = ApiUrls.mapAutoComplete;
      final result = await _apiService.get(url, queryParams: {"input" : input});
      if (result is Success) {
        final data = AutoCompleteModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }


  /// Fetch Verify Location
  Future<Result<VerifyLocationModel>> fetchVerifyLocationData(VerifyLocationApiRequest request) async {
    try {
      final url = ApiUrls.verifyLocation;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        final data = VerifyLocationModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }


  /// Fetch Weight Load
  Future<Result<List<LoadWeightModel>>> fetchLoadWeightData() async {
    try {
      final url = ApiUrls.getWeight;
      final result = await _apiService.get(url);
      if (result is Success) {
        final List<dynamic> list = result.value;
        final loads = list.map((e) => LoadWeightModel.fromJson(e)).toList();
        return Success(loads);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  /// setBluId
  Future<Result<void>> setBluIDFlag(String userId) async {
    try {
      final url = ApiUrls.bluIdFlg+userId;
      final result = await _apiService.patch(url);
      if (result is Success) {
        return Success(null);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  /// Create Event
  Future<Result<String?>> createEvent(CreateEventApiRequest request) async {
    try {
      return await _eventService.createEvent(request);
    } catch (e) {
      return Error(DeserializationError());
    }
  }

  /// updated App Event
  Future<Result<String?>> updatedAppEvent({ required String eventId, required String stage,String? entityId, Map<String, dynamic>? context}) async {
    try {
      return await _eventService.updatedAppEvent(stage: stage,eventId: eventId,entityId: entityId,context: context);
    } catch (e) {
      return Error(DeserializationError());
    }
  }


  /// Fetch location address
  Future<Result<LocationAddressResponse>> fetchLocationAddress({required double lat, required double lng}) async {
    try {
      final url = ApiUrls.getLocationAddress;
      final result = await _apiService.get(url, queryParams: {'lat': lat, 'lng': lng});
      if (result is Success) {
        final data = LocationAddressResponse.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }




}