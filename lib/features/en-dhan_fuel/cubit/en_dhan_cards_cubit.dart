
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart' as api_models;
import 'package:gro_one_app/features/en-dhan_fuel/repository/en-dhan_repository.dart';

import 'en_dhan_cards_state.dart';




class EnDhanCardsCubit extends Cubit<EnDhanCardsState> {
  final EnDhanRepository _repository;
  
  EnDhanCardsCubit(this._repository) : super(EnDhanCardsState.initial());

  /// Fetch Cards List
  Future<void> fetchCards({String? searchTerm}) async {
    print('🔄 EnDhanCardsCubit.fetchCards called with searchTerm: $searchTerm');
    
    print('📊 Setting cards UI state to loading...');
    emit(state.copyWith(cardsState: UIState.loading()));
    
    print('🌐 Calling repository.fetchCards...');
    final result = await _repository.fetchCards(searchTerm: searchTerm);
    
    print('📥 Repository result type: ${result.runtimeType}');
    
    if (result is Success<api_models.EnDhanCardListModel>) {
      print('✅ Cards fetch successful: ${result.value.data?.length ?? 0} cards');
      emit(state.copyWith(cardsState: UIState.success(result.value)));
    } else if (result is Error<api_models.EnDhanCardListModel>) {
      print('❌ Cards fetch failed: ${result.type}');
      emit(state.copyWith(cardsState: UIState.error(result.type)));
    }
  }

  /// Reset cards UI state
  void resetCardsUIState() {
    emit(state.copyWith(cardsState: null));
  }

  /// Reset all state
  void resetState() {
    emit(EnDhanCardsState.initial());
  }
} 