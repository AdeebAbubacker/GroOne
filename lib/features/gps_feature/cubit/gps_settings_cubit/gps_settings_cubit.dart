import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../data/model/result.dart';
import '../../helper/gps_session_manager.dart';
import '../../repository/gps_repository.dart';
import 'gps_settings_state.dart';

class GpsSettingsCubit extends Cubit<GpsSettingsState> {
  final GpsRepository _repository;

  GpsSettingsCubit(this._repository) : super(GpsSettingsInitial());


  Future<void> toggleNotification(bool isEnabled) async {
    emit(GpsSettingsLoading());

    String? deviceToken = "";
    try {
      deviceToken = isEnabled ? await FirebaseMessaging.instance.getToken() : "";
    } catch (e) {
    }

    Map<String, dynamic>? deviceDetails;
    String? deviceType;

    if (isEnabled) {
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      final deviceInfoPlugin = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceDetails = {
          "deviceType": "ANDROID",
          "app_version": appVersion,
          "androidVersion": androidInfo.version.release,
          "model": androidInfo.model,
          "sdk": androidInfo.version.sdkInt,
          "manufacturer": androidInfo.manufacturer,
        };
        deviceType = "ANDROID";
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceDetails = {
          "deviceType": "IOS",
          "app_version": appVersion,
          "iosVersion": iosInfo.systemVersion,
          "model": iosInfo.utsname.machine,
          "name": iosInfo.name,
          "systemName": iosInfo.systemName,
        };
        deviceType = "IOS";
      }
    }

    final result = await _repository.updateNotificationToggle(
      deviceToken: deviceToken ?? '',
      deviceDetails: deviceDetails,
      deviceType: deviceType,
    );

    if (result is Success) {
      await GpsSessionManager.setNotificationEnabled(isEnabled);
      emit(GpsSettingsSuccess(isEnabled));
    } else if (result is Error) {
      emit(GpsSettingsError(result.type.toString()));
    } else {
      emit(GpsSettingsError("Unknown error occurred"));
    }
  }



}
