part of 'gps_info_window_details_cubit.dart';

class GpsInfoWindowDetailsState {
  final UIState<GpsInfoWindowDetails>? infoWindowDetailsState;

  const GpsInfoWindowDetailsState({this.infoWindowDetailsState});

  GpsInfoWindowDetailsState copyWith({
    UIState<GpsInfoWindowDetails>? infoWindowDetailsState,
  }) {
    return GpsInfoWindowDetailsState(
      infoWindowDetailsState:
          infoWindowDetailsState ?? this.infoWindowDetailsState,
    );
  }
}
