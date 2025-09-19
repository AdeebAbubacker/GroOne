import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../../../data/network/api_urls.dart';
import '../../../utils/custom_log.dart';
import '../../login/repository/user_information_repository.dart';
import '../models/reachability_model.dart';

class ReachabilityService {
  final ApiService _apiService;
  final UserInformationRepository _userInformationRepository;

  ReachabilityService(this._apiService, this._userInformationRepository);

  /// Create a reachability configuration
  Future<Result<ReachabilityConfig>> createReachabilityConfig(
    ReachabilityConfig config,
  ) async {
    try {
      CustomLog.info(this, "Creating reachability configuration");

      // Get GPS token for authentication
      final gpsToken = await _userInformationRepository.getGpsToken();
      if (gpsToken == null || gpsToken.isEmpty) {
        CustomLog.error(this, "No GPS token found for reachability API", null);
        return Error(
          UnauthenticatedError(message: "GPS authentication required"),
        );
      }

      CustomLog.info(this, "Using GPS token: ${gpsToken.substring(0, 20)}...");

      // Build request body matching the standard API format exactly
      final body = <String, dynamic>{'device_id': int.parse(config.vehicleId)};

      if (config.locationMethod == LocationMethod.newLocation) {
        body['lng'] = config.longitude; // Put lng before lat to match standard
        body['lat'] = config.latitude;
        body['radius'] = config.radius?.toInt() ?? 0;
      } else {
        body['geofence_id'] = int.parse(config.geofenceId ?? '0');
        body['lng'] = config.longitude; // Put lng before lat to match standard
        body['geofence_name'] = config.geofenceName;
        body['lat'] = config.latitude;
        body['radius'] = config.radius?.toInt() ?? 0;
      }

      // Add date/time in proper ISO 8601 UTC format
      if (config.selectedDate != null) {
        final startDate = config.selectedDate!;
        final startTime = config.selectedTime ?? DateTime(1970, 1, 1, 0, 0, 0);
        final startDateTime = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          startTime.hour,
          startTime.minute,
          startTime.second,
        );
        body['start_datetime_utc'] = startDateTime.toUtc().toIso8601String();

        // For end time, use the same time as start time + 1 hour if no specific end time is set
        final endDateTime = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          startTime.hour + 1, // Add 1 hour to start time
          startTime.minute,
          startTime.second,
        );
        body['end_datetime_utc'] = endDateTime.toUtc().toIso8601String();

        // Log datetime for debugging
        CustomLog.info(this, "Start datetime: ${body['start_datetime_utc']}");
        CustomLog.info(this, "End datetime: ${body['end_datetime_utc']}");
      }

      // Add notification configs as array of integers (matching standard format)
      // Convert notification method names to their corresponding integer IDs
      body['notification_configs'] =
          config.notificationMethods
              .map((method) => _getNotificationConfigId(method))
              .toList();

      CustomLog.info(this, "Creating reachability config with body: $body");

      // Log the exact request format for debugging
      CustomLog.info(this, "Request format check:");
      CustomLog.info(
        this,
        "device_id: ${body['device_id']} (type: ${body['device_id'].runtimeType})",
      );
      CustomLog.info(
        this,
        "geofence_id: ${body['geofence_id']} (type: ${body['geofence_id'].runtimeType})",
      );
      CustomLog.info(
        this,
        "lat: ${body['lat']} (type: ${body['lat'].runtimeType})",
      );
      CustomLog.info(
        this,
        "lng: ${body['lng']} (type: ${body['lng'].runtimeType})",
      );
      CustomLog.info(
        this,
        "radius: ${body['radius']} (type: ${body['radius'].runtimeType})",
      );
      CustomLog.info(
        this,
        "notification_configs: ${body['notification_configs']} (type: ${body['notification_configs'].runtimeType})",
      );

      // Use GPS token for authentication (following GPS service pattern)
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
            gpsToken.startsWith('Bearer ') ? gpsToken : 'Bearer $gpsToken',
      };

      final response = await _apiService.post(
        ApiUrls.gpsCreateReachability,
        body: body,
        customHeaders: headers,
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

        // Log the full error details for debugging
        if (response is Error) {
          CustomLog.error(
            this,
            "Full error details: ${response.toString()}",
            null,
          );

          // Log the error type and message
          CustomLog.error(
            this,
            "Error type: ${response.type.runtimeType}",
            null,
          );

          if (response.type is ErrorWithMessage) {
            final errorWithMessage = response.type as ErrorWithMessage;
            CustomLog.error(
              this,
              "Error message: ${errorWithMessage.message}",
              null,
            );
          }
        }

        return Error(errorType);
      }
    } catch (e) {
      CustomLog.error(this, "Exception creating reachability configuration", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  /// Get notification config ID for the given notification method
  /// This maps notification methods to their corresponding integer IDs
  int _getNotificationConfigId(NotificationMethod method) {
    switch (method) {
      case NotificationMethod.email:
        return 177; // Email notification ID
      case NotificationMethod.sms:
        return 178; // SMS notification ID
      case NotificationMethod.push:
        return 177; // Use email ID for push (based on working standard)
      case NotificationMethod.web:
        return 177; // Use email ID for web (based on working standard)
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
