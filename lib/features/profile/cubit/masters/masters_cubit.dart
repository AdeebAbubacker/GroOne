import 'dart:io';

import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/kyc/model/create_document_model.dart';
import 'package:gro_one_app/features/kyc/model/delete_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_license_document_model.dart';
import 'package:gro_one_app/features/kyc/repository/kyc_repository.dart';
import 'package:gro_one_app/features/profile/api_request/license_vahan_request.dart';
import 'package:gro_one_app/features/profile/model/edit_user_response.dart';
import 'package:gro_one_app/features/profile/repository/profile_repository.dart';
part 'masters_state.dart';



class MastersCubit extends BaseCubit<MastersState> {
  final ProfileRepository _repository;
  final KycRepository _kycrepo;
  MastersCubit(this._repository,this._kycrepo) : super(MastersState.initial());



  void resetVehicleVerification() {
    emit(state.copyWith(
      vehicleVerification: UIState.initial(),
    ));
  }

    void resetLicenseVerification() {
    emit(state.copyWith(
       uploadlicenseDocUIState: resetUIState<UploadLicenseDocumentModel>(state.uploadlicenseDocUIState),
      licenseVerification: UIState.initial(),
    ));
  }


  Future<Result<Map<String, dynamic>>> fetchAndVerifyVehicle(String vehicleNumber) async {
    emit(state.copyWith(vehicleVerification: UIState.loading()));

    final result = await _repository.fetchVehicleData(vehicleNumber);

    if (result is Success<Map<String, dynamic>>) {
      emit(state.copyWith(vehicleVerification: UIState.success(true)));
      return result;
    } else {
      emit(state.copyWith(vehicleVerification: UIState.error(GenericError())));
      return Error(GenericError());
    }
  }

    Future<Result<Map<String, dynamic>>> fetchAndVerifyLicense({required LicenseVahanRequest  licensereq}) async {
    emit(state.copyWith(licenseVerification: UIState.loading()));

    final result = await _repository.fetchLicenseData(licensereq: licensereq);

    if (result is Success<Map<String, dynamic>>) {
      emit(state.copyWith(licenseVerification: UIState.success(true)));
      return result;
    } else {
      emit(state.copyWith(licenseVerification: UIState.error(GenericError())));
      return Error(GenericError());
    }
  }

    // // Upload GST File
  void _setLicenseDocUIState(UIState<UploadLicenseDocumentModel>? uiState){
    emit(state.copyWith(uploadlicenseDocUIState: uiState));
  }

  // Upload Edit user UIState
  void _setEditUserUIState(UIState<EditUserResponse>? uiState){
    emit(state.copyWith(editUserUIState: uiState));
  }

  Future<void> uploadLicenseDoc(File file) async {
    _setLicenseDocUIState(UIState.loading());
    Result result = await _repository.postUploadLicenseData(file);
    if (result is Success<UploadLicenseDocumentModel>) {
      _setLicenseDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setLicenseDocUIState(UIState.error(result.type));
    }
  }


  Future<void> updatePreferLanes(List<int> preferredLanes) async {
    _setEditUserUIState(UIState.loading());
    Result result = await _repository.updatePreferredLanes( preferredLanes: preferredLanes);
    if (result is Success<EditUserResponse>) {
      _setEditUserUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setEditUserUIState(UIState.error(result.type));
    }
  }


  // Create Document
  void _setCreateDocumentUIState(UIState<CreateDocumentModel>? uiState){
    emit(state.copyWith(createDocumentUIState: uiState));
  }
  Future<void> createDocument(CreateDocumentApiRequest request) async {
    _setCreateDocumentUIState(UIState.loading());
    Result result = await _kycrepo.getCreateDocumentData(request);
    if (result is Success<CreateDocumentModel>) {
      _setCreateDocumentUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateDocumentUIState(UIState.error(result.type));
    }
  }


  // Delete Document
  void _setDeleteDocumentUIState(UIState<DeleteDocumentModel>? uiState){
    emit(state.copyWith(deleteDocumentUIState: uiState));
  }
  Future<void> deleteDocument(String documentId) async {
    _setDeleteDocumentUIState(UIState.loading());
    Result result = await _kycrepo.getDeleteDocumentData(documentId);
    if (result is Success<DeleteDocumentModel>) {
      _setDeleteDocumentUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setDeleteDocumentUIState(UIState.error(result.type));
    }
  }

}
