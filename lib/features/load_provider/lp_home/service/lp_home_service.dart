import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/get_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_detail_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LpHomeService{
  final ApiService _apiService;
  LpHomeService(this._apiService);
  Future<Result<ProfileDetailResponse>> getProfileDetails({required String id}) async {
    try {
      final url = ApiUrls.getProfile+id;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> ProfileDetailResponse.fromJson(data));
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
  Future<Result<GetLoadResponse>> getLoads({required String id}) async {
    try {
      final url = ApiUrls.getLoads+id;
      final result = await _apiService.get(url);
      if (result is Success) {
        return  await _apiService.getResponseStatus(result.value, (data)=> GetLoadResponse.fromJson(data));
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
}