import 'package:bloc/bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_add_address_bloc/kavach_checkout_add_address_event.dart';

import '../../../../data/model/result.dart';
import '../../model/kavach_address_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_checkout_add_address_state.dart';

class KavachCheckoutAddAddressBloc extends Bloc<KavachCheckoutAddAddressEvent, KavachCheckoutAddAddressState> {
  final KavachRepository repository;

  KavachCheckoutAddAddressBloc(this.repository)
      : super(KavachCheckoutAddressInitial()) {
    on<AddKavachAddress>((event, emit) async {
      emit(KavachCheckoutAddressLoading());
      final result = await repository.addAddress(event.address);
      if (result is Success<KavachAddressModel>) {
        emit(KavachCheckoutAddressAdded(result.value));
      } else if (result is Error<KavachAddressModel>) {
        final errorMessage = result.type is ErrorWithMessage 
            ? (result.type as ErrorWithMessage).message 
            : "Failed to add address";
        emit(KavachCheckoutAddressError(errorMessage));
      }
    });

  }
}