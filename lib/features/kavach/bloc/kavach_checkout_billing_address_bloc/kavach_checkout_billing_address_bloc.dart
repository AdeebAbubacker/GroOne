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
    on<ClearKavachBillingAddress>((event, emit) {
      emit(KavachCheckoutBillingAddressEmpty());
    });

  }

  Future<void> _onFetchBillingAddresses(FetchKavachBillingAddresses event, Emitter<KavachCheckoutBillingAddressState> emit) async {
    emit(KavachCheckoutBillingAddressLoading());
    final result = await repository.fetchAddresses(addrType: 2);

    if (result is Success<List<KavachAddressModel>>) {
      if (result.value.isEmpty) {
        emit(KavachCheckoutBillingAddressEmpty());
      } else {
        // Don't auto-select the first address, let user choose
        emit(KavachCheckoutBillingAddressAvailable(addresses: result.value));
      }
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

}
