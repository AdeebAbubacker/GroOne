part of 'vp_recent_load_list_bloc.dart';

sealed class VpRecentLoadListState {}

final class VpRecentLoadListInitial extends VpRecentLoadListState {}

class VpRecentLoadListLoading extends VpRecentLoadListState {}

class VpRecentLoadListError extends VpRecentLoadListState {
  final ErrorType errorType;
  VpRecentLoadListError(this.errorType);
}

class VpRecentLoadListSuccess extends VpRecentLoadListState {
  final VpRecentLoadResponse vpRecentLoadResponse;
  VpRecentLoadListSuccess(this.vpRecentLoadResponse);
}
