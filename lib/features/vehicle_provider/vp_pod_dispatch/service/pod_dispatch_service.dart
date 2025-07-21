import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/api_request/submit_pod_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/model/pod_center_list_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class PodDispatchService {
  final ApiService _apiService;
  PodDispatchService(this._apiService);

  /// Fetch Pod Center List Service
  Future<Result<PodCenterListModel>> fetchPodCenterList() async {
    try {
      final url = ApiUrls.podCenter;
      final result = await _apiService.get(url);
      if (result is Success) {
        final data= PodCenterListModel.fromJson(result.value);
        return Success(data);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }


  /// Submit Pod Service
  Future<Result<bool>> submitPod(SubmitPodApiRequest request) async {
    try {
      final url = ApiUrls.submitPod;
      final result = await _apiService.post(url, body: request.toJson());
      if (result is Success) {
        return Success(true);
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