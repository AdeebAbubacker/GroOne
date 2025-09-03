import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  int? _deviceId;
  String? _pathType;

  PathReplayCubit(this._repository) : super(const PathReplayState()) {
    _loadCustomMarker();
  }

  Future<BitmapDescriptor> _getResizedBitmapDescriptor(
    String assetPath, {
    int targetWidth = 32,
  }) async {
    final ByteData data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: targetWidth,
    );
    final frame = await codec.getNextFrame();
    final ByteData? resizedImage = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(resizedImage!.buffer.asUint8List());
  }

  Future<void> _loadCustomMarker() async {
    try {
      // Use the working resizing method with appropriate size for map
      final icon = await _getResizedBitmapDescriptor(
        'assets/images/png/red_car.png',
        targetWidth: 32, // Appropriate size for map display
      );
      emit(state.copyWith(truckIcon: icon));
    } catch (e) {
      print('Failed to load red car icon: $e');
      // Fallback to the original truck icon if the new one fails to load
      try {
        final fallbackIcon = await _getResizedBitmapDescriptor(
          'assets/images/png/vp.png',
          targetWidth: 32,
        );
        emit(state.copyWith(truckIcon: fallbackIcon));
      } catch (fallbackError) {
        print('Failed to load fallback icon: $fallbackError');
        // Final fallback to a red default marker
        final finalFallback = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        );
        emit(state.copyWith(truckIcon: finalFallback));
      }
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
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return (math.atan2(y, x) * 180.0 / math.pi + 360.0) % 360.0;
  }

  void _animateMarker(LatLng from, LatLng to, {int durationMs = 400}) {
    _markerAnimationTimer?.cancel();

    // Increase steps for smoother animation and adjust based on distance
    final distance = _calculateDistance(from, to);
    final int baseSteps = 30; // Increased from 20
    final int steps = (baseSteps + (distance * 10)).clamp(20, 60).toInt();

    int currentStep = 0;
    emit(state.copyWith(animatedMarkerPosition: from));

    _markerAnimationTimer = Timer.periodic(
      Duration(milliseconds: (durationMs / steps).round()),
      (timer) {
        currentStep++;

        // Use easing function for smoother movement
        final double t = _easeInOutCubic(currentStep / steps);
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

  // Add easing function for smoother animation
  double _easeInOutCubic(double t) {
    if (t < 0.5) {
      return 4 * t * t * t;
    } else {
      return 1 - 4 * (1 - t) * (1 - t) * (1 - t);
    }
  }

  // Add distance calculation helper
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Earth radius in meters

    final lat1Rad = point1.latitude * math.pi / 180;
    final lat2Rad = point2.latitude * math.pi / 180;
    final deltaLatRad = (point2.latitude - point1.latitude) * math.pi / 180;
    final deltaLngRad = (point2.longitude - point1.longitude) * math.pi / 180;

    final a =
        math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLngRad / 2) *
            math.sin(deltaLngRad / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c / 1000; // Return distance in kilometers
  }

  void seek(int index) {
    final maxIndex =
        state.pathType == 'ignition'
            ? state.tripPathPositions.length - 1
            : state.pathPositions.length - 1;
    final clampedIndex = index.clamp(0, maxIndex);
    emit(state.copyWith(currentIndex: clampedIndex));
    _updateAddressAndAnimation();
  }

  void _updateAddressAndAnimation() {
    if (state.pathType == 'ignition') {
      _updateAddressAndAnimationForTripPath();
    } else {
      _updateAddressAndAnimationForRegularPath();
    }
  }

  void _updateAddressAndAnimationForRegularPath() {
    if (state.pathPositions.isEmpty) return;

    final pathPoints =
        state.pathPositions
            .map((pos) => LatLng(pos.latitude!, pos.longitude!))
            .toList();

    final currentIndex = state.currentIndex.clamp(0, pathPoints.length - 1);
    final currentPosition = pathPoints[currentIndex];
    final previousPosition =
        currentIndex > 0 ? pathPoints[currentIndex - 1] : currentPosition;

    // Update address
    _getAddress(currentPosition).then((address) {
      emit(state.copyWith(currentAddress: address));
    });

    // Animate marker if index changed
    if (_lastAnimatedIndex != currentIndex && previousPosition != null) {
      _lastAnimatedIndex = currentIndex;

      // Better duration calculation for smoother movement
      // Use 80% of the playback interval to ensure animation completes before next position
      final playbackInterval = (1000 / state.playbackSpeed);
      final int durationMs = (playbackInterval * 0.8).clamp(200, 800).toInt();

      _animateMarker(
        state.animatedMarkerPosition ?? previousPosition,
        currentPosition,
        durationMs: durationMs,
      );
    }
  }

  void _updateAddressAndAnimationForTripPath() {
    if (state.tripPathPositions.isEmpty) return;

    final pathPoints =
        state.tripPathPositions
            .map((pos) => LatLng(pos.latitude!, pos.longitude!))
            .toList();

    final currentIndex = state.currentIndex.clamp(0, pathPoints.length - 1);
    final currentPosition = pathPoints[currentIndex];
    final previousPosition =
        currentIndex > 0 ? pathPoints[currentIndex - 1] : currentPosition;

    // Update address
    _getAddress(currentPosition).then((address) {
      emit(state.copyWith(currentAddress: address));
    });

    // Animate marker if index changed
    if (_lastAnimatedIndex != currentIndex && previousPosition != null) {
      _lastAnimatedIndex = currentIndex;

      // Better duration calculation for smoother movement
      // Use 80% of the playback interval to ensure animation completes before next position
      final playbackInterval = (1000 / state.playbackSpeed);
      final int durationMs = (playbackInterval * 0.8).clamp(200, 800).toInt();

      _animateMarker(
        state.animatedMarkerPosition ?? previousPosition,
        currentPosition,
        durationMs: durationMs,
      );
    }
  }

  Future<void> fetchPathReplay(
    String token,
    Map<String, dynamic> queryParams,
  ) async {
    _token = token;
    _queryParams = queryParams;
    _pathType = 'regular';

    // Check if this is a daily path (start date is today's start of day)
    final startDate = queryParams['start']?.toString();
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final isDailyPath =
        startDate != null &&
        startDate.contains(startOfDay.toIso8601String().split('T')[0]);

    if (isDailyPath) {
      _pathType = 'daily';
    }

    emit(
      state.copyWith(isLoading: true, errorMessage: null, pathType: _pathType),
    );

    try {
      final pathPositions = await _repository.getPathReplay(token, queryParams);

      final stops =
          pathPositions
              .where((p) => p.stopTime != null && p.stopTime!.isNotEmpty)
              .length;

      // For daily path, set current index to last position to show vehicle at the end
      final lastIndex = pathPositions.isNotEmpty ? pathPositions.length - 1 : 0;

      emit(
        state.copyWith(
          isLoading: false,
          pathPositions: pathPositions,
          tripPathPositions: [], // Clear trip path positions
          stopsCount: stops,
          hasFitToPath: false,
          currentIndex:
              isDailyPath
                  ? lastIndex
                  : 0, // Set to last position for daily path
          animatedMarkerPosition: null,
          isPlaying: false, // Don't start playing for daily path
        ),
      );

      if (pathPositions.isNotEmpty) {
        if (isDailyPath) {
          // For daily path, just fit to path without starting animation
          _getPathBoundsForRegularPath();
        } else {
          // For regular path replay, start with first position
          _updateAddressAndAnimation();
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to fetch path replay data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> fetchTripPath(String token, int deviceId) async {
    _token = token;
    _deviceId = deviceId;
    _pathType = 'ignition';

    emit(
      state.copyWith(isLoading: true, errorMessage: null, pathType: 'ignition'),
    );
    try {
      final tripPathPositions = await _repository.getTripPath(token, deviceId);

      final stops =
          tripPathPositions
              .where((p) => p.stopTime != null && p.stopTime!.isNotEmpty)
              .length;

      // For ignition path, set current index to last position to show vehicle at the end
      final lastIndex =
          tripPathPositions.isNotEmpty ? tripPathPositions.length - 1 : 0;

      emit(
        state.copyWith(
          isLoading: false,
          pathPositions: [], // Clear regular path positions
          tripPathPositions: tripPathPositions,
          stopsCount: stops,
          hasFitToPath: false,
          currentIndex: lastIndex, // Set to last position for ignition path
          animatedMarkerPosition: null,
          isPlaying: false, // Don't start playing for ignition path
        ),
      );

      if (tripPathPositions.isNotEmpty) {
        // For ignition path, just fit to path without starting animation
        _getPathBoundsForTripPath();
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to fetch trip path data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> retry() async {
    if (_token != null) {
      if (_pathType == 'ignition' && _deviceId != null) {
        await fetchTripPath(_token!, _deviceId!);
      } else if (_pathType == 'daily' && _queryParams != null) {
        await fetchPathReplay(_token!, _queryParams!);
      } else if (_queryParams != null) {
        await fetchPathReplay(_token!, _queryParams!);
      }
    }
  }

  void play() {
    final maxIndex =
        state.pathType == 'ignition'
            ? state.tripPathPositions.length - 1
            : state.pathPositions.length - 1;

    if (state.isPlaying || maxIndex < 0) return;

    emit(state.copyWith(isPlaying: true));

    // Improved playback timing for smoother movement
    // Ensure minimum interval for smooth animation at high speeds
    final baseInterval = (1000 / state.playbackSpeed);
    final playbackInterval =
        baseInterval.clamp(100, 2000).round(); // Min 100ms, Max 2s

    _playbackTimer = Timer.periodic(Duration(milliseconds: playbackInterval), (
      timer,
    ) {
      if (state.currentIndex < maxIndex) {
        emit(state.copyWith(currentIndex: state.currentIndex + 1));
        _updateAddressAndAnimation();
      } else {
        pause();
      }
    });
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
    if (state.pathType == 'ignition') {
      return _getCurrentRotationForTripPath();
    } else {
      return _getCurrentRotationForRegularPath();
    }
  }

  double _getCurrentRotationForRegularPath() {
    if (state.pathPositions.isEmpty || state.currentIndex <= 0) return 0;

    final pathPoints =
        state.pathPositions
            .map((pos) => LatLng(pos.latitude!, pos.longitude!))
            .toList();

    if (state.currentIndex >= pathPoints.length) return 0;

    return _calculateBearing(
      pathPoints[state.currentIndex - 1],
      pathPoints[state.currentIndex],
    );
  }

  double _getCurrentRotationForTripPath() {
    if (state.tripPathPositions.isEmpty || state.currentIndex <= 0) return 0;

    final pathPoints =
        state.tripPathPositions
            .map((pos) => LatLng(pos.latitude!, pos.longitude!))
            .toList();

    if (state.currentIndex >= pathPoints.length) return 0;

    return _calculateBearing(
      pathPoints[state.currentIndex - 1],
      pathPoints[state.currentIndex],
    );
  }

  LatLngBounds? getPathBounds() {
    if (state.pathType == 'ignition') {
      return _getPathBoundsForTripPath();
    } else {
      return _getPathBoundsForRegularPath();
    }
  }

  LatLngBounds? _getPathBoundsForRegularPath() {
    if (state.pathPositions.length < 2) return null;

    final points =
        state.pathPositions
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

    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }

  LatLngBounds? _getPathBoundsForTripPath() {
    if (state.tripPathPositions.length < 2) return null;

    final points =
        state.tripPathPositions
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

    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }

  @override
  Future<void> close() {
    _playbackTimer?.cancel();
    _markerAnimationTimer?.cancel();
    return super.close();
  }
}
