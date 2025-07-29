import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/model/result.dart';
import '../../../utils/custom_log.dart';
import '../../load_provider/lp_home/api_request/verify_location_api_request.dart';
import '../../load_provider/lp_home/model/auto_complete_model.dart';
import '../../load_provider/lp_home/model/verify_location.dart';
import '../model/gps_user_config_model.dart';
import '../models/gps_geofence_model.dart';
import '../models/gps_notification_model.dart';
import '../models/gps_parking_model.dart';
import '../service/gps_service.dart';
import 'gps_login_repository.dart';

class GpsRepository {
  final GpsService _service;
  final GpsLoginRepository _loginRepository;
  int? _cachedUserId;


  GpsRepository(this._service, this._loginRepository);

  Future<String?> _getToken() async {
    final loginResponse = await _loginRepository.getStoredLoginResponse();
    return loginResponse?.token;
  }

  Future<int?> getUserConfigIdByUserId(int userId) async {
    try {
      final config = await _loginRepository.getStoredUserConfig();
      if (config?.data == null) return null;

      for (var user in config!.data!) {
        debugPrint(user.id.toString());
      }
      final matchedData = config!.data!.firstWhere(
        (element) => element.userId == userId,
        orElse: () => GpsUserConfigData(), // Empty instance if not found
      );

      return matchedData.id;
    } catch (e) {
      CustomLog.error(this, "Error in getUserConfigIdByUserId", e);
      return null;
    }
  }

  Future<int?> _getUserId() async {
    if (_cachedUserId != null) return _cachedUserId;

    final token = await _getToken();
    if (token == null) return null;

    final result = await _service.getUserId(token);
    if (result is Success<int?>) {
      _cachedUserId = result.value;
      debugPrint("User ID Saved in repository: $_cachedUserId");
      return _cachedUserId;
    }

    return null;
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

  Future<Result<List<GpsGeofenceModel>>> fetchGeofencesForVehicle(
    String deviceId,
  ) async {
    try {
      final token = await _getToken();
      final userId = await _getUserId();
      if (token == null || userId == null) return Error(GenericError());

      return await _service.fetchGeofencesForVehicle(
        userId: userId.toString(),
        deviceId: deviceId,
        token: token,
      );
    } catch (e) {
      CustomLog.error(this, "Failed to fetch geofences for vehicle", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<void>> linkUnlinkGeofenceDevice(
    String deviceId,
    String geofenceId,
    bool link,
  ) async {
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


  Future<Result<List<GpsNotificationModel>>> fetchNotifications() async {
    try {
      final token = await _getToken();
      final userId = await _getUserId();
      if (token == null || userId == null) return Error(GenericError());
      return await _service.fetchNotifications(token: token, userId: userId.toString());
    } catch (e) {
      CustomLog.error(this, "Failed to fetch notifications in repository", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<GpsParkingModeModel>>> fetchParkingModes() async {
    try {
      final token = await _getToken();
      if (token == null) return Error(GenericError());
      return await _service.fetchParkingModeList(token);
    } catch (e) {
      CustomLog.error(this, "Failed to fetch parking modes", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<Result<GpsParkingModeModel>> updateParkingMode({
    required int? id,
    required int deviceId,
    required bool parkingMode,
  }) async {
    final token = await _getToken();
    if (token == null) return Error(GenericError());

    return await _service.updateParkingMode(
      id: id,
      deviceId: deviceId,
      parkingMode: parkingMode,
      token: token,
    );
  }

  Future<Result<void>> updateParkingModeSchedule({
    required int id,
    required int deviceId,
    required bool parkingSchedule,
    required String parkingScheduleStartUtc,
    required String parkingScheduleEndUtc,
    required List<String> parkingScheduleDays,
  }) async {
    final token = await _getToken();
    if (token == null) return Error(GenericError());

    return await _service.updateParkingModeSchedule(
      id: id,
      deviceId: deviceId,
      parkingSchedule: parkingSchedule,
      parkingScheduleStartUtc: parkingScheduleStartUtc,
      parkingScheduleEndUtc: parkingScheduleEndUtc,
      parkingScheduleDays: parkingScheduleDays,
      token: token,
    );
  }

  Future<Result<Map<String, dynamic>>>
  fetchDeprecatedNotificationStatus() async {
    final token = await _getToken();
    if (token == null) return Error(GenericError());
    return await _service.fetchDeprecatedNotificationStatus(token);
  }

  Future<Result<void>> updateDeprecatedNotificationStatus(
    Map<String, dynamic> payload,
  ) async {
    final token = await _getToken();
    if (token == null) return Error(GenericError());
    return await _service.updateDeprecatedNotificationStatus(payload, token);
  }

  Future<Result<void>> updateNotificationToggle({
    required String deviceToken,
    Map<String, dynamic>? deviceDetails,
    String? deviceType,
  }) async {
    final token = await _getToken();
    if (token == null) return Error(GenericError());

    final Map<String, dynamic> payload = {"device_token": deviceToken};

    if (deviceDetails != null) {
      payload["device_details"] = deviceDetails;
    }

    if (deviceType != null) {
      payload["device_type"] = deviceType;
    }

    return await _service.updateNotificationToggle(payload, token, 41065);
  }

  Future<Result<LatLng>> fetchLatLngFromPlaceId(String placeId) async {
    return await _service.fetchLatLngFromPlaceId(placeId);
  }

}
