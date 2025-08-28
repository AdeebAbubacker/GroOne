import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart' show ErrorType;
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';

part 'driver_home_event.dart';
part 'driver_home_state.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  final UserInformationRepository _userInformationRepository;
  DriverHomeBloc(this._userInformationRepository) : super(HomeInitial());

  String? _userId;
  String? get userId => _userId;
  Future<String?> getUserId() async {
    _userId = await _userInformationRepository.getUserID();
    return _userId;
  }
}
