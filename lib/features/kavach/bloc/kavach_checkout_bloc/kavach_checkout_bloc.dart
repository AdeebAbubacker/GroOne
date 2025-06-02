import 'package:bloc/bloc.dart';
import 'package:gro_one_app/features/kavach/repository/kavach_repository.dart';
import '../../../../data/model/result.dart';
import '../../../login/repository/user_information_repository.dart';
import '../../model/kavach_address_model.dart';
import '../../model/kavach_vehicle_model.dart';
import 'kavach_checkout_event.dart';
import 'kavach_checkout_state.dart';

class KavachCheckoutBloc extends Bloc<KavachCheckoutEvent, KavachCheckoutState> {
  final KavachRepository repository;
  final UserInformationRepository _userInformationRepository;

  KavachCheckoutBloc(this.repository, this._userInformationRepository) : super(VehicleInitial()) {
    on<FetchVehicles>(_onFetch);
    on<FetchAddresses>(_onFetchAddresses);
    on<SelectAddress>((event, emit) {
      if (state is AddressLoaded || state is AddressSelected) {
        final addresses = state is AddressLoaded
            ? (state as AddressLoaded).addresses
            : (state as AddressSelected).addresses;

        emit(AddressSelected(selectedAddress: event.address, addresses: addresses));
      }
    });
  }

  Future<void> _onFetch(FetchVehicles event, Emitter<KavachCheckoutState> emit) async {
    emit(VehicleLoading());

    final result = await repository.fetchVehicles(await _userInformationRepository.getUserID()??'');

    if (result is Success<List<KavachVehicleModel>>) {
      emit(VehicleLoaded(result.value));
    }

    if (result is Error<List<KavachVehicleModel>>) {
      emit(VehicleError(result.type));
    }
  }

  // Future<void> _onFetchAddresses(FetchAddresses event, Emitter<KavachCheckoutState> emit) async {
  //   emit(AddressLoading());
  //   final customerId = await _userInformationRepository.getUserID() ?? '';
  //   final result = await repository.fetchAddresses(customerId, addrType: 1);
  //
  //   if (result is Success<List<KavachAddressModel>>) {
  //     if (result.value.isEmpty) {
  //       emit(AddressEmpty());
  //     } else {
  //       emit(AddressLoaded(result.value));
  //     }
  //   }
  //   if (result is Error<List<KavachAddressModel>>) {
  //     emit(AddressError(result.type));
  //   }
  // }
  Future<void> _onFetchAddresses(FetchAddresses event, Emitter<KavachCheckoutState> emit) async {
    emit(AddressLoading());
    final customerId = await _userInformationRepository.getUserID() ?? '';
    final result = await repository.fetchAddresses(customerId, addrType: 1);

    if (result is Success<List<KavachAddressModel>>) {
      if (result.value.isEmpty) {
        emit(AddressEmpty());
      } else {
        final firstAddress = result.value.first;
        emit(AddressSelected(selectedAddress: firstAddress, addresses: result.value));
      }
    } else if (result is Error<List<KavachAddressModel>>) {
      emit(AddressError(result.type));
    }
  }

}
