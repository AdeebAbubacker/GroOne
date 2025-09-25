import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';

part 'driver_home_state.dart';



class DriverHomeCubit extends BaseCubit<DriverHomeState> {

  DriverHomeCubit()
    : super(DriverHomeState());

  /// set is filter applied
  void setIsFilterApplied({required bool value}) {
    emit(state.copyWith(isFilterApplied: value));
  }

}
