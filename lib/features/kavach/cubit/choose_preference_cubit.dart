import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/result.dart';
import '../model/kavach_masters_model.dart';
import '../model/kavach_choose_preference_model.dart';
import '../repository/kavach_repository.dart';
import 'choose_preference_state.dart';

/// Cubit for managing choose preference state and operations
class ChoosePreferenceCubit extends Cubit<ChoosePreferenceState> {
  final KavachRepository _repository;
  bool _isClosed = false;

  ChoosePreferenceCubit(this._repository) : super(ChoosePreferenceState.initial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(ChoosePreferenceState.initial());
  }

  /// Fetches masters data for vehicle preferences
  Future<void> fetchMastersData() async {
    if (_isClosed) return;
    
    if (!_isClosed) {
      emit(state.copyWith(mastersLoading: true, mastersError: null));
    }

    final result = await _repository.getMasters();

    if (_isClosed) return;

    if (result is Success<KavachMastersModel>) {
      if (!_isClosed) {
        emit(state.copyWith(
          mastersData: result.value,
          mastersLoading: false,
        ));
      }
    } else if (result is Error<KavachMastersModel>) {
      if (!_isClosed) {
        emit(state.copyWith(
          mastersError: result.type,
          mastersLoading: false,
        ));
      }
    }
  }

  /// Updates user preferences
  void updateUserPreferences(KavachChoosePreferenceModel preferences) {
    if (!_isClosed) {
      emit(state.copyWith(userPreferences: preferences));
    }
  }

  /// Resets the state to initial
  void reset() {
    if (!_isClosed) {
      emit(ChoosePreferenceState.initial());
    }
  }
} 