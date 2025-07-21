import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/model/result.dart';
import '../../models/gps_notification_model.dart';
import '../../repository/gps_repository.dart';

part 'gps_notification_state.dart';

class GpsNotificationCubit extends Cubit<GpsNotificationState> {
  final GpsRepository _repository;

  GpsNotificationCubit(this._repository) : super(GpsNotificationInitial());

  Future<void> loadNotifications() async {
    emit(GpsNotificationLoading());
    final result = await _repository.fetchNotifications();
    if (result is Success<List<GpsNotificationModel>>) {
      emit(GpsNotificationLoaded(result.value));
    } else if (result is Error<List<GpsNotificationModel>>) {
      emit(GpsNotificationError(result.type.toString()));
    }
  }
}
