import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_address_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_checkout_shipping_address_event.dart';
import 'kavach_checkout_shipping_address_state.dart';

class KavachCheckoutShippingAddressBloc extends Bloc<KavachCheckoutShippingAddressEvent, KavachCheckoutShippingAddressState> {
  final KavachRepository repository;

  KavachCheckoutShippingAddressBloc(this.repository) : super(KavachCheckoutShippingAddressLoading()) {
    on<FetchKavachShippingAddresses>(_onFetchAddresses);
    on<SelectKavachShippingAddress>(_onSelectAddress);
    on<RestoreKavachShippingAddress>(_onRestoreShippingAddress);
    on<ClearKavachShippingAddress>((event, emit) {
      emit(KavachCheckoutShippingAddressEmpty());
    });
  }

  Future<void> _onFetchAddresses(FetchKavachShippingAddresses event, Emitter<KavachCheckoutShippingAddressState> emit) async {
    // Store the currently selected address before fetching
    KavachAddressModel? currentlySelectedAddress;
    if (state is KavachCheckoutShippingAddressSelected) {
      currentlySelectedAddress = (state as KavachCheckoutShippingAddressSelected).selectedAddress;
    }
    
    emit(KavachCheckoutShippingAddressLoading());
    final result = await repository.fetchAddresses();

    if (result is Success<List<KavachAddressModel>>) {
      if (result.value.isEmpty) {
        emit(KavachCheckoutShippingAddressEmpty());
      } else {
        // Check if the previously selected address still exists in the new list
        if (currentlySelectedAddress != null) {
          final addressExists = result.value.any((address) => address.uniqueId == currentlySelectedAddress!.uniqueId);
          if (addressExists) {
            // Restore the previously selected address
            emit(KavachCheckoutShippingAddressSelected(
              selectedAddress: currentlySelectedAddress,
              addresses: result.value,
            ));
          } else {
            // Previously selected address no longer exists, show available state
            emit(KavachCheckoutShippingAddressAvailable(addresses: result.value));
          }
        } else {
          // No previously selected address, show available state without auto-selection
          emit(KavachCheckoutShippingAddressAvailable(addresses: result.value));
        }
      }
    } else if (result is Error<List<KavachAddressModel>>) {
      emit(KavachCheckoutShippingAddressError(result.type));
    }
  }

  void _onSelectAddress(SelectKavachShippingAddress event, Emitter<KavachCheckoutShippingAddressState> emit) {
    final currentState = state;

    if (currentState is KavachCheckoutShippingAddressSelected) {
      emit(KavachCheckoutShippingAddressSelected(
        selectedAddress: event.address,
        addresses: currentState.addresses,
      ));
    } else if (currentState is KavachCheckoutShippingAddressAvailable) {
      emit(KavachCheckoutShippingAddressSelected(
        selectedAddress: event.address,
        addresses: currentState.addresses,
      ));
    } else if (currentState is KavachCheckoutShippingAddressEmpty) {
      emit(KavachCheckoutShippingAddressSelected(
        selectedAddress: event.address,
        addresses: [event.address],
      ));
    }
  }

  void _onRestoreShippingAddress(RestoreKavachShippingAddress event, Emitter<KavachCheckoutShippingAddressState> emit) {
    emit(KavachCheckoutShippingAddressSelected(
      selectedAddress: event.address,
      addresses: event.addresses,
    ));
  }
}
