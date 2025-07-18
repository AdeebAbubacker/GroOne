import 'package:equatable/equatable.dart';
import '../../../../data/model/result.dart';
import '../model/kavach_masters_model.dart';
import '../model/kavach_choose_preference_model.dart';


class ChoosePreferenceState extends Equatable {
  /// Masters data containing vehicle filters (make, model, engine type, etc.)
  final KavachMastersModel? mastersData;
  
  /// Loading state for masters data
  final bool mastersLoading;
  
  /// Error state for masters data
  final ErrorType? mastersError;
  
  /// Current user preferences
  final KavachChoosePreferenceModel userPreferences;

  const ChoosePreferenceState({
    this.mastersData,
    this.mastersLoading = false,
    this.mastersError,
    this.userPreferences = const KavachChoosePreferenceModel(),
  });

  /// Creates initial state
  factory ChoosePreferenceState.initial() {
    return const ChoosePreferenceState(
      mastersData: null,
      mastersLoading: false,
      mastersError: null,
      userPreferences: KavachChoosePreferenceModel(),
    );
  }

  /// Creates a copy of the state with updated values
  ChoosePreferenceState copyWith({
    KavachMastersModel? mastersData,
    bool? mastersLoading,
    ErrorType? mastersError,
    KavachChoosePreferenceModel? userPreferences,
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