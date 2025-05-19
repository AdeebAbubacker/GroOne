import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'role_event.dart';

part 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(const RoleState()) {
    on<ChangeIndex>(_onChangeIndex);

  }
  _onChangeIndex(ChangeIndex event, Emitter<RoleState> emit) async {

    emit(
      state.copyWith(
        status: RoleStatus.isSuccess,
        counter:  event.index,
      ),
    );
  }
}