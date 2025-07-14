import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/result.dart';
import '../../../../data/ui_state/ui_state.dart';

import '../../../../features/login/repository/user_information_repository.dart';
import '../../gps_order_request/gps_order_api_request.dart';
import '../../models/gps_vehicle_models.dart';
import '../../models/gps_truck_length_model.dart';
import '../../models/gps_commodity_model.dart';
import 'gps_vehicle_state.dart';

class GpsVehicleCubit extends Cubit<GpsVehicleState> {
  final GpsOrderApiRequest _apiRequest;
  final UserInformationRepository _userRepository;

  GpsVehicleCubit(this._apiRequest, this._userRepository)
      : super(GpsVehicleState());

  /// Fetch vehicles for the current user
  Future<void> fetchVehicles({int limit = 10, int page = 1}) async {
    print('🔍 GpsVehicleCubit.fetchVehicles called');
    emit(state.copyWith(
      vehicles: UIState.loading(),
    ));

    try {
      final customerId = await _userRepository.getUserID();
      print('🔍 Customer ID from repository in fetchVehicles: $customerId');
      
      if (customerId == null) {
        print('❌ Customer ID is null in fetchVehicles');
        emit(state.copyWith(
          vehicles: UIState.error(GenericError()),
        ));
        return;
      }

      final result = await _apiRequest.getVehicles(
        customerId: customerId,
        limit: limit,
        page: page,
      );

      if (result is Success<GpsVehicleListResponse>) {
        print('✅ getVehicles success: ${result.value.data.length} vehicles');
        print('📋 Vehicles: ${result.value.data.map((v) => v.truckNo).toList()}');
        emit(state.copyWith(
          vehicles: UIState.success(result.value.data),
        ));
      } else {
        print('❌ getVehicles failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        emit(state.copyWith(
          vehicles: UIState.error(GenericError()),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        vehicles: UIState.error(GenericError()),
      ));
    }
  }

  /// Add a new vehicle
  Future<Result<bool>> addVehicle(GpsAddVehicleRequest request) async {
    emit(state.copyWith(
      addVehicle: UIState.loading(),
    ));

    try {
      final result = await _apiRequest.addVehicle(request: request);

      if (result is Success<GpsAddVehicleResponse>) {
        emit(state.copyWith(
          addVehicle: UIState.success(result.value),
        ));
        // Refresh the vehicle list after adding
        await fetchVehicles();
        return Success(true);
      } else {
        emit(state.copyWith(
          addVehicle: UIState.error(GenericError()),
        ));
        return Error(GenericError());
      }
    } catch (e) {
      emit(state.copyWith(
        addVehicle: UIState.error(GenericError()),
      ));
      return Error(GenericError());
    }
  }

  /// Upload document
  Future<Result<String>> uploadDocument(File file) async {
    emit(state.copyWith(
      documentUpload: UIState.loading(),
    ));

    try {
      final userId = await _userRepository.getUserID();
      if (userId == null) {
        emit(state.copyWith(
          documentUpload: UIState.error(ErrorWithMessage(message: 'User ID not found')),
        ));
        return Error(ErrorWithMessage(message: 'User ID not found'));
      }

      final result = await _apiRequest.uploadDocument(file: file, userId: userId);

      if (result is Success<GpsDocumentUploadResponse>) {
        final url = result.value.url;
        emit(state.copyWith(
          documentUpload: UIState.success(result.value),
        ));
        return Success(url);
      } else {
        emit(state.copyWith(
          documentUpload: UIState.error(result is Error ? (result as Error).type : GenericError()),
        ));
        return Error(result is Error ? (result as Error).type : GenericError());
      }
    } catch (e) {
      emit(state.copyWith(
        documentUpload: UIState.error(GenericError()),
      ));
      return Error(GenericError());
    }
  }

  /// Reset add vehicle state
  void resetAddVehicle() {
    emit(state.copyWith(
      addVehicle: UIState.initial(),
    ));
  }

  /// Reset document upload state
  void resetDocumentUpload() {
    emit(state.copyWith(
      documentUpload: UIState.initial(),
    ));
  }

  /// Clear all states
  void clearStates() {
    emit(GpsVehicleState());
  }

