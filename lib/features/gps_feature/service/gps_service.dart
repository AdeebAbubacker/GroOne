import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/custom_log.dart';
import '../../load_provider/lp_home/api_request/verify_location_api_request.dart';
import '../../load_provider/lp_home/model/auto_complete_model.dart';
import '../../load_provider/lp_home/model/verify_location.dart';
import '../model/gps_user_details_model.dart';
import '../models/gps_geofence_model.dart';
import '../models/gps_notification_model.dart';

class GpsService {
  final ApiService _apiService;

  GpsService(this._apiService);

  // Helper method to get user ID from user details
  Future<Result<int?>> getUserId(String token) async {
    try {
      final response = await _apiService.get(
        'https://api.letsgro.co/api/v1/auth/tc_users',
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
        return await _apiService.getResponseStatus(
          response.value,
          (data) => AutoCompleteModel.fromJson(data),
        );
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

  /// Fetch Verify Location
  Future<Result<VerifyLocationModel>> fetchVerifyLocationData(
    VerifyLocationApiRequest request,
  ) async {
    try {
      final url = ApiUrls.verifyLocation;
      final response = await _apiService.post(url, body: request.toJson());
      if (response is Success) {
        return await _apiService.getResponseStatus(
          response.value,
          (data) => VerifyLocationModel.fromJson(data),
        );
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Failed to fetch verify location data", e);
      return Error(DeserializationError());
    }
  }

  // String generateArea(GpsGeofenceModel model) {
  //   if (model.shapeType == "circle" &&
  //       model.center != null &&
  //       model.radius != null) {
  //     return "CIRCLE (${model.center!.latitude} ${model.center!.longitude}, ${model.radius})";
  //   }
  //
  //   if ((model.shapeType == "polygon" || model.shapeType == "polyline") &&
  //       model.polygonPoints != null &&
  //       model.polygonPoints!.isNotEmpty) {
  //     final coords = model.polygonPoints!
  //         .map((point) => "${point.latitude} ${point.longitude}")
  //         .join(", ");
  //     final shape = model.shapeType.toUpperCase(); // "POLYGON" or "POLYLINE"
  //     return "$shape (($coords))";
  //   }
  //
  //   throw Exception("Invalid geofence data for area generation");
  // }

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
}
