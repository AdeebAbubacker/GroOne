import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/kavach/model/kavach_address_model.dart';

// Events
abstract class GpsBillingAddressEvent {}

class FetchGpsBillingAddresses extends GpsBillingAddressEvent {
  final int customerId;

  FetchGpsBillingAddresses({this.customerId = 851}); // Default customer ID
}

class SelectGpsBillingAddress extends GpsBillingAddressEvent {
  final KavachAddressModel address;

  SelectGpsBillingAddress(this.address);
}

class ClearGpsBillingAddress extends GpsBillingAddressEvent {}

// States
abstract class GpsBillingAddressState {}

class GpsBillingAddressInitial extends GpsBillingAddressState {}

class GpsBillingAddressLoading extends GpsBillingAddressState {}

class GpsBillingAddressLoaded extends GpsBillingAddressState {
  final List<KavachAddressModel> addresses;

  GpsBillingAddressLoaded(this.addresses);
}

class GpsBillingAddressSelected extends GpsBillingAddressState {
  final KavachAddressModel selectedAddress;

  GpsBillingAddressSelected(this.selectedAddress);
}

class GpsBillingAddressEmpty extends GpsBillingAddressState {}

class GpsBillingAddressError extends GpsBillingAddressState {
  final String message;

  GpsBillingAddressError(this.message);
}

// Cubit
class GpsBillingAddressCubit extends Cubit<GpsBillingAddressState> {
  final GpsOrderApiRepository _repository;

  GpsBillingAddressCubit(this._repository) : super(GpsBillingAddressInitial());

  Future<void> fetchGpsBillingAddresses({int customerId = 851}) async {
    emit(GpsBillingAddressLoading());

    final result = await _repository.fetchGpsAddresses(customerId: customerId);

    if (result is Success<GpsAddressListResponse>) {
      final response = result.value;
      if (response.success && response.data != null) {
        final addresses = response.data!.rows
            .map((gpsAddress) => gpsAddress.toKavachAddressModel())
            .toList();

        if (addresses.isNotEmpty) {
          emit(GpsBillingAddressLoaded(addresses));
        } else {
          emit(GpsBillingAddressEmpty());
        }
      } else {
        emit(GpsBillingAddressError(response.message));
      }
    } else if (result is Error<GpsAddressListResponse>) {
      emit(GpsBillingAddressError(result.type.toString()));
    } else {
      emit(GpsBillingAddressError('Unknown error occurred'));
    }
  }

  void selectGpsBillingAddress(KavachAddressModel address) {
    emit(GpsBillingAddressSelected(address));
  }

  void clearGpsBillingAddress() {
    emit(GpsBillingAddressEmpty());
  }
} 