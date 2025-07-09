import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/kavach/model/kavach_address_model.dart';

// Events
abstract class GpsShippingAddressEvent {}

class FetchGpsShippingAddresses extends GpsShippingAddressEvent {
  final int customerId;

  FetchGpsShippingAddresses({this.customerId = 851}); // Default customer ID
}

class SelectGpsShippingAddress extends GpsShippingAddressEvent {
  final KavachAddressModel address;

  SelectGpsShippingAddress(this.address);
}

class ClearGpsShippingAddress extends GpsShippingAddressEvent {}

// States
abstract class GpsShippingAddressState {}

class GpsShippingAddressInitial extends GpsShippingAddressState {}

class GpsShippingAddressLoading extends GpsShippingAddressState {}

class GpsShippingAddressLoaded extends GpsShippingAddressState {
  final List<KavachAddressModel> addresses;

  GpsShippingAddressLoaded(this.addresses);
}

class GpsShippingAddressSelected extends GpsShippingAddressState {
  final KavachAddressModel selectedAddress;

  GpsShippingAddressSelected(this.selectedAddress);
}

class GpsShippingAddressEmpty extends GpsShippingAddressState {}

class GpsShippingAddressError extends GpsShippingAddressState {
  final String message;

  GpsShippingAddressError(this.message);
}

// Cubit
class GpsShippingAddressCubit extends Cubit<GpsShippingAddressState> {
  final GpsOrderApiRepository _repository;

  GpsShippingAddressCubit(this._repository) : super(GpsShippingAddressInitial());

  Future<void> fetchGpsShippingAddresses({int customerId = 851}) async {
    emit(GpsShippingAddressLoading());

    final result = await _repository.fetchGpsAddresses(customerId: customerId);

    if (result is Success<GpsAddressListResponse>) {
      final response = result.value;
      if (response.success && response.data != null) {
        final addresses = response.data!.rows
            .map((gpsAddress) => gpsAddress.toKavachAddressModel())
            .toList();

        if (addresses.isNotEmpty) {
          emit(GpsShippingAddressLoaded(addresses));
        } else {
          emit(GpsShippingAddressEmpty());
        }
      } else {
        emit(GpsShippingAddressError(response.message));
      }
    } else if (result is Error<GpsAddressListResponse>) {
      emit(GpsShippingAddressError(result.type.toString()));
    } else {
      emit(GpsShippingAddressError('Unknown error occurred'));
    }
  }

  void selectGpsShippingAddress(KavachAddressModel address) {
    emit(GpsShippingAddressSelected(address));
  }

  void clearGpsShippingAddress() {
    emit(GpsShippingAddressEmpty());
  }
} 