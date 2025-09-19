// fastag_cubit.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/fastag/model/fastag_pincode_verify_model.dart';
import '../../en-dhan_fuel/model/document_upload_response.dart';
import '../model/fastag_list_response.dart';
import '../repository/fastag_repository.dart';

part 'fastag_state.dart';

class FastagCubit extends Cubit<FastagState> {
  final FastagRepository _repository;

  FastagCubit(this._repository) : super(FastagState.initial());

  /// Upload document
  Future<DocumentUploadResponse?> uploadDocument(File file) async {
    emit(state.copyWith(documentUploadUIState: UIState.loading()));

    try {
      final result = await _repository.uploadDocument(file);

      if (result is Success<DocumentUploadResponse>) {
        emit(
          state.copyWith(documentUploadUIState: UIState.success(result.value)),
        );
        return result.value;
      } else if (result is Error<DocumentUploadResponse>) {
        emit(state.copyWith(documentUploadUIState: UIState.error(result.type)));
        return null;
      }
    } catch (_) {
      emit(
        state.copyWith(documentUploadUIState: UIState.error(GenericError())),
      );
    }
    return null;
  }

  void updateFrontRc(int index, List<Map<String, String>> newList) {
    final updated = List<List<Map<String, String>>>.from(
      state.frontRcDocuments,
    );

    // Ensure list is long enough
    while (updated.length <= index) {
      updated.add([]);
    }

    updated[index] = newList;

    emit(state.copyWith(frontRcDocuments: updated));
  }

  void updateBackRc(int index, List<Map<String, String>> newList) {
    final updated = List<List<Map<String, String>>>.from(state.backRcDocuments);

    while (updated.length <= index) {
      updated.add([]);
    }

    updated[index] = newList;

    emit(state.copyWith(backRcDocuments: updated));
  }

  void setFrontRcUploaded(bool value) =>
      emit(state.copyWith(isFrontRcUploaded: value));

  void setBackRcUploaded(bool value) =>
      emit(state.copyWith(isBackRcUploaded: value));

  Future<Result<bool>> placeFastagOrder({
    required String referralCode,
    required String addressName,
    required String address,
    required String city,
    required String stateName, // rename here
    required String pincode,
    required String contactNo,
    required List<Map<String, String>> vehicles,
  }) async {
    emit(state.copyWith(documentUploadUIState: UIState.loading()));

    final result = await _repository.addVehicleRequest(
      referralCode: referralCode,
      addressName: addressName,
      address: address,
      city: city,
      state: stateName,
      pincode: pincode,
      contactNo: contactNo,
      vehicles: vehicles,
    );

    if (result is Success) {
      emit(state.copyWith(documentUploadUIState: UIState.success(null)));
    } else if (result is Error<bool>) {
      emit(state.copyWith(documentUploadUIState: UIState.error(result.type)));
    }

    return result;
  }

  Future<void> fetchFastagList({
    String searchTerm = '',
    bool isInitialLoad = false,
    int page = 1,
  }) async {
    emit(
      state.copyWith(
        fastagListUIState: UIState.loading(),
        shouldNavigateToBuyFastag: false, // reset flag
      ),
    );

    final result = await _repository.getFastagList(
      searchTerm: searchTerm,
      page: page,
    );

    if (result is Success<FastagListResponse>) {
      final list = result.value.data;

      // Only trigger navigation if this is the first load & list is empty
      if (isInitialLoad && list.isEmpty) {
        emit(
          state.copyWith(
            fastagListUIState: UIState.success(result.value),
            shouldNavigateToBuyFastag: true,
          ),
        );
        return;
      } else {
        emit(state.copyWith(fastagListUIState: UIState.success(result.value)));
      }
    } else if (result is Error<FastagListResponse>) {
      emit(state.copyWith(fastagListUIState: UIState.error(result.type)));
    }
  }

  /// Verify pincode
  Future<FleetPincodeVerifyModel?> verifyPincode(String pincode) async {
    emit(state.copyWith(pincodeVerifyUIState: UIState.loading()));

    try {
      final result = await _repository.verifyPincode(pincode);

      if (result is Success<FleetPincodeVerifyModel>) {
        emit(
          state.copyWith(pincodeVerifyUIState: UIState.success(result.value)),
        );
        return result.value;
      } else if (result is Error<FleetPincodeVerifyModel>) {
        emit(state.copyWith(pincodeVerifyUIState: UIState.error(result.type)));
        return null;
      }
    } catch (_) {
      emit(state.copyWith(pincodeVerifyUIState: UIState.error(GenericError())));
    }
    return null;
  }

  void resetRcDocuments({int vehicleCount = 1}) {
    emit(
      state.copyWith(
        isFrontRcUploaded: false,
        isBackRcUploaded: false,
        frontRcDocuments: List.generate(vehicleCount, (_) => []),
        backRcDocuments: List.generate(vehicleCount, (_) => []),
      ),
    );
  }

  void addVehicleDocs() {
    final newFrontDocs = List<List<Map<String, String>>>.from(
      state.frontRcDocuments,
    );
    final newBackDocs = List<List<Map<String, String>>>.from(
      state.backRcDocuments,
    );

    newFrontDocs.add([]); // empty slot
    newBackDocs.add([]); // empty slot

    emit(
      state.copyWith(
        frontRcDocuments: newFrontDocs,
        backRcDocuments: newBackDocs,
      ),
    );
  }
}
