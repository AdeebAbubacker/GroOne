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
  bool _isClosed = false;

  GpsVehicleCubit(this._apiRequest, this._userRepository)
      : super(GpsVehicleState());

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  /// Reset the cubit state and reopen it for use
  void resetCubit() {
    _isClosed = false;
    emit(GpsVehicleState());
  }

  /// Fetch vehicles for the current user
  Future<void> fetchVehicles({int limit = 10, int page = 1}) async {
    if (_isClosed) return;
    
    print('🔍 GpsVehicleCubit.fetchVehicles called');
    emit(state.copyWith(
      vehicles: UIState.loading(),
    ));

    try {
      final customerId = await _userRepository.getUserID();
      print('🔍 Customer ID from repository in fetchVehicles: $customerId');
      
      if (_isClosed) return;
      
      if (customerId == null) {
        print('❌ Customer ID is null in fetchVehicles');
        if (!_isClosed) {
          emit(state.copyWith(
            vehicles: UIState.error(GenericError()),
          ));
        }
        return;
      }

      final result = await _apiRequest.getVehicles(
        customerId: customerId,
        limit: limit,
        page: page,
      );

      if (_isClosed) return;

      if (result is Success<GpsVehicleListResponse>) {
        print('✅ getVehicles success: ${result.value.data.length} vehicles');
        print('📋 Vehicles: ${result.value.data.map((v) => v.truckNo).toList()}');
        if (!_isClosed) {
          emit(state.copyWith(
            vehicles: UIState.success(result.value.data),
          ));
        }
      } else {
        print('❌ getVehicles failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        if (!_isClosed) {
          emit(state.copyWith(
            vehicles: UIState.error(GenericError()),
          ));
        }
      }
    } catch (e) {
      if (!_isClosed) {
        emit(state.copyWith(
          vehicles: UIState.error(GenericError()),
        ));
      }
    }
  }

  /// Add a new vehicle
  Future<Result<bool>> addVehicle(GpsAddVehicleRequest request) async {
    if (_isClosed) return Error(GenericError());
    
    if (!_isClosed) {
      emit(state.copyWith(
        addVehicle: UIState.loading(),
      ));
    }

    try {
      final result = await _apiRequest.addVehicle(request: request);

      if (_isClosed) return Error(GenericError());

      if (result is Success<GpsAddVehicleResponse>) {
        if (!_isClosed) {
          emit(state.copyWith(
            addVehicle: UIState.success(result.value),
          ));
        }
        // Refresh the vehicle list after adding
        await fetchVehicles();
        return Success(true);
      } else {
        if (!_isClosed) {
          emit(state.copyWith(
            addVehicle: UIState.error(GenericError()),
          ));
        }
        return Error(GenericError());
      }
    } catch (e) {
      if (!_isClosed) {
        emit(state.copyWith(
          addVehicle: UIState.error(GenericError()),
        ));
      }
      return Error(GenericError());
    }
  }

  /// Upload document
  Future<Result<String>> uploadDocument(File file) async {
    if (_isClosed) return Error(GenericError());
    
    if (!_isClosed) {
      emit(state.copyWith(
        documentUpload: UIState.loading(),
      ));
    }

    try {
      final userId = await _userRepository.getUserID();
      if (userId == null) {
        if (!_isClosed) {
          emit(state.copyWith(
            documentUpload: UIState.error(ErrorWithMessage(message: 'User ID not found')),
          ));
        }
        return Error(ErrorWithMessage(message: 'User ID not found'));
      }

      final result = await _apiRequest.uploadDocument(file: file, userId: userId);

      if (_isClosed) return Error(GenericError());

      if (result is Success<GpsDocumentUploadResponse>) {
        final url = result.value.url;
        if (!_isClosed) {
          emit(state.copyWith(
            documentUpload: UIState.success(result.value),
          ));
        }
        return Success(url);
      } else {
        if (!_isClosed) {
          emit(state.copyWith(
            documentUpload: UIState.error(result is Error ? (result as Error).type : GenericError()),
          ));
        }
        return Error(result is Error ? (result as Error).type : GenericError());
      }
    } catch (e) {
      if (!_isClosed) {
        emit(state.copyWith(
          documentUpload: UIState.error(GenericError()),
        ));
      }
      return Error(GenericError());
    }
  }

  /// Reset add vehicle state
  void resetAddVehicle() {
    if (!_isClosed) {
      emit(state.copyWith(
        addVehicle: UIState.initial(),
      ));
    }
  }

  /// Reset document upload state
  void resetDocumentUpload() {
    if (!_isClosed) {
      emit(state.copyWith(
        documentUpload: UIState.initial(),
      ));
    }
  }

  /// Clear all states
  void clearStates() {
    if (!_isClosed) {
      emit(GpsVehicleState());
    }
  }

  /// Fetch truck types
  Future<void> fetchTruckTypes() async {
    if (_isClosed) return;
    
    print('🔍 GpsVehicleCubit.fetchTruckTypes called');
    if (!_isClosed) {
      emit(state.copyWith(
        truckTypes: UIState.loading(),
      ));
    }

    try {
      final result = await _apiRequest.fetchTruckTypes();
      print('🔍 Truck Types API result: ${result.runtimeType}');

      if (_isClosed) return;

      if (result is Success<List<String>>) {
        print('✅ Truck Types fetched successfully: ${result.value.length} types');
        print('📋 Truck Types: ${result.value}');
        if (!_isClosed) {
          emit(state.copyWith(
            truckTypes: UIState.success(result.value),
          ));
        }
      } else {
        print('❌ Truck Types fetch failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        if (!_isClosed) {
          emit(state.copyWith(
            truckTypes: UIState.error(result is Error ? (result as Error).type : GenericError()),
          ));
        }
      }
    } catch (e) {
      print('💥 Truck Types fetch exception: $e');
      if (!_isClosed) {
        emit(state.copyWith(
          truckTypes: UIState.error(GenericError()),
        ));
      }
    }
  }

  /// Fetch truck lengths for a specific type
  Future<void> fetchTruckLengths(String type) async {
    if (_isClosed) return;
    
    print('🔍 GpsVehicleCubit.fetchTruckLengths called with type: $type');
    if (!_isClosed) {
      emit(state.copyWith(
        truckLengths: UIState.loading(),
      ));
    }

    try {
      final result = await _apiRequest.fetchTruckLengths(type);
      print('🔍 Truck Lengths API result: ${result.runtimeType}');

      if (_isClosed) return;

      if (result is Success<List<GpsTruckLengthModel>>) {
        print('✅ Truck Lengths fetched successfully: ${result.value.length} lengths');
        print('📋 Truck Lengths: ${result.value}');
        if (!_isClosed) {
          emit(state.copyWith(
            truckLengths: UIState.success(result.value),
          ));
        }
      } else {
        print('❌ Truck Lengths fetch failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        if (!_isClosed) {
          emit(state.copyWith(
            truckLengths: UIState.error(result is Error ? (result as Error).type : GenericError()),
          ));
        }
      }
    } catch (e) {
      print('💥 Truck Lengths fetch exception: $e');
      if (!_isClosed) {
        emit(state.copyWith(
          truckLengths: UIState.error(GenericError()),
        ));
      }
    }
  }

  /// Fetch commodities
  Future<void> fetchCommodities() async {
    if (_isClosed) return;
    
    print('🔍 GpsVehicleCubit.fetchCommodities called');
    if (!_isClosed) {
      emit(state.copyWith(
        commodities: UIState.loading(),
      ));
    }

    try {
      final result = await _apiRequest.fetchCommodities();
      print('🔍 Commodities API result: ${result.runtimeType}');

      if (_isClosed) return;

      if (result is Success<List<GpsCommodityModel>>) {
        print('✅ Commodities fetched successfully: ${result.value.length} commodities');
        print('📋 Commodities: ${result.value}');
        if (!_isClosed) {
          emit(state.copyWith(
            commodities: UIState.success(result.value),
          ));
        }
      } else {
        print('❌ Commodities fetch failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        if (!_isClosed) {
          emit(state.copyWith(
            commodities: UIState.error(result is Error ? (result as Error).type : GenericError()),
          ));
        }
      }
    } catch (e) {
      print('💥 Commodities fetch exception: $e');
      if (!_isClosed) {
        emit(state.copyWith(
          commodities: UIState.error(GenericError()),
        ));
      }
    }
  }

  /// Verify vehicle
  Future<void> verifyVehicle(String vehicleNumber) async {
    if (_isClosed) return;
    
    print('🔍 GpsVehicleCubit.verifyVehicle called with: $vehicleNumber');
    if (!_isClosed) {
      emit(state.copyWith(
        vehicleVerification: UIState.loading(),
      ));
    }

    try {
      final result = await _apiRequest.verifyVehicle(vehicleNumber);
      print('🔍 Vehicle verification API result: ${result.runtimeType}');

      if (_isClosed) return;

      if (result is Success<bool>) {
        print('✅ Vehicle verification result: ${result.value}');
        if (!_isClosed) {
          emit(state.copyWith(
            vehicleVerification: UIState.success(result.value),
          ));
        }
      } else {
        print('❌ Vehicle verification failed: ${result.runtimeType}');
        if (result is Error) {
          print('❌ Error type: ${(result as Error).type}');
        }
        if (!_isClosed) {
          emit(state.copyWith(
            vehicleVerification: UIState.error(result is Error ? (result as Error).type : GenericError()),
          ));
        }
      }
    } catch (e) {
      print('💥 Vehicle verification exception: $e');
      if (!_isClosed) {
        emit(state.copyWith(
          vehicleVerification: UIState.error(GenericError()),
        ));
      }
    }
  }

  /// Reset vehicle verification state
  void resetVehicleVerification() {
    if (!_isClosed) {
      emit(state.copyWith(
        vehicleVerification: UIState.initial(),
      ));
    }
  }
} 