import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';

import '../../../../data/model/result.dart';
import '../../../../data/network/api_service.dart';
import '../../vp_home/model/vp_recent_load_response.dart';

class VpLoadService {
  final ApiService _apiService;
  VpLoadService(this._apiService);

  Future<Result<List<VpRecentLoadData>>> fetchLoads({
    required String customerId,
    required int type,
    String search = "",
    bool forceRefresh = false,
    int? limit

  }) async {
    try {
      final response = await _apiService.get(
        '${ApiUrls.getAllVpLoads}/vp/load?customerId=$customerId&search=$search',
        queryParams: {
          "limit":limit??10,
        if(type!=2) "type":type

        },
        forceRefresh: forceRefresh,
      );

      if (response is Success) {
        final data = response.value['data']['data'] as List;
        final loads = data.map((e) => VpRecentLoadData.fromJson(e)).toList();
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

  Future<Result<List<LoadStatusResponse>>> fetchVpLoadStatus() async {
    try {
      final url = ApiUrls.getLoadStatusVp;
      final response = await _apiService.get(url);
      if (response is Success) {
        final List<dynamic> list = response.value;
        final loads = list.map((e) => LoadStatusResponse.fromJson(e)).toList();
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

  Future<Result<List<TruckTypeModel>>> fetchTruckTypeData() async {
    try {
      final url = ApiUrls.loadTruckType;
      final result = await _apiService.get(url);
      if (result is Success) {
        final data = result.value;
        if (data is List) {
          final truckType = data.map((e) => TruckTypeModel.fromJson(e)).toList();
          return Success(truckType);
        } else {
          return Error(GenericError());
        }
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  // Fetch Truck Pref Lane
  Future<Result<TruckPrefLaneModel>> fetchTruckPrefLaneData(String? location,{int? currentPage}) async {
    try {
      final url = location?.isNotEmpty == true ? "${ApiUrls.truckPrefLane}?search=$location" : ApiUrls.truckPrefLane;
      final result = await _apiService.get(url,
          queryParams: {
            "limit":10,
            "page":currentPage
           }
          );
      if (result is Success) {
        final data = TruckPrefLaneModel.fromJson(result.value);
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

}

