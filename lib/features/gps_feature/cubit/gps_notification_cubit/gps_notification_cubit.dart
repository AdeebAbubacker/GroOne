import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/model/result.dart';
import '../../models/gps_notification_model.dart';
import '../../repository/gps_repository.dart';

part 'gps_notification_state.dart';

class GpsNotificationCubit extends Cubit<GpsNotificationState> {
  final GpsRepository _repository;
  bool _isClosed = false;

  GpsNotificationCubit(this._repository) : super(GpsNotificationInitial());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(GpsNotificationInitial());
  }

  Future<void> loadNotifications() async {
    if (_isClosed) return;
    
    if (!_isClosed) {
      emit(GpsNotificationLoading());
    }
    
    final result = await _repository.fetchNotifications();
    
    if (_isClosed) return;
    
    if (result is Success<List<GpsNotificationModel>>) {
      if (!_isClosed) {
        emit(GpsNotificationLoaded(result.value));
      }
    } else if (result is Error<List<GpsNotificationModel>>) {
      if (!_isClosed) {
        emit(GpsNotificationError(result.type.toString()));
      }
    }
  }
}
