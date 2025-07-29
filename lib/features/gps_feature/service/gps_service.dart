import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/custom_log.dart';
import '../../load_provider/lp_home/model/auto_complete_model.dart';
import '../model/gps_user_details_model.dart';
import '../models/gps_geofence_model.dart';
import '../models/gps_notification_model.dart';
import '../models/gps_parking_model.dart';

class GpsService {
  final ApiService _apiService;
  GpsService(this._apiService);

  Future<Result<int?>> getUserId(String token) async {
    try {
      final response = await _apiService.get(
        ApiUrls.gpsGetUserId,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(response.value, (data) {
          final userDetails = GpsUserDetailsModel.fromJson(data);
          return userDetails.firstUser?.id;
        });
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to get user ID", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<List<GpsGeofenceModel>>> fetchGeofences(String token) async {
    try {
      final response = await _apiService.get(
        ApiUrls.gpsFetchGeofences,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
          (data) =>
              (data['data'] as List)
                  .map((e) => GpsGeofenceModel.fromJson(e))
                  .toList(),
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch geofences", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<void>> addOrUpdateGeofence(
    GpsGeofenceModel model,
    String token,
  ) async {
    try {
      final area = generateArea(model);

      final body = {
        "id": int.tryParse(model.id) ?? -1,
        "name": model.name,
        "area": area,
        "attributes": {"type": model.shapeType},
      };

      // Choose API URL based on whether it's an update (id exists) or add
      final String apiUrl =
          (int.tryParse(model.id) != null && int.tryParse(model.id)! > 0)
              ? ApiUrls.gpsUpdateGeofence
              : ApiUrls.gpsAddGeofence;

      final response = await _apiService.post(
        apiUrl,
        body: body,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(response.value, (_) => null);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to add/update geofence", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<GpsGeofenceModel>>> fetchGeofencesForVehicle({
    required String userId,
    required String deviceId,
    required String token,
  }) async {
    try {
      final url = ApiUrls.gpsFetchGeofencesForVehicle(userId, deviceId);
      final response = await _apiService.get(
        url,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
          (data) =>
              (data['data'] as List)
                  .map((e) => GpsGeofenceModel.fromJson(e))
                  .toList(),
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch geofences for vehicle", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<void>> linkUnlinkGeofenceDevice({
    required String deviceId,
    required String geofenceId,
    required bool link,
    required String token,
  }) async {
    try {
      final body = {
        "device_id": int.parse(deviceId),
        "geofence_id": int.parse(geofenceId),
        "link": link,
      };

      final response = await _apiService.post(
        ApiUrls.gpsLinkUnlinkGeofenceDevice,
        body: body,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(response.value, (_) => null);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to link/unlink geofence", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<AutoCompleteModel>> fetchMapAutoCompleteData(
    String input,
  ) async {
    try {
      final url = ApiUrls.mapAutoComplete;
      final response = await _apiService.get(
        url,
        queryParams: {"input": input},
      );
      if (response is Success) {
        // return await _apiService.getResponseStatus(
        //   response.value,
        //   (data) => AutoCompleteModel.fromJson(data),
        // );
        try {
          final parsed = AutoCompleteModel.fromJson(response.value);
          return Success(parsed);
        } catch (e) {
          return Error(DeserializationError());
        }
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch map auto complete", e);
      return Error(DeserializationError());
    }
  }

  Future<Result<List<GpsNotificationModel>>> fetchNotifications({
    required String token,
    required String userId,
    int days = 10,
    int limit = 200,
  }) async {
    try {
      final url = ApiUrls.gpsFetchNotifications(userId, days, limit);
      final response = await _apiService.get(
        url,
        customHeaders: {'Authorization': token},
      );
      if (response is Success) {
        try {
          final data = response.value;
          final notifications =
              (data['data'] as List) // 👈 Access the inner list
                  .map((e) => GpsNotificationModel.fromJson(e))
                  .toList();
          return Success(notifications);
        } catch (e) {
          CustomLog.error(this, "Error parsing notifications", e);
          return Error(DeserializationError());
        }
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch notifications", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  String generateArea(GpsGeofenceModel model) {
    if (model.shapeType == "circle" &&
        model.center != null &&
        model.radius != null) {
      return "CIRCLE (${model.center!.latitude} ${model.center!.longitude}, ${model.radius})";
    }

    if ((model.shapeType == "polygon" || model.shapeType == "polyline") &&
        model.polygonPoints != null &&
        model.polygonPoints!.isNotEmpty) {
      final coords = model.polygonPoints!
          .map((point) => "${point.latitude} ${point.longitude}")
          .join(", ");

      // Adjust shape type for polyline
      final shape =
          model.shapeType == "polyline"
              ? "LINESTRING"
              : model.shapeType.toUpperCase(); // POLYGON or LINESTRING

      return "$shape (($coords))";
    }

    throw Exception("Invalid geofence data for area generation");
  }

  Future<Result<List<GpsParkingModeModel>>> fetchParkingModeList(
    String token,
  ) async {
    try {
      final response = await _apiService.get(
        ApiUrls.gpsFetchParkingMode,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
          (data) =>
              (data['data'] as List)
                  .map((e) => GpsParkingModeModel.fromJson(e))
                  .toList(),
        );
      } else {
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch parking mode list", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<GpsParkingModeModel>> updateParkingMode({
    required int? id,
    required int deviceId,
    required bool parkingMode,
    required String token,
  }) async {
    final payload = {"device_id": deviceId, "parking_mode": parkingMode};

    try {
      final response =
          id != null && id > 0
              ? await _apiService.patch(
                ApiUrls.gpsUpdateParkingMode(id),
                body: payload,
                customHeaders: {'Authorization': token},
              )
              : await _apiService.post(
                ApiUrls.gpsFetchParkingMode,
                body: payload,
                customHeaders: {'Authorization': token},
              );
      if (response is Success) {
        final raw = response.value['data'];

        // POST returns a list
        if (raw is List && raw.isNotEmpty) {
          return Success(GpsParkingModeModel.fromJson(raw.first));
        }

        // PATCH returns an empty object, fallback to using the input model
        if (raw is Map && raw.isEmpty) {
          return Success(
            GpsParkingModeModel(
              id: id ?? -1, // PATCH always has id
              deviceId: deviceId,
              parkingMode: parkingMode,
            ),
          );
        }

        // If something goes wrong
        throw Exception("Unexpected response format in updateParkingMode");
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Update parking mode error", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<void>> updateParkingModeSchedule({
    required int id,
    required int deviceId,
    required bool parkingSchedule,
    required String parkingScheduleStartUtc,
    required String parkingScheduleEndUtc,
    required List<String> parkingScheduleDays,
    required String token,
  }) async {
    try {
      final body = {
        "device_id": deviceId,
        "parking_schedule": parkingSchedule,
        "parking_schedule_start_utc": parkingScheduleStartUtc,
        "parking_schedule_end_utc": parkingScheduleEndUtc,
        "parking_schedule_days": parkingScheduleDays,
      };

      final response = await _apiService.patch(
        ApiUrls.gpsUpdateParkingMode(id),
        body: body,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(response.value, (_) => null);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to update parking mode schedule", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<Result<Map<String, dynamic>>> fetchDeprecatedNotificationStatus(String token) async {
    try {
      final response = await _apiService.get(
        ApiUrls.getDeprecatedNotificationStatus,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return Success(response.value as Map<String, dynamic>);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "fetchDeprecatedNotificationStatus failed", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<Result<void>> updateDeprecatedNotificationStatus(
      Map<String, dynamic> payload,
      String token,
      ) async {
    try {
      final response = await _apiService.post(
        ApiUrls.updateDeprecatedNotificationStatus,
        body: payload,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        final value = response.value;
        if (value is Map<String, dynamic> && value['status'] == 'success') {
          value['status'] = true;
        }

        return await _apiService.getResponseStatus(value, (_) => null);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "updateDeprecatedNotificationStatus failed", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<void>> updateNotificationToggle(
      Map<String, dynamic> payload,
      String token,
      int userConfigurationId
      ) async {
    try {
      final response = await _apiService.patch(
        ApiUrls.gpsUpdateNotificationToggle(userConfigurationId), // replace with user-specific ID if needed
        body: payload,
        customHeaders: {'Authorization': token},
      );

      if (response is Success) {
        return await _apiService.getResponseStatus(response.value, (_) => null);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "updateNotificationToggle failed", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LatLng>> fetchLatLngFromPlaceId(String placeId) async {
    try {
      final url = ApiUrls.gpsGetPlace;
      final response = await _apiService.get(
        url,
        queryParams: {"placeId": placeId},
      );

      if (response is Success) {
        final data = response.value;
        final location = data["result"]["geometry"]["location"];
        final lat = location["lat"];
        final lng = location["lng"];
        return Success(LatLng(lat, lng));
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch LatLng from placeId", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }



}
