part of 'lp_map_select_pick_point_bloc.dart';

@immutable
sealed class LpMapSelectPickPointEvent {}

class FetchCurrentLatLong extends LpMapSelectPickPointEvent {}

