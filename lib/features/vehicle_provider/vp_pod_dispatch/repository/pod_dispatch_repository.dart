import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/api_request/submit_pod_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/model/pod_center_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_pod_dispatch/service/pod_dispatch_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class PodDispatchRepository {
  final PodDispatchService _service;
  PodDispatchRepository(this._service);

  /// Gat POD Center List Repo
  Future<Result<PodCenterListModel>> getPodCenterListData() async {
    try {
      return await _service.fetchPodCenterList();
    } catch (e) {
      CustomLog.error(this, "Failed to request pod center list data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Submit POD Repo
  Future<Result<bool>> getSubmitPodData(SubmitPodApiRequest request) async {
    try {
      return await _service.submitPod(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request submit pod data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}