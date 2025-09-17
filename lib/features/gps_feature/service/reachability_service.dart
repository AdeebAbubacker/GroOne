import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/custom_log.dart';
import '../models/reachability_model.dart';

class ReachabilityService {
  final ApiService _apiService;

  ReachabilityService(this._apiService);

  /// Create a reachability configuration
  Future<Result<ReachabilityConfig>> createReachabilityConfig(
    ReachabilityConfig config,
  ) async {
    try {
      CustomLog.info(this, "Creating reachability configuration");

      // Build request body matching the native Android app format
      final body = <String, dynamic>{'device_id': int.parse(config.vehicleId)};

      if (config.locationMethod == LocationMethod.newLocation) {
        body['lat'] = config.latitude;
        body['lng'] = config.longitude;
        body['radius'] = config.radius?.toString();
      } else {
        body['geofence_id'] = int.parse(config.geofenceId ?? '0');
        body['geofence_name'] = config.geofenceName;
        body['lat'] = config.latitude;
        body['lng'] = config.longitude;
        body['radius'] = config.radius?.toString();
      }

      // Add date/time in UTC format (matching native app)
      if (config.selectedDate != null) {
        final startDateTime =
            '${config.selectedDate!.toIso8601String().split('T')[0]} ${config.selectedTime?.toIso8601String().split('T')[1].split('.')[0] ?? '00:00:00'}';
        body['start_datetime_utc'] = startDateTime;
      }

      if (config.selectedDate != null) {
        final endDateTime =
            '${config.selectedDate!.toIso8601String().split('T')[0]} ${config.selectedTime?.toIso8601String().split('T')[1].split('.')[0] ?? '23:59:59'}';
        body['end_datetime_utc'] = endDateTime;
      }

      // Add notification configs (matching native app format)
      body['notification_configs'] =
          config.notificationMethods.map((e) => e.name).toList();

      CustomLog.info(this, "Creating reachability config with body: $body");

      final response = await _apiService.post(
        ApiUrls.gpsCreateReachability,
        body: body,
      );

      if (response is Success) {
        CustomLog.info(this, "Reachability configuration created successfully");
        return Success(config);
      } else {
        final errorType = response is Error ? response.type : GenericError();
        CustomLog.error(
          this,
          "Failed to create reachability configuration. Error: ${errorType.toString()}",
          null,
        );
        return Error(errorType);
      }
    } catch (e) {
      CustomLog.error(this, "Exception creating reachability configuration", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get notification configurations (matching native app)
  Future<Result<List<Map<String, dynamic>>>> getNotificationConfigs() async {
    try {
      CustomLog.info(this, "Fetching notification configurations");

      final response = await _apiService.get(ApiUrls.gpsGetNotificationConfigs);

      if (response is Success) {
        final data = response.value['data'] as List<dynamic>? ?? [];
        final configs = data.map((e) => e as Map<String, dynamic>).toList();

        CustomLog.info(
          this,
          "Fetched ${configs.length} notification configurations",
        );
        return Success(configs);
      } else {
        CustomLog.error(
          this,
          "Failed to fetch notification configurations",
          null,
        );
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(
        this,
        "Exception fetching notification configurations",
        e,
      );
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get reachability configurations for a vehicle
  Future<Result<List<ReachabilityConfig>>> getReachabilityConfigs(
    String vehicleId,
  ) async {
    try {
      CustomLog.info(
        this,
        "Fetching reachability configurations for vehicle: $vehicleId",
      );

      final response = await _apiService.get(
        ApiUrls.gpsGetReachabilityConfigs(vehicleId),
      );

      if (response is Success) {
        final data = response.value['data'] as List<dynamic>? ?? [];
        final configs =
            data
                .map(
                  (e) => ReachabilityConfig.fromJson(e as Map<String, dynamic>),
                )
                .toList();

        CustomLog.info(
          this,
          "Fetched ${configs.length} reachability configurations",
        );
        return Success(configs);
      } else {
        CustomLog.error(
          this,
          "Failed to fetch reachability configurations",
          null,
        );
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(
        this,
        "Exception fetching reachability configurations",
        e,
      );
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Update a reachability configuration
  Future<Result<ReachabilityConfig>> updateReachabilityConfig(
    ReachabilityConfig config,
  ) async {
    try {
      CustomLog.info(this, "Updating reachability configuration: ${config.id}");

      final body = {
        'id': config.id,
        'vehicle_id': config.vehicleId,
        'vehicle_number': config.vehicleNumber,
        'location_method': config.locationMethod.name,
        'location_address': config.locationAddress,
        'latitude': config.latitude,
        'longitude': config.longitude,
        'radius': config.radius,
        'geofence_id': config.geofenceId,
        'geofence_name': config.geofenceName,
        'selected_date': config.selectedDate?.toIso8601String(),
        'selected_time': config.selectedTime?.toIso8601String(),
        'notification_methods':
            config.notificationMethods.map((e) => e.name).toList(),
        'status': config.status,
      };

      final response = await _apiService.put(
        ApiUrls.gpsUpdateReachabilityConfig(config.id),
        body: body,
      );

      if (response is Success) {
        CustomLog.info(this, "Reachability configuration updated successfully");
        return Success(config);
      } else {
        CustomLog.error(
          this,
          "Failed to update reachability configuration",
          null,
        );
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Exception updating reachability configuration", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Delete a reachability configuration
  Future<Result<void>> deleteReachabilityConfig(String configId) async {
    try {
      CustomLog.info(this, "Deleting reachability configuration: $configId");

      final response = await _apiService.delete(
        ApiUrls.gpsDeleteReachabilityConfig(configId),
      );

      if (response is Success) {
        CustomLog.info(this, "Reachability configuration deleted successfully");
        return Success(null);
      } else {
        CustomLog.error(
          this,
          "Failed to delete reachability configuration",
          null,
        );
        return Error(response is Error ? response.type : GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Exception deleting reachability configuration", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }
}
