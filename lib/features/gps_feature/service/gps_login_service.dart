import 'package:dio/dio.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/helpers/map_helper.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';

import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_device_fuel_model.dart';
import '../model/gps_devices_expiry_model.dart';
import '../model/gps_devices_positions_model.dart';
import '../model/gps_login_model.dart';
import '../model/gps_mobile_config_model.dart';
import '../model/gps_user_config_model.dart';
import '../model/gps_user_configuration_model.dart';
import '../model/gps_user_details_model.dart';
import '../models/gps_geofence_model.dart';

class GpsLoginService {
  final ApiService _apiService;

  GpsLoginService(this._apiService);

  Future<Result<GpsLoginResponseModel>> login() async {
    try {
      CustomLog.info(this, "Starting GPS login...");
      final result = await _apiService.post(
        'https://api.letsgro.co/api/v1/auth/login',
        body: {
          "app_name": "gro fleet",
          "password": "Roadcast@123",
          "package_name": "app.gro.fleet",
          "device_type": "ANDROID",
          "username": "rishika",
        },
      );

      if (result is Success) {
        CustomLog.info(this, "Login API call successful");
        // GPS login API returns a simple object with token and refresh_token
        // No success/status field, so we parse directly
        try {
          CustomLog.info(this, "Parsing login response: ${result.value}");
          final loginData = GpsLoginResponseModel.fromJson(result.value);
          CustomLog.info(
            this,
            "Login data parsed successfully: token=${loginData.token?.substring(0, 20)}...",
          );
          return Success(loginData);
        } catch (e) {
          CustomLog.error(this, "Error parsing login response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "Login API call failed", null);
        return Error(result.type);
      } else {
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
        'https://api.letsgro.co/api/v1/auth/tc_users/163?__include=name&__include=attributes',
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
      final result = await _makeAuthenticatedRequest(
        'https://api.letsgro.co/api/v1/auth/device_fuel',
        'GET',
        token: token,
      );

      if (result is Success) {
        CustomLog.info(this, "Device fuel API call successful");
        try {
          final deviceFuel = GpsDeviceFuelModel.fromJson(result.value);
          return Success(deviceFuel);
        } catch (e) {
          CustomLog.error(this, "Error parsing device fuel response", e);
          return Error(DeserializationError());
        }
      } else if (result is Error) {
        CustomLog.error(this, "Device fuel API call failed", null);
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<GpsMobileConfigModel>> getMobileConfig(
    String token,
    int userId,
  ) async {
    try {
      CustomLog.info(this, "Getting mobile config...");
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
      CustomLog.info(this, "Getting user configuration...");
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

  // Helper method to make authenticated requests
  Future<Result<dynamic>> _makeAuthenticatedRequest(
    String url,
    String method, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    required String token,
  }) async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      };

      CustomLog.info(this, "Making $method request to: $url");

      Response response;
      if (method == 'GET') {
        response = await dio.get(
          url,
          queryParameters: queryParams,
          options: Options(headers: headers),
        );
      } else if (method == 'POST') {
        response = await dio.post(
          url,
          data: body,
          queryParameters: queryParams,
          options: Options(headers: headers),
        );
      } else {
        throw Exception('Unsupported HTTP method: $method');
      }

      CustomLog.info(
        this,
        "Request successful, status: ${response.statusCode}",
      );
      return Success(response.data);
    } on DioException catch (e) {
      CustomLog.error(this, "Error making authenticated request to $url", e);
      return Error(GenericError());
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

      // Step 2: Get user details
      CustomLog.info(this, "Step 2: Getting user details...");
      final userDetailsResult = await getUserDetails(authToken);
      if (userDetailsResult is Error) {
        CustomLog.error(this, "Failed to get user details", null);
        // Continue anyway as this is not critical
      } else {
        CustomLog.info(this, "User details retrieved successfully");
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
