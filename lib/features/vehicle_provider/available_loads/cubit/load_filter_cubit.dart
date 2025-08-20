import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/repository/vp_all_load_repository.dart';

class LoadFilterCubit extends BaseCubit<LoadFilterState>{

  final VpLoadRepository _vpLoadRepository;
  LoadFilterCubit(this._vpLoadRepository):super(LoadFilterState());



}