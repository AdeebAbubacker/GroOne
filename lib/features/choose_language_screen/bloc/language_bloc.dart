import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/choose_language_screen/repository/language_repository.dart';

import '../../../data/model/result.dart';
import '../model/language_model.dart';

part 'language_event.dart';

part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageRepository repository ;

  LanguageBloc(this.repository) : super(const LanguageState()) {
    on<ChangeIndex>(_onChangeIndex);
    on<LoadLanguages>((event, emit) async {
      emit(state.copyWith(status: CounterStatus.isLoading));
      final result = await repository.getLanguages();
      if (result is Success<List<LanguageModel>>) {
        emit(state.copyWith(
          status: CounterStatus.isSuccess,
          languages: result.value,
        ));
      } else {
        emit(state.copyWith(status: CounterStatus.isFailed));
      }
    });

  }
  _onChangeIndex(ChangeIndex event, Emitter<LanguageState> emit) async {

    emit(
      state.copyWith(
        status: CounterStatus.isSuccess,
        counter:  event.index,
      ),
    );
  }
}