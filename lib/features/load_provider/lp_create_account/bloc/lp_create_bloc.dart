import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/features/load_provider/lp_create_account/model/lp_company_type_response.dart';

import '../../../../data/model/result.dart';
import '../api_request/create_request.dart';
import '../model/create_response.dart';
import '../repository/create_repository.dart';

part 'lp_create_event.dart';

part 'lp_create_state.dart';

class LpCreateBloc extends Bloc<LpCreateEvent, LpCreateState> {
  final LpCreateRepository _repository;

  LpCreateBloc(this._repository) : super(LpCreateInitial()) {
    on<LpCreateRequested>((event, emit) async {
      emit(LpCreateLoading());
      Result result = await _repository.lpCreateRegistration(
        event.apiRequest,
        id: event.id,
      );

      if (result is Success<CreateResponse>) {
        emit(LpCreateSuccess(result.value));
      } else if (result is Error) {
        emit(LpCreateError(result.type));
      } else {
        emit(LpCreateError(GenericError()));
      }
    });

    on<LpCompanyTypeRequested>((event, emit) async {
      emit(LpCreateLoading());
      Result result = await _repository.getCompanyType();

      if (result is Success<LpCompanyTypeResponse>) {
        emit(LpCompanyTypeSuccess(result.value));
      } else if (result is Error) {
        emit(LpCreateError(result.type));
      } else {
        emit(LpCreateError(GenericError()));
      }
    });
  }
}
