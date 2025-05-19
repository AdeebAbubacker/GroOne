import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_event.dart';

part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<ChangeIndex>(_onChangeIndex);

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