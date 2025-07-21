import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../model/path_positions_pojo.dart';
import '../repository/path_replay_repository.dart';
import 'path_replay_state.dart';

class PathReplayCubit extends Cubit<PathReplayState> {
  final PathReplayRepository _repository;
  Timer? _playbackTimer;
  Timer? _markerAnimationTimer;
  int? _lastAnimatedIndex;
  
  // Store parameters for retry functionality
  String? _token;
  Map<String, dynamic>? _queryParams;

  PathReplayCubit(this._repository) : super(const PathReplayState()) {
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    try {
      final icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/png/vp.png',
      );
      emit(state.copyWith(truckIcon: icon));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to load truck icon'));
    }
  }

  Future<String> _getAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final place = placemarks.first;
      return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return "Unknown location";
    }
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final lat1 = start.latitude * math.pi / 180.0;
    final lon1 = start.longitude * math.pi / 180.0;
    final lat2 = end.latitude * math.pi / 180.0;
    final lon2 = end.longitude * math.pi / 180.0;

    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - 
              math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return (math.atan2(y, x) * 180.0 / math.pi + 360.0) % 360.0;
  }

  void _animateMarker(LatLng from, LatLng to, {int durationMs = 400}) {
    _markerAnimationTimer?.cancel();
    const int steps = 20;
    int currentStep = 0;
    emit(state.copyWith(animatedMarkerPosition: from));

    _markerAnimationTimer = Timer.periodic(
      Duration(milliseconds: durationMs ~/ steps),
      (timer) {
        currentStep++;
        final double t = currentStep / steps;
        final double lat = from.latitude + (to.latitude - from.latitude) * t;
        final double lng = from.longitude + (to.longitude - from.longitude) * t;
        emit(state.copyWith(animatedMarkerPosition: LatLng(lat, lng)));
        
        if (currentStep >= steps) {
          timer.cancel();
          emit(state.copyWith(animatedMarkerPosition: to));
        }
      },
    );
  }

  void seek(int index) {
    final clampedIndex = index.clamp(0, state.pathPositions.length - 1);
    emit(state.copyWith(currentIndex: clampedIndex));
    _updateAddressAndAnimation();
  }

  void _updateAddressAndAnimation() {
    if (state.pathPositions.isEmpty) return;

    final pathPoints = state.pathPositions
        .map((pos) => LatLng(pos.latitude!, pos.longitude!))
        .toList();

    final currentIndex = state.currentIndex.clamp(0, pathPoints.length - 1);
    final currentPosition = pathPoints[currentIndex];
    final previousPosition = currentIndex > 0 ? pathPoints[currentIndex - 1] : currentPosition;

    // Update address
    _getAddress(currentPosition).then((address) {
      emit(state.copyWith(currentAddress: address));
    });

    // Animate marker if index changed
    if (_lastAnimatedIndex != currentIndex && previousPosition != null) {
      _lastAnimatedIndex = currentIndex;
      final int durationMs = (400 / state.playbackSpeed).clamp(80, 400).toInt();
      _animateMarker(
        state.animatedMarkerPosition ?? previousPosition,
        currentPosition,
        durationMs: durationMs,
      );
    }
  }

  Future<void> fetchPathReplay(String token, Map<String, dynamic> queryParams) async {
    // Store parameters for retry
    _token = token;
    _queryParams = queryParams;
    
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final allPositions = await _repository.getPathReplay(token, queryParams);

      final stops = allPositions
          .where((p) => p.stopTime != null && p.stopTime!.isNotEmpty)
          .length;

      emit(state.copyWith(
        isLoading: false,
        pathPositions: allPositions,
        stopsCount: stops,
        hasFitToPath: false,
      ));

      // Initialize with first position
      if (allPositions.isNotEmpty) {
        _updateAddressAndAnimation();
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false, 
        errorMessage: 'Failed to fetch path replay data: ${e.toString()}'
      ));
    }
  }

  Future<void> retry() async {
    if (_token != null && _queryParams != null) {
      await fetchPathReplay(_token!, _queryParams!);
    }
  }

  void play() {
    if (state.isPlaying || state.pathPositions.isEmpty) return;
    
    emit(state.copyWith(isPlaying: true));

    _playbackTimer = Timer.periodic(
      Duration(milliseconds: (1000 / state.playbackSpeed).round()), 
      (timer) {
        if (state.currentIndex < state.pathPositions.length - 1) {
          emit(state.copyWith(currentIndex: state.currentIndex + 1));
          _updateAddressAndAnimation();
        } else {
          pause();
        }
      }
    );
  }

  void pause() {
    _playbackTimer?.cancel();
    emit(state.copyWith(isPlaying: false));
  }

  void changeSpeed(double speed) {
    emit(state.copyWith(playbackSpeed: speed));
    if (state.isPlaying) {
      pause();
      play();
    }
  }

  void setHasFitToPath(bool hasFit) {
    emit(state.copyWith(hasFitToPath: hasFit));
  }

  double getCurrentRotation() {
    if (state.pathPositions.isEmpty || state.currentIndex <= 0) return 0;
    
    final pathPoints = state.pathPositions
        .map((pos) => LatLng(pos.latitude!, pos.longitude!))
        .toList();
    
    if (state.currentIndex >= pathPoints.length) return 0;
    
    return _calculateBearing(
      pathPoints[state.currentIndex - 1],
      pathPoints[state.currentIndex],
    );
  }

  LatLngBounds? getPathBounds() {
    if (state.pathPositions.length < 2) return null;
    
    final points = state.pathPositions
        .map((pos) => LatLng(pos.latitude!, pos.longitude!))
        .toList();
    
    double x0 = points.first.latitude, x1 = points.first.latitude;
    double y0 = points.first.longitude, y1 = points.first.longitude;
    
    for (LatLng latLng in points) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    
    return LatLngBounds(
      southwest: LatLng(x0, y0), 
      northeast: LatLng(x1, y1)
    );
  }

  @override
  Future<void> close() {
    _playbackTimer?.cancel();
    _markerAnimationTimer?.cancel();
    return super.close();
  }
}
