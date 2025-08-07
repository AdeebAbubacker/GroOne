import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/choose_language_screen/model/language_model.dart';
import 'package:gro_one_app/features/choose_language_screen/repository/language_repository.dart';


part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final LanguageRepository repository;

  LanguageCubit(this.repository) : super(const LanguageState());

  Future<void> loadLanguages() async {
    emit(state.copyWith(status: LanguageStatus.loading));
    final result = await repository.getLanguages();

    if (result is Success<List<LanguageModel>>) {
      emit(state.copyWith(
        status: LanguageStatus.success,
        languages: result.value,
      ));
    } else {
      emit(state.copyWith(status: LanguageStatus.failure));
    }
  }

  void changeIndex(int index) {
    emit(state.copyWith(
      status: LanguageStatus.success,
      index: index,
    ));
  }
}
