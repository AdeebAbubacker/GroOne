import 'package:bloc/bloc.dart';
import '../../../../data/model/result.dart';
import '../../../login/repository/user_information_repository.dart';
import '../../model/kavach_address_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_checkout_shipping_address_event.dart';
import 'kavach_checkout_shipping_address_state.dart';

class KavachCheckoutShippingAddressBloc extends Bloc<KavachCheckoutShippingAddressEvent, KavachCheckoutShippingAddressState> {
  final KavachRepository repository;

  KavachCheckoutShippingAddressBloc(this.repository) : super(KavachCheckoutAddressLoading()) {
    on<FetchKavachAddresses>(_onFetchAddresses);
    on<SelectKavachAddress>(_onSelectAddress);
  }

  Future<void> _onFetchAddresses(FetchKavachAddresses event, Emitter<KavachCheckoutShippingAddressState> emit) async {
    emit(KavachCheckoutAddressLoading());
    final result = await repository.fetchAddresses(addrType: 1);

    if (result is Success<List<KavachAddressModel>>) {
      if (result.value.isEmpty) {
        emit(KavachCheckoutAddressEmpty());
      } else {
        final firstAddress = result.value.first;
        emit(KavachCheckoutAddressSelected(selectedAddress: firstAddress, addresses: result.value));
      }
    } else if (result is Error<List<KavachAddressModel>>) {
      emit(KavachCheckoutAddressError(result.type));
    }
  }

  void _onSelectAddress(SelectKavachAddress event, Emitter<KavachCheckoutShippingAddressState> emit) {
    final currentState = state;
    if (currentState is KavachCheckoutAddressSelected) {
      emit(KavachCheckoutAddressSelected(selectedAddress: event.address, addresses: currentState.addresses));
    }
  }
}
