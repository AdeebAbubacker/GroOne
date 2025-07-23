import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/path_positions_pojo.dart';
import '../model/trip_path_model.dart';

class PathReplayState extends Equatable {
  final bool isLoading;
  final List<Data> pathPositions;
  final List<TripPath> tripPathPositions;
  final int stopsCount;
  final bool isPlaying;
  final int currentIndex;
  final double playbackSpeed;
  final String currentAddress;
  final LatLng? animatedMarkerPosition;
  final bool hasFitToPath;
  final BitmapDescriptor? truckIcon;
  final String? errorMessage;
  final String pathType; // 'regular' or 'ignition'

  const PathReplayState({
    this.isLoading = false,
    this.pathPositions = const [],
    this.tripPathPositions = const [],
    this.stopsCount = 0,
    this.isPlaying = false,
    this.currentIndex = 0,
    this.playbackSpeed = 1.0,
    this.currentAddress = "Loading address...",
    this.animatedMarkerPosition,
    this.hasFitToPath = false,
    this.truckIcon,
    this.errorMessage,
    this.pathType = 'regular',
  });

  PathReplayState copyWith({
    bool? isLoading,
    List<Data>? pathPositions,
    List<TripPath>? tripPathPositions,
    int? stopsCount,
    bool? isPlaying,
    int? currentIndex,
    double? playbackSpeed,
    String? currentAddress,
    LatLng? animatedMarkerPosition,
    bool? hasFitToPath,
    BitmapDescriptor? truckIcon,
    String? errorMessage,
    String? pathType,
  }) {
    return PathReplayState(
      isLoading: isLoading ?? this.isLoading,
      pathPositions: pathPositions ?? this.pathPositions,
      tripPathPositions: tripPathPositions ?? this.tripPathPositions,
      stopsCount: stopsCount ?? this.stopsCount,
      isPlaying: isPlaying ?? this.isPlaying,
      currentIndex: currentIndex ?? this.currentIndex,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      currentAddress: currentAddress ?? this.currentAddress,
      animatedMarkerPosition:
          animatedMarkerPosition ?? this.animatedMarkerPosition,
      hasFitToPath: hasFitToPath ?? this.hasFitToPath,
      truckIcon: truckIcon ?? this.truckIcon,
      errorMessage: errorMessage ?? this.errorMessage,
      pathType: pathType ?? this.pathType,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    pathPositions,
    tripPathPositions,
    stopsCount,
    isPlaying,
    currentIndex,
    playbackSpeed,
    currentAddress,
    animatedMarkerPosition,
    hasFitToPath,
    truckIcon,
    errorMessage,
    pathType,
  ];
}
