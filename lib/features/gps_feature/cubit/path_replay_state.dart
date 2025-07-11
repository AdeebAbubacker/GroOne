import 'package:equatable/equatable.dart';
import '../model/path_positions_pojo.dart';

class PathReplayState extends Equatable {
  final bool isLoading;
  final List<Data> pathPositions; // <-- Changed from PathPositionsPojo to Data
  final int stopsCount;
  final bool isPlaying;
  final int currentIndex;
  final double playbackSpeed;

  const PathReplayState({
    this.isLoading = false,
    this.pathPositions = const [],
    this.stopsCount = 0,
    this.isPlaying = false,
    this.currentIndex = 0,
    this.playbackSpeed = 1.0,
  });

  PathReplayState copyWith({
    bool? isLoading,
    List<Data>? pathPositions, // <-- Changed here too
    int? stopsCount,
    bool? isPlaying,
    int? currentIndex,
    double? playbackSpeed,
  }) {
    return PathReplayState(
      isLoading: isLoading ?? this.isLoading,
      pathPositions: pathPositions ?? this.pathPositions,
      stopsCount: stopsCount ?? this.stopsCount,
      isPlaying: isPlaying ?? this.isPlaying,
      currentIndex: currentIndex ?? this.currentIndex,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
    );
  }

  @override
  List<Object?> get props => [isLoading, pathPositions, stopsCount, isPlaying, currentIndex, playbackSpeed];
}
