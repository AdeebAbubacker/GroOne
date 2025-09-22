import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/fastag/model/fastag_list_response.dart';

class FastagOrderListTabState extends Equatable {
  final UIState<FastagListResponse?> fastagListUIState;

  const FastagOrderListTabState({required this.fastagListUIState});

  factory FastagOrderListTabState.initial() =>
      FastagOrderListTabState(fastagListUIState: UIState.initial());

  FastagOrderListTabState copyWith({
    UIState<FastagListResponse?>? fastagListUIState,
  }) {
    return FastagOrderListTabState(
      fastagListUIState: fastagListUIState ?? this.fastagListUIState,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [fastagListUIState];
}
