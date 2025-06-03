part of 'vp_recent_load_list_bloc.dart';

sealed class VpRecentLoadListEvent {}

class VpRecentLoadEvent extends VpRecentLoadListEvent {
  VpRecentLoadEvent();
}

// Reset Vp Recent Load UI State
class ResetVpRecentLoadEvent extends VpRecentLoadListEvent {}


