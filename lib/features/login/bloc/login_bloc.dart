import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/login/api_request/notification_request_model.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/service/pushNotification/notification_service.dart';
import 'package:gro_one_app/utils/app_string.dart';

import '../../../data/model/result.dart';
import '../api_request/login_in_api_request.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginInRepository _repository;
  final securedSharedPreference=locator<SecuredSharedPreferences>();


  LoginBloc(this._repository) : super(const LoginState()) {
    on<LoginInRequested>((event, emit) async {
      emit(LogInLoading());
      Result result = await _repository.requestLogin(event.apiRequest);

      if (result is Success<LoginApiResponseModel>) {
        emit(LogInSuccess(result.value));

      } else if (result is Error) {
        emit(LogInError(result.type));
      } else {
        emit(LogInError(GenericError()));
      }
    });

    on<ChangeIndex>(_onChangeIndex);
    on<SaveDeviceToken>((event, emit) => _saveDeviceToken(event.userId),);
  }



  _onChangeIndex(ChangeIndex event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.isSuccess, counter: event.index));
  }


   _saveDeviceToken(String? userId,) async {
    String? fcmToken=NotificationService.deviceToken;
    print("fcmToken is $fcmToken");
    String? deviceId=( await getDeviceInfo()).$2;
    String? deviceType =( await getDeviceInfo()).$1;
    NotificationRequestModel notificationRequestModel=NotificationRequestModel(
      customerId:userId ,
      deviceId: deviceId,
      token: fcmToken,
      tokenFrom: deviceType,
    );
   _repository.saveDeviceToken(notificationRequestModel);
  }


  Future<(String? deviceType, String? id)> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return ("android",androidInfo.id);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return ("IOS",iosInfo.identifierForVendor);
    }
    return ("","");
  }




}
