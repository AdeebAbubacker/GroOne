import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/path_positions_pojo.dart';
import '../repository/path_replay_repository.dart';
import 'path_replay_state.dart';

class PathReplayCubit extends Cubit<PathReplayState> {
  final PathReplayRepository _repository;
  Timer? _timer;

  PathReplayCubit(this._repository) : super(const PathReplayState());

  void seek(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> fetchPathReplay(String token, Map<String, dynamic> queryParams) async {
    emit(state.copyWith(isLoading: true));
    try {
      final allPositions = await _repository.getPathReplay(token, queryParams);

      final stops = allPositions
          .where((p) => p.stopTime != null && p.stopTime!.isNotEmpty)
          .length;

      emit(state.copyWith(
        isLoading: false,
        pathPositions: allPositions, // Directly assign List<Data>
        stopsCount: stops,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }



  void play() {
    if (state.isPlaying) return;
    emit(state.copyWith(isPlaying: true));

    _timer = Timer.periodic(Duration(milliseconds: (1000 / state.playbackSpeed).round()), (timer) {
      if (state.currentIndex < state.pathPositions.length - 1) {
        emit(state.copyWith(currentIndex: state.currentIndex + 1));
      } else {
        pause();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    emit(state.copyWith(isPlaying: false));
  }

  void changeSpeed(double speed) {
    emit(state.copyWith(playbackSpeed: speed));
    if (state.isPlaying) {
      pause();
      play();
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
