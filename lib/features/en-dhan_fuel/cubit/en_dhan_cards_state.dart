
import 'package:equatable/equatable.dart';

import '../../../data/ui_state/ui_state.dart';
import '../model/en_dhan_models.dart' as api_models show EnDhanCardListModel;

class EnDhanCardsState extends Equatable {
  // UI States
  final UIState<api_models.EnDhanCardListModel>? cardsState;

  const EnDhanCardsState({
    this.cardsState,
  });

  /// Factory constructor for initial state
  factory EnDhanCardsState.initial() {
    return EnDhanCardsState();
  }

  EnDhanCardsState copyWith({
    UIState<api_models.EnDhanCardListModel>? cardsState,
  }) {
    return EnDhanCardsState(
      cardsState: cardsState ?? this.cardsState,
    );
  }

  @override
  List<Object?> get props => [
    cardsState,
  ];
} 