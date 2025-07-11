import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';



class VpDetailsService{
  final ApiService _apiService;


  const VpDetailsService(this._apiService);

   Future<Result<LoadDetailsResponseModel>> fetchLoadDetails(String? loadId) async {
    try {
      final url =  "${ApiUrls.getLoadById}$loadId";
      final result = await _apiService.get(url);
      if (result is Success) {
        final loadDetailsResponse=LoadDetailsResponseModel.fromJson(result.value);
        return Success(loadDetailsResponse);
      } else if (result is Error) {

        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e,stacktress){
      print("stacktress ${stacktress}");
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<VpLoadAcceptModel>> changeLoadStatus({required String? userId,required String loadId,required int? loadStatus}) async {
    try {
      final result = await _apiService.put(
        queryParams: {
          "loadStatus":loadStatus
        },
          '${ApiUrls.vpAcceptLoad}$userId/$loadId');
      if (result is Success) {
       final changeLoadStatusResponse= VpLoadAcceptModel.fromJson(result.value);
        return Success(changeLoadStatusResponse);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }




}