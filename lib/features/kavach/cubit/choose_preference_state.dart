import 'package:equatable/equatable.dart';
import '../../../../data/model/result.dart';
import '../model/masters_model.dart';
import '../model/choose_preference_model.dart';


class ChoosePreferenceState extends Equatable {
  /// Masters data containing vehicle filters (make, model, engine type, etc.)
  final MastersModel? mastersData;
  
  /// Loading state for masters data
  final bool mastersLoading;
  
  /// Error state for masters data
  final ErrorType? mastersError;
  
  /// Current user preferences
  final ChoosePreferenceModel userPreferences;

  const ChoosePreferenceState({
    this.mastersData,
    this.mastersLoading = false,
    this.mastersError,
    this.userPreferences = const ChoosePreferenceModel(),
  });

  /// Creates initial state
  factory ChoosePreferenceState.initial() {
    return const ChoosePreferenceState(
      mastersData: null,
      mastersLoading: false,
      mastersError: null,
      userPreferences: ChoosePreferenceModel(),
    );
  }

  /// Creates a copy of the state with updated values
  ChoosePreferenceState copyWith({
    MastersModel? mastersData,
    bool? mastersLoading,
    ErrorType? mastersError,
    ChoosePreferenceModel? userPreferences,
  }) {
    return ChoosePreferenceState(
      mastersData: mastersData ?? this.mastersData,
      mastersLoading: mastersLoading ?? this.mastersLoading,
      mastersError: mastersError,
      userPreferences: userPreferences ?? this.userPreferences,
    );
  }

  @override
  List<Object?> get props => [
    mastersData,
    mastersLoading,
    mastersError,
    userPreferences,
  ];
} 