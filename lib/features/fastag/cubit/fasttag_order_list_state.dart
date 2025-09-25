import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/fastag/model/fastag_list_response.dart';

class FastagState1 extends Equatable {
  final UIState<FastagListResponse?> fastagListUIState;

  const FastagState1({required this.fastagListUIState});

  factory FastagState1.initial() =>
      FastagState1(fastagListUIState: UIState.initial());

  FastagState1 copyWith({UIState<FastagListResponse?>? fastagListUIState}) {
    return FastagState1(
      fastagListUIState: fastagListUIState ?? this.fastagListUIState,
    );
  }

  @override
  List<Object?> get props => [fastagListUIState];
}
