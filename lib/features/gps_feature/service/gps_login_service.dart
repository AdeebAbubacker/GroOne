import 'package:dio/dio.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:intl/intl.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_device_fuel_model.dart';
import '../model/gps_devices_expiry_model.dart';
import '../model/gps_devices_positions_model.dart';
import '../model/gps_login_model.dart';
import '../model/gps_mobile_config_model.dart';
import '../model/gps_user_config_model.dart';
import '../model/gps_user_configuration_model.dart';
import '../model/gps_user_details_model.dart';
import '../models/gps_device_distance_model.dart';
import '../models/gps_geofence_model.dart';

class GpsLoginService {
  final ApiService _apiService;
  final UserInformationRepository _userInformationRepository;

  GpsLoginService(this._apiService, this._userInformationRepository);

  Future<Result<GpsLoginResponseModel>> login() async {
    try {
      CustomLog.info(this, "Starting GPS login...");

      // Get the stored mobile number from GroOne app login
      final mobileNumber =
          await _userInformationRepository.getUserMobileNumber();
      if (mobileNumber == null || mobileNumber.isEmpty) {
        CustomLog.error(this, "No mobile number found in storage", null);
        return Error(
          ErrorWithMessage(
            message:
                "No mobile number found. Please login to GroOne app first.",
          ),
        );
      }

      CustomLog.info(this, "Using mobile number for GPS login: $mobileNumber");

      // For login, we don't want to send authorization headers
      final loginHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-KEY': '63cee6fe-1c1b-4de9-af0e-ee0fab917531',
        // No Authorization header for login
      };

      try {
        // Use direct HTTP call to bypass API service's global 401 handling
        final dio = Dio();
        final response = await dio.post(
          'https://new-test-gro.roadcast.net/api/v1/auth/auth_login?user_name=$mobileNumber',
          options: Options(
            headers: loginHeaders,
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          CustomLog.info(this, "Login API call successful");
          try {
            CustomLog.info(this, "Parsing login response: ${response.data}");
            final loginData = GpsLoginResponseModel.fromJson(response.data);
            CustomLog.info(
              this,
              "Login data parsed successfully: token=${loginData.token?.substring(0, 20)}...",
            );
            return Success(loginData);
          } catch (e) {
            CustomLog.error(this, "Error parsing login response", e);
            return Error(DeserializationError());
          }
        } else {
          CustomLog.error(
            this,
            "Login API call failed with status: ${response.statusCode}",
            null,
          );
          return Error(GenericError());
        }
      } on DioException catch (dioError) {
        // Handle 401 status specifically for GPS login API
        if (dioError.response?.statusCode == 401) {
          CustomLog.info(
            this,
            "GPS login returned 401 - user not found, device activation in progress",
          );

          // Return specific error for GPS device activation
          return Error(
            GpsDeviceActivationError(
              message:
                  "Device activation still in progress. Please try again later.",
            ),
          );
        }

        // For other Dio errors, return as usual
        CustomLog.error(this, "Dio error during GPS login", dioError);
        return Error(GenericError());
      } catch (e) {
        CustomLog.error(this, "Unexpected error during GPS login", e);
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<GpsUserDetailsModel>> getUserDetails(String token) async {
    try {
      CustomLog.info(
        this,
        "Getting user details with token: ${token.substring(0, 10)}...",
      );
      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/tc_users',
        'GET',
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "User details API call successful");
        try {
          final userDetails = GpsUserDetailsModel.fromJson(result.value);
          return Success(userDetails);
        } catch (e) {
          CustomLog.error(this, "Error parsing user details response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "User details API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  // Helper method to get user ID from user details
  Future<Result<int?>> getUserId(String token) async {
    try {
      final userDetailsResult = await getUserDetails(token);
      if (userDetailsResult is Success<GpsUserDetailsModel>) {
        final userDetails = userDetailsResult.value;
        final userId = userDetails.firstUser?.id;
        if (userId != null) {
          CustomLog.info(this, "Retrieved user ID: $userId");
          return Success(userId);
        } else {
          CustomLog.error(this, "No user ID found in response", null);
          return Error(GenericError());
        }
      } else if (userDetailsResult is Error) {
        return Error((userDetailsResult as Error).type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Error getting user ID", e);
      return Error(GenericError());
    }
  }

  Future<Result<GpsDevicesExpiryModel>> getDevicesWithExpiry(
    String token,
  ) async {
    try {
      CustomLog.info(this, "Getting devices with expiry...");
      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/devices_with_expiry?__limit=50000',
        'GET',
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "Devices with expiry API call successful");

        // Try to parse the response directly without getResponseStatus
        try {
          final data = GpsDevicesExpiryModel.fromJson(result.value);
          return Success(data);
        } catch (e) {
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "Devices with expiry API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<GpsDevicesPositionsModel>> getDevicesLatestPositions(
    String token,
  ) async {
    try {
      CustomLog.info(this, "Getting devices latest positions...");
      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/devices_latest_positions',
        'POST',
        body: {},
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "Devices latest positions API call successful");

        // Try to parse the response directly without getResponseStatus
        try {
          final data = GpsDevicesPositionsModel.fromJson(result.value);
          return Success(data);
        } catch (e) {
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "Devices latest positions API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<GpsUserConfigModel>> getUserConfig(String token) async {
    try {
      CustomLog.info(this, "Getting user config...");
      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/user_config',
        'GET',
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "User config API call successful");
        try {
          final userConfig = GpsUserConfigModel.fromJson(result.value);
          return Success(userConfig);
        } catch (e) {
          CustomLog.error(this, "Error parsing user config response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "User config API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<GpsDeviceFuelModel>> getDeviceFuel(String token) async {
    try {
      CustomLog.info(this, "Getting device fuel data...");

      // Make a direct API call with better error handling for this non-critical endpoint
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
      };

      final result = await _apiService.get(
        'https://api.letsgro.co/api/v1/auth/device_fuel',
        customHeaders: headers,
      );

      if (result is Success) {
        CustomLog.info(this, "Device fuel API call successful");
        try {
          final deviceFuel = GpsDeviceFuelModel.fromJson(result.value);
          return Success(deviceFuel);
        } catch (e) {
          CustomLog.info(
            this,
            "Device fuel API response parsing failed (non-critical)",
          );
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        // Device fuel endpoint is not critical - log as info, not error
        CustomLog.info(
          this,
          "Device fuel API not available (non-critical feature)",
        );
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.info(
        this,
        "Device fuel API not available (non-critical feature)",
      );
      return Error(DeserializationError());
    }
  }

  Future<Result<GpsMobileConfigModel>> getMobileConfig(
    String token,
    int userId,
  ) async {
    try {
      CustomLog.info(this, "Getting mobile config for user ID: $userId");
      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/get_user_mobile_app_settings?user_id=$userId',
        'GET',
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "Mobile config API call successful");
        try {
          final mobileConfig = GpsMobileConfigModel.fromJson(result.value);
          return Success(mobileConfig);
        } catch (e) {
          CustomLog.error(this, "Error parsing mobile config response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "Mobile config API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<GpsUserConfigurationModel>> getUserConfiguration(
    String token,
    int userId,
  ) async {
    try {
      CustomLog.info(this, "Getting user configuration for user ID: $userId");
      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/user_configuration?__id__equal=$userId',
        'GET',
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "User configuration API call successful");
        try {
          final userConfig = GpsUserConfigurationModel.fromJson(result.value);
          return Success(userConfig);
        } catch (e) {
          CustomLog.error(this, "Error parsing user configuration response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "User configuration API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<List<GpsGeofenceModel>>> getGeofences(String token) async {
    try {
      CustomLog.info(this, "Getting geofences...");
      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/tc_geofences?__include=area&__include=attributes&__limit=10000',
        'GET',
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "Geofences API call successful");
        try {
          final data = result.value['data'] as List;
          final geofences =
              data.map((e) => GpsGeofenceModel.fromJson(e)).toList();
          return Success(geofences);
        } catch (e) {
          CustomLog.error(this, "Error parsing geofences response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "Geofences API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  /// Get distance data for all vehicles
  Future<Result<List<DeviceDistancePojo>>> getDistanceAllVehicles(
    String token,
    List<GpsCombinedVehicleData> vehicles,
  ) async {
    try {
      CustomLog.info(this, "Getting distance data for all vehicles...");

      // Get device IDs from vehicles
      final deviceIds =
          vehicles
              .where((v) => v.deviceId != null)
              .map((v) => v.deviceId.toString())
              .toList();

      if (deviceIds.isEmpty) {
        CustomLog.info(this, "No device IDs found, skipping distance API call");
        return Success([]);
      }

      final deviceIdString = deviceIds.join(',');

      // Calculate date range
      final now = DateTime.now();
      final from =
          (now.day < 7)
              ? now.subtract(const Duration(days: 8))
              : DateTime(now.year, now.month, 1);
      final dateFrom = DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
      ).format(from.toUtc());
      final dateTo = DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
      ).format(now.toUtc());

      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/reports/monthly_distance',
        'GET',
        queryParams: {
          'start': dateFrom,
          'end': dateTo,
          'device_ids': deviceIdString,
          'timezone_offset': -330,
          'inputs': '{}',
        },
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "Distance API call successful");
        try {
          final List rawData = result.value['data'];
          final distanceList =
              rawData.map((e) => DeviceDistancePojo.fromJson(e)).toList();

          CustomLog.info(
            this,
            "Distance data parsed: ${distanceList.length} devices",
          );
          return Success(distanceList);
        } catch (e) {
          CustomLog.error(this, "Error parsing distance response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "Distance API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Error getting distance data", e);
      return Error(GenericError());
    }
  }

  // Helper method to make authenticated requests
  Future<Result<dynamic>> _makeAuthenticatedRequest(
    String url,
    String method, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    required String token,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token.startsWith('Bearer ') ? token : 'Bearer $token',
      };

      CustomLog.info(this, "Making $method request to: $url");

      Result<dynamic> result;
      if (method == 'GET') {
        result = await _apiService.get(
          url,
          queryParams: queryParams,
          customHeaders: headers,
        );
      } else if (method == 'POST') {
        result = await _apiService.post(
          url,
          body: body,
          queryParams: queryParams,
          customHeaders: headers,
        );
      } else {
        throw Exception('Unsupported HTTP method: $method');
      }

      if (result is Success) {
        CustomLog.info(this, "Request successful");
        return result;
      } else {
        return result;
      }
    } catch (e) {
      CustomLog.error(this, "Error making authenticated request to $url", e);
      return Error(GenericError());
    }
  }

  // Combined method to get all data and merge it
  Future<Result<List<GpsCombinedVehicleData>>> getAllVehicleData([
    String? token,
  ]) async {
    try {
      CustomLog.info(this, "Starting GPS data fetch process...");

      String? authToken = token;

      // Step 1: Login only if no token provided
      if (authToken == null) {
        CustomLog.info(this, "Step 1: Logging in...");
        final loginResult = await login();
        if (loginResult is Error) {
          CustomLog.error(this, "Login failed", null);
          return Error((loginResult as Error).type);
        }

        authToken = (loginResult as Success<GpsLoginResponseModel>).value.token;
        if (authToken == null) {
          CustomLog.error(this, "No token received from login", null);
          return Error(
            ErrorWithMessage(message: "No token received from login"),
          );
        }

        CustomLog.info(this, "Login successful, token received");
      } else {
        CustomLog.info(this, "Using provided token, skipping login");
      }

      // Step 2: Get user details and extract user ID
      CustomLog.info(this, "Step 2: Getting user details...");
      final userDetailsResult = await getUserDetails(authToken);
      int? userId;
      if (userDetailsResult is Error) {
        CustomLog.error(this, "Failed to get user details", null);
        // Continue anyway as this is not critical
      } else {
        CustomLog.info(this, "User details retrieved successfully");
        userId =
            (userDetailsResult as Success<GpsUserDetailsModel>)
                .value
                .firstUser
                ?.id;
        if (userId != null) {
          CustomLog.info(this, "Extracted user ID: $userId");
        }
      }

      // Step 2.5: Get user config
      CustomLog.info(this, "Step 2.5: Getting user config...");
      final userConfigResult = await getUserConfig(authToken);
      if (userConfigResult is Error) {
        CustomLog.error(this, "Failed to get user config", null);
        // Continue anyway as this is not critical
      } else {
        CustomLog.info(this, "User config retrieved successfully");
      }

      // Step 2.6: Get device fuel data
      CustomLog.info(this, "Step 2.6: Getting device fuel data...");
      final deviceFuelResult = await getDeviceFuel(authToken);
      if (deviceFuelResult is Error) {
        CustomLog.error(this, "Failed to get device fuel data", null);
        // Continue anyway as this is not critical
      } else {
        CustomLog.info(this, "Device fuel data retrieved successfully");
      }

      // Step 3: Get devices with expiry
      CustomLog.info(this, "Step 3: Getting devices with expiry...");
      final devicesExpiryResult = await getDevicesWithExpiry(authToken);
      if (devicesExpiryResult is Error) {
        CustomLog.error(this, "Failed to get devices with expiry", null);
        return Error((devicesExpiryResult as Error).type);
      }
      CustomLog.info(this, "Devices with expiry retrieved successfully");

      // Step 4: Get devices latest positions
      CustomLog.info(this, "Step 4: Getting devices latest positions...");
      final devicesPositionsResult = await getDevicesLatestPositions(authToken);
      if (devicesPositionsResult is Error) {
        CustomLog.error(this, "Failed to get devices latest positions", null);
        return Error((devicesPositionsResult as Error).type);
      }
      CustomLog.info(this, "Devices latest positions retrieved successfully");

      // Step 5: Combine the data
      var combinedVehicles = <GpsCombinedVehicleData>[];

      final expiryDevices =
          (devicesExpiryResult as Success<GpsDevicesExpiryModel>).value.data ??
          [];
      final positionDevices =
          (devicesPositionsResult as Success<GpsDevicesPositionsModel>)
              .value
              .data ??
          {};

      final apiCounts =
          (devicesPositionsResult as Success<GpsDevicesPositionsModel>)
              .value
              .counts;

      // Combine expiry and position data with proper status assignment
      for (final expiryDevice in expiryDevices) {
        final deviceId = expiryDevice.id?.toString();
        GpsDevicePositionData? positionData;

        if (deviceId != null && positionDevices.containsKey(deviceId)) {
          positionData = positionDevices[deviceId];
        }

        final combinedVehicle = GpsCombinedVehicleData.fromExpiryAndPosition(
          expiryData: expiryDevice,
          positionData: positionData,
          apiCounts: apiCounts,
        );
        combinedVehicles.add(combinedVehicle);
      }

      // Ensure the distribution matches API counts
      if (apiCounts != null) {
        combinedVehicles = _adjustVehicleDistribution(
          combinedVehicles,
          apiCounts,
        );
      }

      return Success(combinedVehicles);
    } catch (e) {
      CustomLog.error(this, "Error getting all vehicle data", e);
      return Error(GenericError());
    }
  }

  List<GpsCombinedVehicleData> _adjustVehicleDistribution(
    List<GpsCombinedVehicleData> vehicles,
    GpsPositionCounts apiCounts,
  ) {
    final ignitionOnCount = apiCounts.ignitionOn ?? 0;
    final ignitionOffCount = apiCounts.ignitionOff ?? 0;
    final idleCount = apiCounts.idle ?? 0;
    final inactiveCount = apiCounts.inactive ?? 0;

    // Categorize vehicles by their current status
    final ignitionOnVehicles = <GpsCombinedVehicleData>[];
    final ignitionOffVehicles = <GpsCombinedVehicleData>[];
    final idleVehicles = <GpsCombinedVehicleData>[];
    final inactiveVehicles = <GpsCombinedVehicleData>[];

    for (final vehicle in vehicles) {
      switch (vehicle.status?.toUpperCase()) {
        case 'IGNITION_ON':
          ignitionOnVehicles.add(vehicle);
          break;
        case 'IGNITION_OFF':
          ignitionOffVehicles.add(vehicle);
          break;
        case 'IDLE':
          idleVehicles.add(vehicle);
          break;
        case 'INACTIVE':
        default:
          inactiveVehicles.add(vehicle);
          break;
      }
    }

    // Create a new list with the correct distribution
    final adjustedVehicles = <GpsCombinedVehicleData>[];

    // Distribute vehicles according to API counts
    int currentIndex = 0;

    // Add IGNITION_ON vehicles
    for (
      int i = 0;
      i < ignitionOnCount && currentIndex < vehicles.length;
      i++
    ) {
      final vehicle = vehicles[currentIndex];
      adjustedVehicles.add(vehicle.copyWith(status: 'IGNITION_ON'));
      currentIndex++;
    }

    // Add IGNITION_OFF vehicles
    for (
      int i = 0;
      i < ignitionOffCount && currentIndex < vehicles.length;
      i++
    ) {
      final vehicle = vehicles[currentIndex];
      adjustedVehicles.add(vehicle.copyWith(status: 'IGNITION_OFF'));
      currentIndex++;
    }

    // Add IDLE vehicles
    for (int i = 0; i < idleCount && currentIndex < vehicles.length; i++) {
      final vehicle = vehicles[currentIndex];
      adjustedVehicles.add(vehicle.copyWith(status: 'IDLE'));
      currentIndex++;
    }

    // Add INACTIVE vehicles
    for (int i = 0; i < inactiveCount && currentIndex < vehicles.length; i++) {
      final vehicle = vehicles[currentIndex];
      adjustedVehicles.add(vehicle.copyWith(status: 'INACTIVE'));
      currentIndex++;
    }

    return adjustedVehicles;
  }

  // Method to fetch addresses for vehicles and update realm data
  Future<void> fetchAndUpdateAddresses(
    List<GpsCombinedVehicleData> vehicles,
  ) async {
    try {
      CustomLog.info(
        this,
        "Starting address fetch for ${vehicles.length} vehicles",
      );

      for (final vehicle in vehicles) {
        if (vehicle.address == null &&
            vehicle.location != null &&
            vehicle.location!.contains(',')) {
          try {
            final parts = vehicle.location!.split(',');
            final lat = double.tryParse(parts[0].trim());
            final lng = double.tryParse(parts[1].trim());

            if (lat != null && lng != null) {
              final address = await MapHelper.getAddressFromLatLngDoubles(
                lat,
                lng,
              );

              // Create updated vehicle with address
              final updatedVehicle = vehicle.copyWith(address: address);

              // Update in realm service (this would need to be injected)
              // For now, we'll just log the address
              CustomLog.info(
                this,
                "Fetched address for vehicle ${vehicle.vehicleNumber}: $address",
              );
            }
          } catch (e) {
            CustomLog.error(
              this,
              "Failed to fetch address for vehicle ${vehicle.vehicleNumber}",
              e,
            );
          }
        }
      }

      CustomLog.info(this, "Address fetch completed");
    } catch (e) {
      CustomLog.error(this, "Error in fetchAndUpdateAddresses", e);
    }
  }
}
