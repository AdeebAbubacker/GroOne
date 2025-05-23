import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/result.dart';
import '../api_request/login_in_api_request.dart';
import '../model/login_model.dart';
import '../repository/login_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginInRepository _repository;

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
  }

  _onChangeIndex(ChangeIndex event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.isSuccess, counter: event.index));
  }
}
