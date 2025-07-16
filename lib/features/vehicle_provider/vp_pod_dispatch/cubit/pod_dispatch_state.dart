part of 'pod_dispatch_cubit.dart';

class PodDispatchState extends Equatable {
  final UIState<PodCenterListModel>? podCenterListUIState;
  final UIState<bool>? submitPodUIState;

  const PodDispatchState({
    this.podCenterListUIState,
    this.submitPodUIState
  });

  PodDispatchState copyWith({
    UIState<PodCenterListModel>? podCenterListUIState,
    UIState<bool>? submitPodUIState
  }) {
    return PodDispatchState(
      podCenterListUIState: podCenterListUIState ?? this.podCenterListUIState,
      submitPodUIState: submitPodUIState ?? this.submitPodUIState
    );
  }

  @override
  List<Object?> get props => [
    podCenterListUIState,
    submitPodUIState
  ];
}

