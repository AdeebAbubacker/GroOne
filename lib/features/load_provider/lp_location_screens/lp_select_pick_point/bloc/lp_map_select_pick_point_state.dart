part of 'lp_map_select_pick_point_bloc.dart';

@immutable
sealed class LpMapSelectPickPointState {}

class LpMapSelectPickPointInitial extends LpMapSelectPickPointState {}

class LatLongLoading extends LpMapSelectPickPointState {}

class LatLongSuccess extends LpMapSelectPickPointState {
  final geo.Position position;
  LatLongSuccess(this.position);
}

class LatLongError extends LpMapSelectPickPointState {
  final ErrorType errorType; // Use your custom error type
  LatLongError(this.errorType);
}