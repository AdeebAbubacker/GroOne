import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_event_api_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';

import '../bloc/lp_home/lp_home_bloc.dart';
import '../repository/lp_home_repository.dart';

class EventHelper {
  static Future<CreateEventApiRequest> buildHomeViewEvent(
      {
        required String entity,
        required String subEntity,
        required String entityId,
        required String stage
      }) async {

    try {
      String customerUuid = "";
      final apiService = locator<ApiService>();
      final lpHomeBloc = locator<LpHomeBloc>();

      // Get device information
      final deviceInfoPlugin = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      final deviceIp = await apiService.getDeviceIp();
      
      String platform;
      String deviceId;
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        platform = "android";
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        platform = "ios";
        deviceId = iosInfo.identifierForVendor ?? "unknown";
      } else {
        platform = "unknown";
        deviceId = "unknown";
      }
      
      // Get customer UUID
      String? customerId = await lpHomeBloc.getUserId();
      print('event_helper_customerID $customerId');
      if (customerId!.isNotEmpty) {
        customerUuid = customerId;
      }
      
      return CreateEventApiRequest(
        customerUuid: customerUuid,
        entity: entity,
        subEntity: subEntity,
        entityId: entityId,
        stage: stage,
        context: const EventContext(viewd: "yes"),
        source: EventSource(
          platform: platform,
          appVersion: appVersion,
          deviceId: deviceId,
          ip: deviceIp,
        ),
      );
    } catch (e) {
      // Fallback with default values if anything fails
      return CreateEventApiRequest(
        customerUuid: "unknown",
        entity: "unknown",
        subEntity: "unknown",
        entityId: "",
        stage: "Exception",
        context: const EventContext(viewd: "yes"),
        source: const EventSource(
          platform: "unknown",
          appVersion: "unknown",
          deviceId: "unknown",
          ip: "unknown",
        ),
      );
    }
  }
}
