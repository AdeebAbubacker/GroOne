import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/login/api_request/notification_request_model.dart';
import 'package:gro_one_app/service/pushNotification/notification_service.dart';
import 'package:gro_one_app/utils/safe_api_caller.dart';

import '../../../data/model/result.dart';
import '../api_request/login_in_api_request.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginInRepository _repository;
  final securedSharedPreference = locator<SecuredSharedPreferences>();

  LoginBloc(this._repository) : super(const LoginState()) {
    on<LoginInRequested>((event, emit) async {
      emit(LogInLoading());

      try {
        // Use safe API caller with retry for login
        final result = await SafeApiCaller.callWithRetryAndTimeout(
          () => _repository.requestLogin(event.apiRequest),
          operationName: 'login_request',
          maxRetries: 2,
          timeout: const Duration(seconds: 20),
        );

        if (result != null) {
          if (result is Success<LoginApiResponseModel>) {
            emit(LogInSuccess(result.value));
          } else if (result is Error<LoginApiResponseModel>) {
            emit(LogInError(result.type));
          } else {
            emit(LogInError(GenericError()));
          }
        } else {
          emit(LogInError(GenericError()));
        }
      } catch (e) {
        debugPrint('❌ Login error: $e');
        emit(LogInError(GenericError()));
      }
    });

    on<ChangeIndex>(_onChangeIndex);
    on<SaveDeviceToken>((event, emit) => _saveDeviceToken(event.userId));
  }

  _onChangeIndex(ChangeIndex event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.isSuccess, counter: event.index));
  }

  _saveDeviceToken(String? userId) async {
    try {
      String? fcmToken = NotificationService.deviceToken;
      debugPrint("fcmToken is $fcmToken");
      String? deviceId = (await getDeviceInfo()).$2;
      String? deviceType = (await getDeviceInfo()).$1;
      NotificationRequestModel notificationRequestModel =
          NotificationRequestModel(
            customerId: userId,
            deviceId: deviceId,
            token: fcmToken,
            tokenFrom: deviceType,
          );

      // Use safe API caller for device token saving
      final result = await SafeApiCaller.callWithRetryAndTimeout(
        () => _repository.saveDeviceToken(notificationRequestModel),
        operationName: 'save_device_token',
        maxRetries: 2,
        timeout: const Duration(seconds: 15),
      );

      if (result == null) {
        debugPrint('⚠️ Device token save returned null result');
      }
    } catch (e) {
      debugPrint('❌ Error saving device token: $e');
      // Don't emit error state for device token saving as it's not critical
    }
  }

  Future<(String? deviceType, String? id)> getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return ("android", androidInfo.id);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return ("IOS", iosInfo.identifierForVendor);
      }
      return ("", "");
    } catch (e) {
      debugPrint('❌ Error getting device info: $e');
      return ("", "");
    }
  }
}
