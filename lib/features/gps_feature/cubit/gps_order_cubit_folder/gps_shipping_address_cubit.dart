import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/kavach/model/kavach_address_model.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';

// Events
abstract class GpsShippingAddressEvent {}

class FetchGpsShippingAddresses extends GpsShippingAddressEvent {
  final String? customerId;

  FetchGpsShippingAddresses({this.customerId}); // Remove static customer ID
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

class GpsShippingAddressAvailable extends GpsShippingAddressState {
  final List<KavachAddressModel> addresses;

  GpsShippingAddressAvailable(this.addresses);
}

class GpsShippingAddressSelected extends GpsShippingAddressState {
  final KavachAddressModel selectedAddress;
  final List<KavachAddressModel> addresses;

  GpsShippingAddressSelected({required this.selectedAddress, required this.addresses});
}

class GpsShippingAddressEmpty extends GpsShippingAddressState {}

class GpsShippingAddressError extends GpsShippingAddressState {
  final String message;

  GpsShippingAddressError(this.message);
}

// Cubit
class GpsShippingAddressCubit extends Cubit<GpsShippingAddressState> {
  final GpsOrderApiRepository _repository;
  final UserInformationRepository _userRepository;

  GpsShippingAddressCubit(this._repository, this._userRepository) : super(GpsShippingAddressInitial());

  Future<void> fetchGpsShippingAddresses() async {
    emit(GpsShippingAddressLoading());
    try {
      final customerId = await _userRepository.getUserID();
      if (customerId == null || customerId.isEmpty) {
        emit(GpsShippingAddressError('Unable to get customer ID'));
        return;
      }

      final result = await _repository.fetchGpsAddresses(
        customerId: customerId,
        limit: 10,
        page: 1,
      );

      if (result is Success<GpsAddressListResponse>) {
        final rows = result.value.data?.rows ?? [];
        if (rows.isNotEmpty) {
          final addresses = rows.map((gpsAddress) => gpsAddress.toKavachAddressModel()).toList();
          // Auto-select first address
          emit(GpsShippingAddressSelected(
            selectedAddress: addresses.first,
            addresses: addresses,
          ));
        } else {
          emit(GpsShippingAddressEmpty());
        }
      } else if (result is Error<GpsAddressListResponse>) {
        emit(GpsShippingAddressError(result.type.toString()));
      }
    } catch (e) {
      emit(GpsShippingAddressError(e.toString()));
    }
  }

  void selectGpsShippingAddress(KavachAddressModel address) {
    // Get current addresses from state
    List<KavachAddressModel> addresses = [];
    if (state is GpsShippingAddressAvailable) {
      addresses = (state as GpsShippingAddressAvailable).addresses;
      CustomLog.debug(this, "GPS Shipping - Selecting address from Available state with ${addresses.length} addresses");
    } else if (state is GpsShippingAddressSelected) {
      addresses = (state as GpsShippingAddressSelected).addresses;
      CustomLog.debug(this, "GPS Shipping - Selecting address from Selected state with ${addresses.length} addresses");
    }
    
    // If no addresses are available, fetch them first
    if (addresses.isEmpty) {
      CustomLog.debug(this, "GPS Shipping - No addresses available, fetching addresses first");
      fetchGpsShippingAddresses().then((_) {
        // After fetching, try to select the address again
        if (state is GpsShippingAddressAvailable) {
          final loadedAddresses = (state as GpsShippingAddressAvailable).addresses;
          CustomLog.debug(this, "GPS Shipping - Fetched ${loadedAddresses.length} addresses, now selecting");
          emit(GpsShippingAddressSelected(selectedAddress: address, addresses: loadedAddresses));
        }
      });
      return;
    }
    
    CustomLog.debug(this, "GPS Shipping - Emitting selected state with ${addresses.length} addresses");
    emit(GpsShippingAddressSelected(selectedAddress: address, addresses: addresses));
  }

  void clearGpsShippingAddress() {
    emit(GpsShippingAddressEmpty());
  }

  void clearGpsShippingAddressSelection() {
    // If we have selected addresses, go back to available state without selection
    if (state is GpsShippingAddressSelected) {
      final addresses = (state as GpsShippingAddressSelected).addresses;
      emit(GpsShippingAddressAvailable(addresses));
    }
    // If we're in available state, stay there (no selection)
    // If we're in empty/error state, stay there
  }
} 