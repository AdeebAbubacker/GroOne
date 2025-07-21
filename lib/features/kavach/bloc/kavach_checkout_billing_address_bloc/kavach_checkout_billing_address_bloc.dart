import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_address_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_checkout_billing_address_event.dart';
import 'kavach_checkout_billing_address_state.dart';

class KavachCheckoutBillingAddressBloc extends Bloc<KavachCheckoutBillingAddressEvent, KavachCheckoutBillingAddressState> {
  final KavachRepository repository;

  KavachCheckoutBillingAddressBloc(this.repository) : super(KavachCheckoutBillingAddressLoading()) {
    on<FetchKavachBillingAddresses>(_onFetchBillingAddresses);
    on<SelectKavachBillingAddress>(_onSelectBillingAddress);
    on<RestoreKavachBillingAddress>(_onRestoreBillingAddress);
    on<ClearKavachBillingAddress>((event, emit) {
      emit(KavachCheckoutBillingAddressEmpty());
    });

  }

  Future<void> _onFetchBillingAddresses(FetchKavachBillingAddresses event, Emitter<KavachCheckoutBillingAddressState> emit) async {
    // Store the currently selected address before fetching
    KavachAddressModel? currentlySelectedAddress;
    if (state is KavachCheckoutBillingAddressSelected) {
      currentlySelectedAddress = (state as KavachCheckoutBillingAddressSelected).selectedAddress;
    }
    
    emit(KavachCheckoutBillingAddressLoading());
    final result = await repository.fetchAddresses();

    if (result is Success<List<KavachAddressModel>>) {
      print('KavachCheckoutBillingAddressBloc: Successfully fetched ${result.value.length} addresses');
      if (result.value.isEmpty) {
        print('KavachCheckoutBillingAddressBloc: No addresses found, emitting empty state');
        emit(KavachCheckoutBillingAddressEmpty());
      } else {
        // Check if the previously selected address still exists in the new list
        if (currentlySelectedAddress != null) {
          final addressExists = result.value.any((address) => address.uniqueId == currentlySelectedAddress!.uniqueId);
          if (addressExists) {
            // Restore the previously selected address
            print('KavachCheckoutBillingAddressBloc: Restoring previously selected address');
            emit(KavachCheckoutBillingAddressSelected(
              selectedAddress: currentlySelectedAddress,
              addresses: result.value,
            ));
          } else {
            // Previously selected address no longer exists, show available state
            print('KavachCheckoutBillingAddressBloc: Previously selected address no longer exists, emitting available state');
            emit(KavachCheckoutBillingAddressAvailable(addresses: result.value));
          }
        } else {
          // No previously selected address, show available state
          print('KavachCheckoutBillingAddressBloc: Emitting available state with ${result.value.length} addresses');
          emit(KavachCheckoutBillingAddressAvailable(addresses: result.value));
        }
      }
    } else if (result is Error<List<KavachAddressModel>>) {
      print('KavachCheckoutBillingAddressBloc: Error fetching addresses: ${result.type}');
      emit(KavachCheckoutBillingAddressError(result.type));
    }
  }

  // void _onSelectBillingAddress(SelectKavachBillingAddress event, Emitter<KavachCheckoutBillingAddressState> emit) {
  //   final currentState = state;
  //   if (currentState is KavachCheckoutBillingAddressSelected) {
  //     emit(KavachCheckoutBillingAddressSelected(
  //       selectedAddress: event.address,
  //       addresses: currentState.addresses,
  //     ));
  //   }
  // }
  void _onSelectBillingAddress(SelectKavachBillingAddress event, Emitter<KavachCheckoutBillingAddressState> emit) {
    final currentState = state;

    if (currentState is KavachCheckoutBillingAddressSelected) {
      emit(KavachCheckoutBillingAddressSelected(
        selectedAddress: event.address,
        addresses: currentState.addresses,
      ));
    } else if (currentState is KavachCheckoutBillingAddressAvailable) {
      emit(KavachCheckoutBillingAddressSelected(
        selectedAddress: event.address,
        addresses: currentState.addresses,
      ));
    } else if (currentState is KavachCheckoutBillingAddressEmpty) {
      emit(KavachCheckoutBillingAddressSelected(
        selectedAddress: event.address,
        addresses: [event.address],
      ));
    }
  }

  void _onRestoreBillingAddress(RestoreKavachBillingAddress event, Emitter<KavachCheckoutBillingAddressState> emit) {
    emit(KavachCheckoutBillingAddressSelected(
      selectedAddress: event.address,
      addresses: event.addresses,
    ));
  }

}
