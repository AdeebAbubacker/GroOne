import 'package:gro_one_app/core/reset_cubit_state.dart';

import 'assign_driver_state.dart';

class AssignDriverCubit extends BaseCubit<AssignDriverState> {
  AssignDriverCubit() : super(AssignDriverState(false));

  acceptLoad() {
    emit(state.copyWith(isLoadAccepted: true));
  }
}