  /// Fetch truck types
  Future<void> fetchTruckTypes() async {
    print('🔍 GpsVehicleCubit.fetchTruckTypes called');
    emit(state.copyWith(
      truckTypes: UIState.loading(),
    ));

    try {
      final result = await _apiRequest.fetchTruckTypes();
      print('🔍 Truck Types API result: ${result.runtimeType}');

      if (result is Success<List<String>>) {
        print('✅ Truck Types fetched successfully: ${result.value.length} types');
        print('📋 Truck Types: ${result.value}');
        emit(state.copyWith(
          truckTypes: UIState.success(result.value),
        ));
      } else {
        print('❌ Truck Types fetch failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        emit(state.copyWith(
          truckTypes: UIState.error(result is Error ? (result as Error).type : GenericError()),
        ));
      }
    } catch (e) {
      print('💥 Truck Types fetch exception: $e');
      emit(state.copyWith(
        truckTypes: UIState.error(GenericError()),
      ));
    }
  }

  /// Fetch truck lengths for a specific type
  Future<void> fetchTruckLengths(String type) async {
    print('🔍 GpsVehicleCubit.fetchTruckLengths called with type: $type');
    emit(state.copyWith(
      truckLengths: UIState.loading(),
    ));

    try {
      final result = await _apiRequest.fetchTruckLengths(type);
      print('🔍 Truck Lengths API result: ${result.runtimeType}');

      if (result is Success<List<GpsTruckLengthModel>>) {
        print('✅ Truck Lengths fetched successfully: ${result.value.length} lengths');
        print('📋 Truck Lengths: ${result.value}');
        emit(state.copyWith(
          truckLengths: UIState.success(result.value),
        ));
      } else {
        print('❌ Truck Lengths fetch failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        emit(state.copyWith(
          truckLengths: UIState.error(result is Error ? (result as Error).type : GenericError()),
        ));
      }
    } catch (e) {
      print('💥 Truck Lengths fetch exception: $e');
      emit(state.copyWith(
        truckLengths: UIState.error(GenericError()),
      ));
    }
  }

  /// Fetch commodities
  Future<void> fetchCommodities() async {
    print('🔍 GpsVehicleCubit.fetchCommodities called');
    emit(state.copyWith(
      commodities: UIState.loading(),
    ));

    try {
      final result = await _apiRequest.fetchCommodities();
      print('🔍 Commodities API result: ${result.runtimeType}');

      if (result is Success<List<GpsCommodityModel>>) {
        print('✅ Commodities fetched successfully: ${result.value.length} commodities');
        print('📋 Commodities: ${result.value}');
        emit(state.copyWith(
          commodities: UIState.success(result.value),
        ));
      } else {
        print('❌ Commodities fetch failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        emit(state.copyWith(
          commodities: UIState.error(result is Error ? (result as Error).type : GenericError()),
        ));
      }
    } catch (e) {
      print('💥 Commodities fetch exception: $e');
      emit(state.copyWith(
        commodities: UIState.error(GenericError()),
      ));
    }
  }

  /// Verify vehicle
  Future<void> verifyVehicle(String vehicleNumber) async {
    print('🔍 GpsVehicleCubit.verifyVehicle called with: $vehicleNumber');
    emit(state.copyWith(
      vehicleVerification: UIState.loading(),
    ));

    try {
      final result = await _apiRequest.verifyVehicle(vehicleNumber);
      print('🔍 Vehicle verification API result: ${result.runtimeType}');

      if (result is Success<bool>) {
        print('✅ Vehicle verification result: ${result.value}');
        emit(state.copyWith(
          vehicleVerification: UIState.success(result.value),
        ));
      } else {
        print('❌ Vehicle verification failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        emit(state.copyWith(
          vehicleVerification: UIState.error(result is Error ? (result as Error).type : GenericError()),
        ));
      }
    } catch (e) {
      print('💥 Vehicle verification exception: $e');
      emit(state.copyWith(
        vehicleVerification: UIState.error(GenericError()),
      ));
    }
  }

  /// Reset vehicle verification state
  void resetVehicleVerification() {
    emit(state.copyWith(
      vehicleVerification: UIState.initial(),
    ));
  }
} 