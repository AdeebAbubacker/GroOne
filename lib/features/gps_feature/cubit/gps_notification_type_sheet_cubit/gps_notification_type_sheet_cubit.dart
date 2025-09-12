import 'package:bloc/bloc.dart';

import '../../../../data/model/result.dart';
import '../../repository/gps_repository.dart';
import 'gps_notification_type_sheet_state.dart';

class GpsNotificationTypesSheetCubit extends Cubit<GpsNotificationTypesSheetState> {
  final GpsRepository _repository;

  GpsNotificationTypesSheetCubit(this._repository) : super(GpsNotificationTypesInitial());

  Future<void> fetchNotificationToggles() async {
    if (isClosed) return;
    emit(GpsNotificationTypesLoading());

    final result = await _repository.fetchDeprecatedNotificationStatus();
    if (result is Success<Map<String, dynamic>>) {
      final data = result.value;

      final mappedToggles = <String, bool>{
        "Ignition On": data['notify_ignitionOn'] as bool? ?? false,
        "Ignition Off": data['notify_ignitionOff'] as bool? ?? false,
        "Geo-fence Enter": data['notify_geofenceEnter'] as bool? ?? false,
        "Geo-fence Exit": data['notify_geofenceExit'] as bool? ?? false,
        "Device Over-speed": data['notify_overspeed'] as bool? ?? false,
        "Low Battery": data['notify_lowBattery'] as bool? ?? false,
        "Power-Cut": data['notify_powerCut'] as bool? ?? false,
        "Power Restored": data['notify_powerRestored'] as bool? ?? false,
        "Vibration": data['notify_vibration'] as bool? ?? false,
        "SOS": data['notify_sos'] as bool? ?? false,
        "AC/Door On": data['notify_powerOn'] as bool? ?? false,
        "AC/Door Off": data['notify_powerOff'] as bool? ?? false,
        "Tow": data['notify_tow'] as bool? ?? false,
      };

      if (!isClosed) emit(GpsNotificationTypesLoaded(mappedToggles));
    } else {
      if (!isClosed) emit(GpsNotificationTypesError("Failed to load toggles"));
    }
  }


  Future<void> updateToggle(String key, bool value) async {
    if (isClosed) return;

    // Get current state
    final currentState = state;
    if (currentState is! GpsNotificationTypesLoaded) return;

    // Optimistically update the toggle
    final updatedToggles = Map<String, bool>.from(currentState.toggles);
    updatedToggles[key] = value;
    emit(GpsNotificationTypesLoaded(updatedToggles)); // No loading spinner

    // Prepare request body
    final fieldMap = {
      "Ignition On": "notify_ignitionOn",
      "Ignition Off": "notify_ignitionOff",
      "Geo-fence Enter": "notify_geofenceEnter",
      "Geo-fence Exit": "notify_geofenceExit",
      "Device Over-speed": "notify_overspeed",
      "Low Battery": "notify_lowBattery",
      "Power-Cut": "notify_powerCut",
      "Power Restored": "notify_powerRestored",
      "Vibration": "notify_vibration",
      "SOS": "notify_sos",
      "AC/Door On": "notify_powerOn",
      "AC/Door Off": "notify_powerOff",
      "Tow": "notify_tow",
    };

    final paramKey = fieldMap[key];
    if (paramKey == null) return;

    final result = await _repository.updateDeprecatedNotificationStatus({
      paramKey: value,
    });

    if (isClosed) return;

    if (result is! Success) {
      // Revert the toggle on error
      updatedToggles[key] = !value;
      emit(GpsNotificationTypesLoaded(updatedToggles));

      // Optionally show an error message using a snackbar/toast
      emit(GpsNotificationTypesError("Failed to update toggle"));
      emit(GpsNotificationTypesLoaded(updatedToggles)); // Recover gracefully
    }
  }

// Future<void> updateToggle(String key, bool value) async {
  //   if (isClosed) return; // ✅ avoid emit on closed cubit
  //   emit(GpsNotificationTypesLoading());
  //
  //   final fieldMap = {
  //     "Ignition On": "notify_ignitionOn",
  //     "Ignition Off": "notify_ignitionOff",
  //     "Geo-fence Enter": "notify_geofenceEnter",
  //     "Geo-fence Exit": "notify_geofenceExit",
  //     "Device Over-speed": "notify_overspeed",
  //     "Low Battery": "notify_lowBattery",
  //     "Power-Cut": "notify_powerCut",
  //     "Power Restored": "notify_powerRestored",
  //     "Vibration": "notify_vibration",
  //     "SOS": "notify_sos",
  //     "AC/Door On": "notify_powerOn",
  //     "AC/Door Off": "notify_powerOff",
  //     "Tow": "notify_tow",
  //   };
  //
  //   final paramKey = fieldMap[key];
  //   if (paramKey == null) return;
  //
  //   final result = await _repository.updateDeprecatedNotificationStatus({
  //     paramKey: value,
  //   });
  //
  //   if (isClosed) return; // ✅ re-check after async call
  //
  //   if (result is Success) {
  //     await fetchNotificationToggles();
  //   } else {
  //     emit(GpsNotificationTypesError("Failed to update toggle"));
  //   }
  // }

}
