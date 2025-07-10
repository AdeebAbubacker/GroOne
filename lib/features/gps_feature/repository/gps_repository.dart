import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../models/gps_geofence_model.dart';
import '../service/gps_service.dart';

class GpsRepository {
  final GpsService _service;

  GpsRepository(this._service);

  Future<Result<List<GpsGeofenceModel>>> fetchGeofences() async {
    try {
      return await _service.fetchGeofences();
    } catch (e) {
      CustomLog.error(this, "Failed to fetch geofences in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
  Future<Result<void>> addOrUpdateGeofence(GpsGeofenceModel model) async {
    try {
      return await _service.addOrUpdateGeofence(model);
    } catch (e) {
      CustomLog.error(this, "Failed to add/update geofence in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}
