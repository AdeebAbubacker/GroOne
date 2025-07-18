import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/login/repository/auth_repository.dart';
import 'package:gro_one_app/features/splash/splash_repository.dart';

class SplashViewModel extends ChangeNotifier{
  final SplashRepository _splashRepository;
  final AuthRepository _authRepository;
  SplashViewModel(this._splashRepository, this._authRepository);


  UIState<bool>? _checkIsUserLoginUIState;
  UIState<bool>? get checkIsUserLoginUIState =>  _checkIsUserLoginUIState;
  void _setIsUserLoginUIState(UIState<bool>? value){
    _checkIsUserLoginUIState = value;
  }
  Future<void> fetchIsUserLogin() async {
    Result result = await _splashRepository.getIsUserLogin();
    if (result is Success<bool>) {
      _setIsUserLoginUIState(UIState.success(result.value));
    }
    if(result is Error){
      await _authRepository.signOut();
      _setIsUserLoginUIState(UIState.error(result.type));
    }
  }


  UIState<int>? _checkUserRoleUIState;
  UIState<int>? get userRoleUIState =>  _checkUserRoleUIState;
  void _setUserRoleUIState(UIState<int>? value){
    _checkUserRoleUIState = value;
  }

  Future<void> fetchUserType() async {
    Result result = await _splashRepository.getUserRole();
    if (result is Success<int>) {
      _setUserRoleUIState(UIState.success(result.value));
    }
    if(result is Error){
      _setUserRoleUIState(UIState.error(result.type));
    }
  }



}
