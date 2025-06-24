import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/result.dart';
import '../model/masters_model.dart';
import '../model/choose_preference_model.dart';
import '../repository/kavach_repository.dart';
import 'choose_preference_state.dart';

/// Cubit for managing choose preference state and operations
class ChoosePreferenceCubit extends Cubit<ChoosePreferenceState> {
  final KavachRepository _repository;

  ChoosePreferenceCubit(this._repository) : super(ChoosePreferenceState.initial());

  /// Fetches masters data for vehicle preferences
  Future<void> fetchMastersData() async {
    emit(state.copyWith(mastersLoading: true, mastersError: null));

    final result = await _repository.getMasters();

    if (result is Success<MastersModel>) {
      emit(state.copyWith(
        mastersData: result.value,
        mastersLoading: false,
      ));
    } else if (result is Error<MastersModel>) {
      emit(state.copyWith(
        mastersError: result.type,
        mastersLoading: false,
      ));
    }
  }

  /// Updates user preferences
  void updateUserPreferences(ChoosePreferenceModel preferences) {
    emit(state.copyWith(userPreferences: preferences));
  }

  /// Resets the state to initial
  void reset() {
    emit(ChoosePreferenceState.initial());
  }
} 