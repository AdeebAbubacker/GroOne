import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/kavach/model/kavach_address_model.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/utils/custom_log.dart';

// Events
abstract class GpsBillingAddressEvent {}

class FetchGpsBillingAddresses extends GpsBillingAddressEvent {
  final String? customerId;

  FetchGpsBillingAddresses({this.customerId}); // Remove static customer ID
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
  final List<KavachAddressModel> addresses;

  GpsBillingAddressSelected({required this.selectedAddress, required this.addresses});
}

class GpsBillingAddressEmpty extends GpsBillingAddressState {}

class GpsBillingAddressError extends GpsBillingAddressState {
  final String message;

  GpsBillingAddressError(this.message);
}

// Cubit
class GpsBillingAddressCubit extends Cubit<GpsBillingAddressState> {
  final GpsOrderApiRepository _repository;
  final UserInformationRepository _userRepository;

  GpsBillingAddressCubit(this._repository, this._userRepository) : super(GpsBillingAddressInitial());

  Future<void> fetchGpsBillingAddresses() async {
    emit(GpsBillingAddressLoading());
    try {
      final customerId = await _userRepository.getUserID();
      if (customerId == null || customerId.isEmpty) {
        emit(GpsBillingAddressError('Unable to get customer ID'));
        return;
      }
      CustomLog.debug(this, "GPS Billing - Fetching addresses for customer: $customerId");
      
      final result = await _repository.fetchGpsAddresses(
        customerId: customerId,
        limit: 10,
        page: 1,
        addrType: 2,
      );
      
      if (result is Success<GpsAddressListResponse>) {
        final response = result.value;
        CustomLog.debug(this, "GPS Billing - Addresses fetched successfully: ${response.data?.rows?.length ?? 0} addresses");
        
        if (response.data?.rows != null && response.data!.rows!.isNotEmpty) {
          // Convert GPS addresses to Kavach address models
          final addresses = response.data!.rows!
              .map((gpsAddress) => gpsAddress.toKavachAddressModel())
              .toList();
          emit(GpsBillingAddressLoaded(addresses));
        } else {
          emit(GpsBillingAddressEmpty());
        }
      } else if (result is Error<GpsAddressListResponse>) {
        CustomLog.error(this, "GPS Billing - Failed to fetch addresses: ${result.type}", null);
        emit(GpsBillingAddressError(result.type.toString()));
      }
    } catch (e) {
      CustomLog.error(this, "GPS Billing - Exception while fetching addresses", e);
      emit(GpsBillingAddressError(e.toString()));
    }
  }

  void selectGpsBillingAddress(KavachAddressModel address) {
    // Get current addresses from state
    List<KavachAddressModel> addresses = [];
    if (state is GpsBillingAddressLoaded) {
      addresses = (state as GpsBillingAddressLoaded).addresses;
      CustomLog.debug(this, "GPS Billing - Selecting address from Loaded state with ${addresses.length} addresses");
    } else if (state is GpsBillingAddressSelected) {
      addresses = (state as GpsBillingAddressSelected).addresses;
      CustomLog.debug(this, "GPS Billing - Selecting address from Selected state with ${addresses.length} addresses");
    }
    
    // If no addresses are available, fetch them first
    if (addresses.isEmpty) {
      CustomLog.debug(this, "GPS Billing - No addresses available, fetching addresses first");
      fetchGpsBillingAddresses().then((_) {
        // After fetching, try to select the address again
        if (state is GpsBillingAddressLoaded) {
          final loadedAddresses = (state as GpsBillingAddressLoaded).addresses;
          CustomLog.debug(this, "GPS Billing - Fetched ${loadedAddresses.length} addresses, now selecting");
          emit(GpsBillingAddressSelected(selectedAddress: address, addresses: loadedAddresses));
        }
      });
      return;
    }
    
    CustomLog.debug(this, "GPS Billing - Emitting selected state with ${addresses.length} addresses");
    emit(GpsBillingAddressSelected(selectedAddress: address, addresses: addresses));
  }

  void clearGpsBillingAddress() {
    emit(GpsBillingAddressEmpty());
  }
} 