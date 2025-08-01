import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/service/gps_vehicle_extra_info_service.dart';
import 'package:gro_one_app/service/has_internet_connection.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../model/gps_info_window_details_model.dart';
import '../model/gps_vehicle_extra_info_mapper.dart';
import '../model/gps_vehicle_extra_info_model.dart';
import '../service/gps_realm_service.dart';

class GpsVehicleExtraInfoRepository {
  final GpsVehicleExtraInfoService _gpsVehicleExtraInfoService;
  final GpsRealmService _realmService;

  GpsVehicleExtraInfoRepository(
    this._gpsVehicleExtraInfoService,
    this._realmService,
  );

  Future<Result<List<GpsVehicleExtraInfo>>> getVehicleExtraInfo(
    String deviceId,
  ) async {
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }

      final result = await _gpsVehicleExtraInfoService.getVehicleExtraInfo(
        deviceId,
      );

      // If API call is successful, save to Realm
      if (result is Success<List<GpsVehicleExtraInfo>>) {
        try {
          final realmDataList = GpsVehicleExtraInfoMapper.toRealmList(
            result.value,
          );
          await _realmService.saveVehicleExtraInfo(realmDataList);
        } catch (e) {
          // Log error but don't fail the operation
          debugPrint("⚠️ Failed to save vehicle extra info to Realm: $e");
        }
      }

      return result;
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Multiple Share API for live location sharing
  Future<Result<String>> getMultipleShare({
    required String token,
    required String deviceId,
    required String validTill,
    required String vehicleName,
    required String category,
  }) async {
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }

      final result = await _gpsVehicleExtraInfoService.getMultipleShare(
        token: token,
        deviceId: deviceId,
        validTill: validTill,
        vehicleName: vehicleName,
        category: category,
      );
      return result;
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Update device extra info
  Future<Result<bool>> updateDeviceExtraInfo({
    required String token,
    required String deviceId,
    required Map<String, String> data,
  }) async {
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }

      final result = await _gpsVehicleExtraInfoService.updateDeviceExtraInfo(
        token: token,
        deviceId: deviceId,
        data: data,
      );
      return result;
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Get vehicle extra info from Realm (offline data)
  Future<Result<List<GpsVehicleExtraInfo>>>
  getVehicleExtraInfoFromRealm() async {
    try {
      final realmDataList = await _realmService.getAllVehicleExtraInfo();
      final domainList = GpsVehicleExtraInfoMapper.fromRealmList(realmDataList);
      return Success(domainList);
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Share vehicle location (live or current) - Business logic method
  Future<Result<String>> shareVehicleLocation({
    required String token,
    required int deviceId,
    required String vehicleNumber,
    required bool isLiveLocation,
    required int hours,
    required String location,
    required DateTime? lastUpdate,
  }) async {
    try {
      if (isLiveLocation) {
        return await _shareLiveLocation(
          token: token,
          deviceId: deviceId,
          vehicleNumber: vehicleNumber,
          hours: hours,
        );
      } else {
        return await _shareCurrentLocation(
          vehicleNumber: vehicleNumber,
          location: location,
          lastUpdate: lastUpdate,
        );
      }
    } catch (e) {
      CustomLog.error(this, "Error in share vehicle location", e);
      return Error(GenericError());
    }
  }

  /// Share live location - Business logic method
  Future<Result<String>> _shareLiveLocation({
    required String token,
    required int deviceId,
    required String vehicleNumber,
    required int hours,
  }) async {
    try {
      CustomLog.info(this, "Starting Live Location Share...");

      // Calculate valid till timestamp
      final DateTime now = DateTime.now();
      final DateTime validTill = now.add(Duration(hours: hours));
      final String validTillString = DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
      ).format(validTill);

      // Get device category
      final String deviceCategory = await _getDeviceCategory(deviceId);

      // Call the API service
      final result = await getMultipleShare(
        token: token,
        deviceId: deviceId.toString(),
        validTill: validTillString,
        vehicleName: vehicleNumber,
        category: deviceCategory,
      );

      if (result is Success<String>) {
        final String token = result.value;
        final String shareText = _generateLiveShareLink(token);
        SharePlus.instance.share(
          ShareParams(text: shareText, subject: 'Vehicle Live Location'),
        );
        return Success("Live location shared successfully");
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, "Error in live location sharing", e);
      return Error(GenericError());
    }
  }

  /// Share current location - Business logic method
  Future<Result<String>> _shareCurrentLocation({
    required String vehicleNumber,
    required String location,
    required DateTime? lastUpdate,
  }) async {
    try {
      CustomLog.info(this, "Starting Current Location Share...");

      if (!_hasValidLatLng(location)) {
        return Error(GenericError());
      }

      final String cleanLocation = location.replaceAll(' ', '');

      final String formattedDate = _formatDateTime(lastUpdate);
      final String shareText = '''
Vehicle Name - $vehicleNumber
Location - $location
Date - $formattedDate
Map - https://www.google.com/maps/search/?api=1&query=$cleanLocation
Sent via gro fleet
''';

      SharePlus.instance.share(
        ShareParams(text: shareText, subject: 'Vehicle Location'),
      );
      return Success("Current location shared successfully");
    } catch (e) {
      CustomLog.error(this, "Error in current location sharing", e);
      return Error(GenericError());
    }
  }

  /// Update device speed limit - Business logic method
  Future<Result<bool>> updateSpeedLimit({
    required String token,
    required int deviceId,
    required bool enabled,
    required String speed,
  }) async {
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }

      final result = await _gpsVehicleExtraInfoService.updateSpeedLimit(
        token: token,
        deviceId: deviceId,
        enabled: enabled,
        speed: speed,
      );
      return result;
    } catch (e) {
      return Error(GenericError());
    }
  }

  /// Check if location string contains valid lat/lng coordinates - Utility method
  bool _hasValidLatLng(String location) {
    if (location.isEmpty) {
      return false;
    }

    final String cleanLocation =
        location.replaceAll(' ', '').toLowerCase().trim();

    if (cleanLocation == 'locationnotavailable' ||
        cleanLocation == 'nolocation' ||
        cleanLocation == 'n/a' ||
        cleanLocation == 'unknown' ||
        cleanLocation == 'notavailable') {
      return false;
    }
    return true;
  }

  /// Generate live share link - Utility method
  String _generateLiveShareLink(String token) {
    const String whiteLabelUrl = "https://track.letsgro.co";
    return "$whiteLabelUrl/v1/auth/live?token=$token";
  }

  /// Format date time - Utility method
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
  }

  /// Get device category - Utility method
  Future<String> _getDeviceCategory(int deviceId) async {
    try {
      return 'vehicle';
    } catch (e) {
      CustomLog.error(this, "Failed to get device category: $e", e);
      return 'vehicle'; // Default fallback
    }
  }

  /// Get info window details for a specific device
  Future<Result<GpsInfoWindowDetails>> getInfoWindowDetails({
    required String token,
    required String deviceId,
  }) async {
    try {
      if (!HasInternetConnection.isInternet) {
        return Error(InternetNetworkError());
      }

      final result = await _gpsVehicleExtraInfoService.getInfoWindowDetails(
        token: token,
        deviceId: deviceId,
      );

      return result;
    } catch (e) {
      CustomLog.error(this, "Error getting info window details", e);
      return Error(GenericError());
    }
  }
}
