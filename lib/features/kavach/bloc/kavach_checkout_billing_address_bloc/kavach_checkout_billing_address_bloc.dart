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

  Future<void> _onFetchBillingAddresses(
      FetchKavachBillingAddresses event,
      Emitter<KavachCheckoutBillingAddressState> emit,
      ) async {
    KavachAddressModel? currentlySelectedAddress;
    if (state is KavachCheckoutBillingAddressSelected) {
      currentlySelectedAddress =
          (state as KavachCheckoutBillingAddressSelected).selectedAddress;
    }

    emit(KavachCheckoutBillingAddressLoading());
    final result = await repository.fetchAddresses();

    if (result is Success<List<KavachAddressModel>>) {
      final addresses = result.value;

      if (addresses.isEmpty) {
        emit(KavachCheckoutBillingAddressEmpty());
        return;
      }

      // 1️⃣ If there was a previous selection, keep it
      if (currentlySelectedAddress != null) {
        final addressExists = addresses.any(
              (address) => address.uniqueId == currentlySelectedAddress!.uniqueId,
        );
        if (addressExists) {
          emit(KavachCheckoutBillingAddressSelected(
            selectedAddress: currentlySelectedAddress,
            addresses: addresses,
          ));
          return;
        }
      }

      // 2️⃣ Otherwise auto-select first address
      emit(KavachCheckoutBillingAddressSelected(
        selectedAddress: addresses.first,
        addresses: addresses,
      ));
    } else if (result is Error<List<KavachAddressModel>>) {
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
