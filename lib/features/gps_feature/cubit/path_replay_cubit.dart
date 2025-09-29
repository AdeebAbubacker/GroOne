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
  double? _lastBearing; // Track previous bearing for smooth rotation

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
      // Fallback to the original truck icon if the new one fails to load
      try {
        final fallbackIcon = await _getResizedBitmapDescriptor(
          'assets/images/png/vp.png',
          targetWidth: 32,
        );
        emit(state.copyWith(truckIcon: fallbackIcon));
      } catch (fallbackError) {
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

    // Calculate bearing and normalize to 0-360 range
    final bearing = math.atan2(y, x) * 180.0 / math.pi;
    return (bearing + 360.0) % 360.0;
  }

  // Calculate bearing with smoothing to avoid jittery rotation
  double _calculateSmoothBearing(
    LatLng start,
    LatLng end,
    double? previousBearing,
  ) {
    final newBearing = _calculateBearing(start, end);

    if (previousBearing == null) return newBearing;

    // Calculate the shortest rotation angle
    double diff = newBearing - previousBearing;
    if (diff > 180) {
      diff -= 360;
    } else if (diff < -180) {
      diff += 360;
    }

    // Apply smoothing factor to reduce jitter
    const double smoothingFactor = 0.3;
    final smoothedBearing = previousBearing + (diff * smoothingFactor);

    return (smoothedBearing + 360.0) % 360.0;
  }

  void _animateMarker(LatLng from, LatLng to, {int durationMs = 400}) {
    _markerAnimationTimer?.cancel();

    // Calculate distance-based duration like native Android
    final distance = _calculateDistance(from, to);
    final int calculatedDuration = _getAnimationDuration(distance);
    final int finalDuration = calculatedDuration.clamp(100, 3000);

    // Use 60 FPS for smooth animation (16ms per frame)
    const int frameRate = 60;
    final int totalFrames = (finalDuration / (1000 / frameRate)).round();
    final int frameDuration = (1000 / frameRate).round();

    int currentFrame = 0;
    emit(state.copyWith(animatedMarkerPosition: from));

    _markerAnimationTimer = Timer.periodic(
      Duration(milliseconds: frameDuration),
      (timer) {
        currentFrame++;

        // Calculate progress (0.0 to 1.0)
        final double progress = currentFrame / totalFrames;
        final double t = progress.clamp(0.0, 1.0);

        // Use spherical interpolation like native Android
        final newPosition = _interpolateSpherical(from, to, t);

        // Emit position update
        emit(state.copyWith(animatedMarkerPosition: newPosition));

        if (currentFrame >= totalFrames) {
          timer.cancel();
          // Ensure final position is exactly on target GPS point
          emit(state.copyWith(animatedMarkerPosition: to));

          // Continue to next position if playing (like native Android)
          if (state.isPlaying) {
            _startAnimationSequence();
          }
        }
      },
    );
  }

  // Spherical interpolation exactly like native Android LatLngInterpolator.Spherical
  LatLng _interpolateSpherical(LatLng from, LatLng to, double fraction) {
    // Convert to radians
    final fromLat = from.latitude * math.pi / 180.0;
    final fromLng = from.longitude * math.pi / 180.0;
    final toLat = to.latitude * math.pi / 180.0;
    final toLng = to.longitude * math.pi / 180.0;

    final cosFromLat = math.cos(fromLat);
    final cosToLat = math.cos(toLat);

    // Computes Spherical interpolation coefficients
    final angle = _computeAngleBetween(fromLat, fromLng, toLat, toLng);
    final sinAngle = math.sin(angle);

    if (sinAngle < 1E-6) {
      return from;
    }

    final a = math.sin((1 - fraction) * angle) / sinAngle;
    final b = math.sin(fraction * angle) / sinAngle;

    // Converts from polar to vector and interpolate
    final x =
        a * cosFromLat * math.cos(fromLng) + b * cosToLat * math.cos(toLng);
    final y =
        a * cosFromLat * math.sin(fromLng) + b * cosToLat * math.sin(toLng);
    final z = a * math.sin(fromLat) + b * math.sin(toLat);

    // Converts interpolated vector back to polar
    final lat = math.atan2(z, math.sqrt(x * x + y * y));
    final lng = math.atan2(y, x);

    return LatLng(lat * 180.0 / math.pi, lng * 180.0 / math.pi);
  }

  // Haversine's formula for angle calculation (from native Android)
  double _computeAngleBetween(
    double fromLat,
    double fromLng,
    double toLat,
    double toLng,
  ) {
    final dLat = fromLat - toLat;
    final dLng = fromLng - toLng;
    return 2 *
        math.asin(
          math.sqrt(
            math.pow(math.sin(dLat / 2), 2) +
                math.cos(fromLat) *
                    math.cos(toLat) *
                    math.pow(math.sin(dLng / 2), 2),
          ),
        );
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

  // Distance-based animation duration calculation exactly like native Android
  int _getAnimationDuration(double distanceKm) {
    // Convert km to meters for calculation
    final distanceM = distanceKm * 1000;

    // Speed multipliers based on playback speed (exactly like native Android)
    final speedMultipliers = _getSpeedMultipliers();

    int time;

    if (distanceM < 100) {
      time = (distanceM * speedMultipliers[0]).round();
    } else if (distanceM < 500) {
      time = (distanceM * speedMultipliers[1]).round();
    } else if (distanceM < 1000) {
      time = (distanceM * speedMultipliers[2]).round();
    } else if (distanceM < 2000) {
      time = (distanceM * speedMultipliers[3]).round();
    } else {
      time =
          3000; // Max 3 seconds for very long distances (like native Android)
    }

    return time;
  }

  // Speed multipliers based on playback speed (exactly like native Android)
  List<double> _getSpeedMultipliers() {
    final speed = state.playbackSpeed;

    if (speed <= 1.0) {
      return [
        10.0,
        5.0,
        2.0,
        1.0,
      ]; // 1x speed (multiply1, multiply2, multiply3, multiply4)
    } else if (speed <= 2.0) {
      return [5.0, 3.0, 1.0, 1.0]; // 2x speed
    } else if (speed <= 3.0) {
      return [2.0, 1.0, 1.0, 1.0]; // 3x speed
    } else if (speed <= 4.0) {
      return [1.0, 1.0, 1.0, 1.0]; // 4x speed
    } else if (speed <= 8.0) {
      return [0.5, 1.0, 1.0, 1.0]; // 8x speed
    } else {
      return [0.25, 0.5, 0.5, 1.0]; // 16x+ speed
    }
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

    // Update address
    _getAddress(currentPosition).then((address) {
      emit(state.copyWith(currentAddress: address));
    });

    // Animate marker if index changed or if not playing (for seek operations)
    if (_lastAnimatedIndex != currentIndex) {
      _lastAnimatedIndex = currentIndex;

      // For playing state, animate from current animated position to next position
      // For non-playing state (seek), immediately set position
      if (state.isPlaying && state.animatedMarkerPosition != null) {
        // Calculate distance-based duration for smoother movement
        final distance = _calculateDistance(
          state.animatedMarkerPosition!,
          currentPosition,
        );

        // Only animate if distance is significant to avoid unnecessary animations
        if (distance > 0.001) {
          // More than 1 meter
          final int durationMs = _getAnimationDuration(distance);
          _animateMarker(
            state.animatedMarkerPosition!,
            currentPosition,
            durationMs: durationMs,
          );
        } else {
          // For very short distances, set position immediately and continue
          emit(state.copyWith(animatedMarkerPosition: currentPosition));
          if (state.isPlaying) {
            _startAnimationSequence();
          }
        }
      } else {
        // For seek operations or when not playing, set position immediately
        // Ensure exact GPS point positioning
        emit(state.copyWith(animatedMarkerPosition: currentPosition));
      }
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

    // Update address
    _getAddress(currentPosition).then((address) {
      emit(state.copyWith(currentAddress: address));
    });

    // Animate marker if index changed or if not playing (for seek operations)
    if (_lastAnimatedIndex != currentIndex) {
      _lastAnimatedIndex = currentIndex;

      // For playing state, animate from current animated position to next position
      // For non-playing state (seek), immediately set position
      if (state.isPlaying && state.animatedMarkerPosition != null) {
        // Calculate distance-based duration for smoother movement
        final distance = _calculateDistance(
          state.animatedMarkerPosition!,
          currentPosition,
        );

        // Only animate if distance is significant to avoid unnecessary animations
        if (distance > 0.001) {
          // More than 1 meter
          final int durationMs = _getAnimationDuration(distance);
          _animateMarker(
            state.animatedMarkerPosition!,
            currentPosition,
            durationMs: durationMs,
          );
        } else {
          // For very short distances, set position immediately and continue
          emit(state.copyWith(animatedMarkerPosition: currentPosition));
          if (state.isPlaying) {
            _startAnimationSequence();
          }
        }
      } else {
        // For seek operations or when not playing, set position immediately
        // Ensure exact GPS point positioning
        emit(state.copyWith(animatedMarkerPosition: currentPosition));
      }
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

      // Reset bearing for new path
      _lastBearing = null;

      if (pathPositions.isNotEmpty) {
        if (isDailyPath) {
          // For daily path, just fit to path without starting animation
          _getPathBoundsForRegularPath();
        } else {
          // For regular path replay, initialize animated position and start with first position
          final firstPosition = LatLng(
            pathPositions.first.latitude!,
            pathPositions.first.longitude!,
          );
          // Ensure exact GPS point positioning from the start
          emit(state.copyWith(animatedMarkerPosition: firstPosition));
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

      // Reset bearing for new path
      _lastBearing = null;

      if (tripPathPositions.isNotEmpty) {
        // For ignition path, initialize animated position and fit to path
        final firstPosition = LatLng(
          tripPathPositions.first.latitude!,
          tripPathPositions.first.longitude!,
        );
        // Ensure exact GPS point positioning from the start
        emit(state.copyWith(animatedMarkerPosition: firstPosition));
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

    // Initialize animated position if not set
    if (state.animatedMarkerPosition == null) {
      final pathPoints =
          state.pathType == 'ignition'
              ? state.tripPathPositions
                  .map((pos) => LatLng(pos.latitude!, pos.longitude!))
                  .toList()
              : state.pathPositions
                  .map((pos) => LatLng(pos.latitude!, pos.longitude!))
                  .toList();

      if (pathPoints.isNotEmpty) {
        final currentIndex = state.currentIndex.clamp(0, pathPoints.length - 1);
        emit(state.copyWith(animatedMarkerPosition: pathPoints[currentIndex]));
      }
    }

    // Start the animation sequence like native Android
    _startAnimationSequence();
  }

  void pause() {
    _playbackTimer?.cancel();
    _markerAnimationTimer?.cancel();
    emit(state.copyWith(isPlaying: false));
  }

  // Animation sequence like native Android (recursive approach)
  void _startAnimationSequence() {
    final maxIndex =
        state.pathType == 'ignition'
            ? state.tripPathPositions.length - 1
            : state.pathPositions.length - 1;

    if (state.currentIndex < maxIndex) {
      // Move to next position
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
      _updateAddressAndAnimation();
    } else {
      // Animation complete
      pause();
    }
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

    final newBearing = _calculateSmoothBearing(
      pathPoints[state.currentIndex - 1],
      pathPoints[state.currentIndex],
      _lastBearing,
    );

    _lastBearing = newBearing;
    return newBearing;
  }

  double _getCurrentRotationForTripPath() {
    if (state.tripPathPositions.isEmpty || state.currentIndex <= 0) return 0;

    final pathPoints =
        state.tripPathPositions
            .map((pos) => LatLng(pos.latitude!, pos.longitude!))
            .toList();

    if (state.currentIndex >= pathPoints.length) return 0;

    final newBearing = _calculateSmoothBearing(
      pathPoints[state.currentIndex - 1],
      pathPoints[state.currentIndex],
      _lastBearing,
    );

    _lastBearing = newBearing;
    return newBearing;
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
