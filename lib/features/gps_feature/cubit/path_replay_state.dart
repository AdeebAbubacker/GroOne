import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/path_positions_pojo.dart';

class PathReplayState extends Equatable {
  final bool isLoading;
  final List<Data> pathPositions;
  final int stopsCount;
  final bool isPlaying;
  final int currentIndex;
  final double playbackSpeed;
  final String currentAddress;
  final LatLng? animatedMarkerPosition;
  final bool hasFitToPath;
  final BitmapDescriptor? truckIcon;
  final String? errorMessage;

  const PathReplayState({
    this.isLoading = false,
    this.pathPositions = const [],
    this.stopsCount = 0,
    this.isPlaying = false,
    this.currentIndex = 0,
    this.playbackSpeed = 1.0,
    this.currentAddress = "Loading address...",
    this.animatedMarkerPosition,
    this.hasFitToPath = false,
    this.truckIcon,
    this.errorMessage,
  });

  PathReplayState copyWith({
    bool? isLoading,
    List<Data>? pathPositions,
    int? stopsCount,
    bool? isPlaying,
    int? currentIndex,
    double? playbackSpeed,
    String? currentAddress,
    LatLng? animatedMarkerPosition,
    bool? hasFitToPath,
    BitmapDescriptor? truckIcon,
    String? errorMessage,
  }) {
    return PathReplayState(
      isLoading: isLoading ?? this.isLoading,
      pathPositions: pathPositions ?? this.pathPositions,
      stopsCount: stopsCount ?? this.stopsCount,
      isPlaying: isPlaying ?? this.isPlaying,
      currentIndex: currentIndex ?? this.currentIndex,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      currentAddress: currentAddress ?? this.currentAddress,
      animatedMarkerPosition: animatedMarkerPosition ?? this.animatedMarkerPosition,
      hasFitToPath: hasFitToPath ?? this.hasFitToPath,
      truckIcon: truckIcon ?? this.truckIcon,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading, 
    pathPositions, 
    stopsCount, 
    isPlaying, 
    currentIndex, 
    playbackSpeed,
    currentAddress,
    animatedMarkerPosition,
    hasFitToPath,
    truckIcon,
    errorMessage,
  ];
}
