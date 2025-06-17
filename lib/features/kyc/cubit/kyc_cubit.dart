import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_verify_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_pan_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_tan_request.dart';
import 'package:gro_one_app/features/kyc/enum/kyc_document_type.dart';
import 'package:gro_one_app/features/kyc/model/addhar_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/file_upload_response.dart';
import 'package:gro_one_app/features/kyc/model/submit_kyc_response.dart';
import 'package:gro_one_app/features/kyc/model/upload_cancelled_check_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_gstin_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_pan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tds_document_model.dart';
import 'package:gro_one_app/features/kyc/model/verify_gst_response.dart';
import 'package:gro_one_app/features/kyc/model/verify_pan_response.dart';
import 'package:gro_one_app/features/kyc/model/verify_tan_response.dart';
import 'package:gro_one_app/features/kyc/repository/kyc_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
part 'kyc_state.dart';

class KycCubit extends Cubit<KycState> {
  final KycRepository _kycRepository;
  final UserInformationRepository _userInformationRepository;
  KycCubit(this._kycRepository, this._userInformationRepository) : super(KycState());


  // fetch user role
  String? userRole;
  Future<String?> fetchUserRole() async {
    userRole = await _userInformationRepository.getUserRole();
    return userRole;
  }


  // fetch user if
  String? userId;
  Future<String?> fetchUserId() async {
    userId = await _userInformationRepository.getUserID();
    return userId;
  }


  // fetch company Type Id
  String? companyTypeId;
  Future<String?> fetchCompanyTypeId() async {
    companyTypeId = await _userInformationRepository.getCustomerTypeID();
    return companyTypeId;
  }


  // Send Aadhaar Otp
  Future<void> sendAadhaarOtp(AddharOtpApiRequest request) async {
    emit(state.copyWith(aadhaarOtpState: UIState.loading()));
    Result result = await _kycRepository.kycSendOtp(request);
    if (result is Success<AadhaarOtpModel>) {
      emit(state.copyWith(aadhaarOtpState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(aadhaarOtpState: UIState.error(result.type)));
    }
  }

  // Verify Aadhaar Otp
  Future<void> verifyAadhaarOtp(AddharVerifyOtpApiRequest request) async {
    emit(state.copyWith(aadhaarVerifyOtpState: UIState.loading()));
    Result result = await _kycRepository.verifyAddharOtp(request);
    if (result is Success<AadhaarVerifyOtpModel>) {
      emit(state.copyWith(aadhaarVerifyOtpState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(aadhaarVerifyOtpState: UIState.error(result.type)));
    }
  }

  // Verify Gst
  Future<void> verifyGst(VerifyGstApiRequest request) async {
    emit(state.copyWith(gstState: UIState.loading()));
    Result result = await _kycRepository.verifyGST(request);
    if (result is Success<bool>) {
      emit(state.copyWith(gstState: UIState.success(result.value)));
      emit(state.copyWith(verifiedGst: true));
    }
    if (result is Error) {
      emit(state.copyWith(gstState: UIState.error(result.type)));
    }
  }

  // Verify Tan
  Future<void> verifyTan(VerifyTanApiRequest request) async {
    emit(state.copyWith(tanState: UIState.loading()));
    Result result = await _kycRepository.verifyTan(request);
    if (result is Success<bool>) {
      emit(state.copyWith(tanState: UIState.success(result.value)));
      emit(state.copyWith(verifiedTan: true));
    }
    if (result is Error) {
      emit(state.copyWith(tanState: UIState.error(result.type)));
    }
  }

  // Verify Pan
  Future<void> verifyPan(VerifyPanApiRequest request) async {
    emit(state.copyWith(panState: UIState.loading()));
    Result result = await _kycRepository.verifyPan(request);
    if (result is Success<bool>) {
      emit(state.copyWith(panState: UIState.success(result.value)));
      emit(state.copyWith(verifiedPan: true));
    }
    if (result is Error) {
      emit(state.copyWith(panState: UIState.error(result.type)));
    }
  }


  // // Upload GST File
  void _setUploadGstDocUIState(UIState<UploadGSTDocumentModel>? uiState){
    emit(state.copyWith(uploadGSTDocUIState: uiState));
  }
  Future<void> uploadGstDoc(File file) async {
    _setUploadGstDocUIState(UIState.loading());
    Result result = await _kycRepository.getUploadGstData(file);
    if (result is Success<UploadGSTDocumentModel>) {
      _setUploadGstDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadGstDocUIState(UIState.error(result.type));
    }
  }


  // // Upload TAN File
  void _setUploadTanDocUIState(UIState<UploadTANDocumentModel>? uiState){
    emit(state.copyWith(uploadTanDocUIState: uiState));
  }
  Future<void> uploadTanDoc(File file) async {
    _setUploadTanDocUIState(UIState.loading());
    Result result = await _kycRepository.getUploadTanData(file);
    if (result is Success<UploadTANDocumentModel>) {
      _setUploadTanDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadTanDocUIState(UIState.error(result.type));
    }
  }


  // // Upload PAN File
  void _setUploadPanDocUIState(UIState<UploadPANDocumentModel>? uiState){
    emit(state.copyWith(uploadPanDocUIState: uiState));
  }
  Future<void> uploadPanDoc(File file) async {
    _setUploadPanDocUIState(UIState.loading());
    Result result = await _kycRepository.getUploadPanData(file);
    if (result is Success<UploadPANDocumentModel>) {
      _setUploadPanDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadPanDocUIState(UIState.error(result.type));
    }
  }


  // // Upload TDS File
  void _setUploadTdsDocUIState(UIState<UploadTDSDocumentModel>? uiState){
    emit(state.copyWith(uploadTDSDocUIState: uiState));
  }
  Future<void> uploadTdsDoc(File file) async {
    _setUploadTdsDocUIState(UIState.loading());
    Result result = await _kycRepository.getUploadTdsData(file);
    if (result is Success<UploadTDSDocumentModel>) {
      _setUploadTdsDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadTdsDocUIState(UIState.error(result.type));
    }
  }


  // // Upload TDS File
  void _setUploadCancelledCheckDocUIState(UIState<UploadCancelledCheckedDocumentModel>? uiState){
    emit(state.copyWith(uploadCancelledUIState: uiState));
  }
  Future<void> uploadCancelledCheckDoc(File file) async {
    _setUploadCancelledCheckDocUIState(UIState.loading());
    Result result = await _kycRepository.getUploadCancelledCheckedData(file);
    if (result is Success<UploadCancelledCheckedDocumentModel>) {
      _setUploadCancelledCheckDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadCancelledCheckDocUIState(UIState.error(result.type));
    }
  }





  // Submit Kyc
  Future<void> submitKyc(SubmitKycApiRequest request, String userId) async {
    emit(state.copyWith(submitKycState: UIState.loading()));
    Result result = await _kycRepository.submitKyc(request, userId: userId);
    if (result is Success<SubmitKycModel>) {
      emit(state.copyWith(submitKycState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(submitKycState: UIState.error(result.type)));
    }
  }

  void resetState() {
    emit(KycState());
  }

}