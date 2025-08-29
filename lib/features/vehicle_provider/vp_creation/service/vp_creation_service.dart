import 'dart:io';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/api_request/vp_creation_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/VpCompanyTypeModel.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/upload_rc_truck_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/vp_creation_model.dart';


class VpCreationService {
  final ApiService _apiService;
  VpCreationService(this._apiService);


  // Fetch Vp Creation
  Future<Result<UserModel?>> fetchVpCreationData(VpCreationApiRequest request,{required String id}) async {
    try {
      final url = ApiUrls.createLpAccount;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        final data = UserModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {

        print("result in fetchVpCreationData ${result.type}");
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }

  // Fetch Truck Type
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

  // Fetch Upload Rc Truck File
  Future<Result<UploadRcTruckFileModel>> fetchUploadRcTruckFileData(File files,String? userId) async {
    try {
      final url = ApiUrls.upload;
      final result = await _apiService.multipart(
          url,
          files,
          fields: {"fileType":"upload_rc", "userId": userId ?? ""},
          pathName: "file",
      );
      if (result is Success) {
      final data = UploadRcTruckFileModel.fromJson(result.value);
        return   Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e) {
      return Error(DeserializationError());
    }
  }


  // Fetch Company Type
  Future<Result<List<VpCompanyTypeModel>>> fetchGetCompanyTypeData() async {
    try {
      // Add debugging for company-type API call
      print('🔐 Company Type API: Starting API call to ${ApiUrls.companyType}');
      
      // Check if token is available before making the API call
      bool hasToken = await _apiService.hasValidToken();
      print('🔐 Company Type API: Token available: $hasToken');
      
      if (!hasToken) {
        print('🔐 Company Type API: No token available - API call may fail');
      }
      
      final result = await _apiService.get(ApiUrls.companyType);
      
      if (result is Success) {
        print('🔐 Company Type API: Success response received');
        final responseData = result.value;
        if (responseData is List) {
          final companyTypes = responseData.map((e) => VpCompanyTypeModel.fromJson(e)).toList();
          print('🔐 Company Type API: Parsed ${companyTypes.length} company types');
          return Success(companyTypes);
        } else {
          print('🔐 Company Type API: Response is not a list');
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        print('🔐 Company Type API: Error response - ${result.type}');
        return Error(result.type);
      } else {
        print('🔐 Company Type API: Unknown response type');
        return Error(GenericError());
      }
    } catch (e) {
      print('🔐 Company Type API: Exception caught - $e');
      return Error(DeserializationError());
    }
  }



}