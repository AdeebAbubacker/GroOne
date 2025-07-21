import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../../load_provider/lp_home/api_request/verify_location_api_request.dart';
import '../../load_provider/lp_home/model/auto_complete_model.dart';
import '../../load_provider/lp_home/model/verify_location.dart';
import '../models/gps_geofence_model.dart';
import '../models/gps_notification_model.dart';
import '../service/gps_service.dart';
import 'gps_login_repository.dart';

class GpsRepository {
  final GpsService _service;
  final GpsLoginRepository _loginRepository;

  GpsRepository(this._service, this._loginRepository);

  Future<String?> _getToken() async {
    final loginResponse = await _loginRepository.getStoredLoginResponse();
    return loginResponse?.token;
  }

  Future<Result<List<GpsGeofenceModel>>> fetchGeofences() async {
    try {
      final token = await _getToken();
      if (token == null) return Error(GenericError());
      return await _service.fetchGeofences(token);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch geofences in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<void>> addOrUpdateGeofence(GpsGeofenceModel model) async {
    try {
      final token = await _getToken();
      if (token == null) return Error(GenericError());
      return await _service.addOrUpdateGeofence(model, token);
    } catch (e) {
      CustomLog.error(this, "Failed to add/update geofence in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<GpsGeofenceModel>>> fetchGeofencesForVehicle(String deviceId) async {
    try {
      final token = await _getToken();
      if (token == null) return Error(GenericError());
      return await _service.fetchGeofencesForVehicle(
        userId: '163',
        deviceId: deviceId,
        token: token,
      );
    } catch (e) {
      CustomLog.error(this, "Failed to fetch geofences for vehicle", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<void>> linkUnlinkGeofenceDevice(String deviceId, String geofenceId, bool link) async {
    try {
      final token = await _getToken();
      if (token == null) return Error(GenericError());
      return await _service.linkUnlinkGeofenceDevice(
        deviceId: deviceId,
        geofenceId: geofenceId,
        link: link,
        token: token,
      );
    } catch (e) {
      CustomLog.error(this, "Failed to link/unlink geofence in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<AutoCompleteModel>> getAutoCompleteData(String input) async {
    try {
      return await _service.fetchMapAutoCompleteData(input);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch autocomplete data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get Verify Location data from repository
  Future<Result<VerifyLocationModel>> getVerifyLocationData(VerifyLocationApiRequest request) async {
    try {
      return await _service.fetchVerifyLocationData(request);
    } catch (e) {
      CustomLog.error(this, "Failed to verify location", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<GpsNotificationModel>>> fetchNotifications() async {
    try {
      final token = await _getToken();
      if (token == null) return Error(GenericError());
      return await _service.fetchNotifications(
        token: token,
        userId: '163',
      );
    } catch (e) {
      CustomLog.error(this, "Failed to fetch notifications in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

}
