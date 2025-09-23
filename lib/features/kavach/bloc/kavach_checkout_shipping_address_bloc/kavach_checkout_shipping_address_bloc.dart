import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_address_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_checkout_shipping_address_event.dart';
import 'kavach_checkout_shipping_address_state.dart';

class KavachCheckoutShippingAddressBloc
    extends
        Bloc<
          KavachCheckoutShippingAddressEvent,
          KavachCheckoutShippingAddressState
        > {
  final KavachRepository repository;

  KavachCheckoutShippingAddressBloc(this.repository)
    : super(KavachCheckoutShippingAddressLoading()) {
    on<FetchKavachShippingAddresses>(_onFetchAddresses);
    on<SelectKavachShippingAddress>(_onSelectAddress);
    on<RestoreKavachShippingAddress>(_onRestoreShippingAddress);
    on<ClearKavachShippingAddress>((event, emit) {
      emit(KavachCheckoutShippingAddressEmpty());
    });
  }

  Future<void> _onFetchAddresses(
    FetchKavachShippingAddresses event,
    Emitter<KavachCheckoutShippingAddressState> emit,
  ) async {
    KavachAddressModel? currentlySelectedAddress;
    if (state is KavachCheckoutShippingAddressSelected) {
      currentlySelectedAddress =
          (state as KavachCheckoutShippingAddressSelected).selectedAddress;
    }

    emit(KavachCheckoutShippingAddressLoading());
    final result = await repository.fetchAddresses();

    if (result is Success<List<KavachAddressModel>>) {
      final addresses = result.value;

      if (addresses.isEmpty) {
        emit(KavachCheckoutShippingAddressEmpty());
        return;
      }

      // ✅ Keep previous selection if still valid
      if (currentlySelectedAddress != null) {
        final addressExists = addresses.any(
          (address) => address.uniqueId == currentlySelectedAddress!.uniqueId,
        );
        if (addressExists) {
          emit(
            KavachCheckoutShippingAddressSelected(
              selectedAddress:
                  event.noRefresh ? null : currentlySelectedAddress,
              addresses: addresses,
            ),
          );
          return;
        }
      }

      // ✅ No previous selection — auto-select first address
      if (event.mandatoryRefresh) {
        emit(
          KavachCheckoutShippingAddressSelected(
            selectedAddress: addresses.first,
            addresses: addresses,
          ),
        );
      } else {
        emit(
          KavachCheckoutShippingAddressSelected(
            selectedAddress:
                addresses.length == 1 || event.noRefresh
                    ? null
                    : addresses.length > 1
                    ? addresses[1]
                    : null,
            addresses: addresses,
          ),
        );
      }
    } else if (result is Error<List<KavachAddressModel>>) {
      emit(KavachCheckoutShippingAddressError(result.type));
    }
  }

  void _onSelectAddress(
    SelectKavachShippingAddress event,
    Emitter<KavachCheckoutShippingAddressState> emit,
  ) {
    final currentState = state;

    if (currentState is KavachCheckoutShippingAddressSelected) {
      emit(
        KavachCheckoutShippingAddressSelected(
          selectedAddress: event.address,
          addresses: currentState.addresses,
        ),
      );
    } else if (currentState is KavachCheckoutShippingAddressAvailable) {
      emit(
        KavachCheckoutShippingAddressSelected(
          selectedAddress: event.address,
          addresses: currentState.addresses,
        ),
      );
    } else if (currentState is KavachCheckoutShippingAddressEmpty) {
      emit(
        KavachCheckoutShippingAddressSelected(
          selectedAddress: event.address,
          addresses: [event.address],
        ),
      );
    }
  }

  void _onRestoreShippingAddress(
    RestoreKavachShippingAddress event,
    Emitter<KavachCheckoutShippingAddressState> emit,
  ) {
    emit(
      KavachCheckoutShippingAddressSelected(
        selectedAddress: event.address,
        addresses: event.addresses,
      ),
    );
  }
}
