import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_vehicle_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_checkout_vehicle_event.dart';
import 'kavach_checkout_vehicle_state.dart';

class KavachCheckoutVehicleBloc extends Bloc<KavachCheckoutVehicleEvent, KavachCheckoutVehicleState> {
  final KavachRepository repository;

  KavachCheckoutVehicleBloc(this.repository) : super(KavachCheckoutVehicleInitial()) {
    on<FetchKavachVehicles>(_onFetchVehicles);
  }

  Future<void> _onFetchVehicles(FetchKavachVehicles event, Emitter<KavachCheckoutVehicleState> emit) async {
    emit(KavachCheckoutVehicleLoading());

    final result = await repository.fetchVehicles();
    if (result is Success<List<KavachVehicleModel>>) {
      emit(KavachCheckoutVehicleLoaded(result.value));
    } else if (result is Error<List<KavachVehicleModel>>) {
      emit(KavachCheckoutVehicleError(result.type));
    }
  }
}
